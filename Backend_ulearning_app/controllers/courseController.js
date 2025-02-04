import Stripe from "stripe";
import Course from "../models/courseModel.js";
import courseTypeModel from "../models/courseTypeModel.js";
import userModel from "../models/userModel.js";
import mongoose from "mongoose";

const stripe = new Stripe(
  "sk_test_51PqFXIGzD8T2gqhvhy1R5c4RkevpL4BFyKAVZe6PhvPK8wwo1Q8PY3YwTfxZsd6szj8TBY9js3iZUHXuEKAxWTtZ009DbeQVGL"
);
const createCourse = async (req, res) => {
  try {
    const {
      user_token,
      name,
      description,
      type_id,
      price,
      lesson_num,
      video_length,
    } = req.body;

    if (!name || !type_id || !price || !lesson_num || !video_length) {
      return res.status(400).json({ message: "Thiếu thông tin bắt buộc." });
    }

    const { thumbnail, video } = req.files;
    if (!thumbnail || !video) {
      return res
        .status(400)
        .json({ message: "Hình ảnh và video là bắt buộc." });
    }

    // Lấy URL từ Cloudinary
    const thumbnailUrl = thumbnail[0].path;
    const videoUrl = video[0].path;
    const newCourse = new Course({
      user_token,
      name,
      description,
      type_id,
      price,
      lesson_num,
      video_length,
      thumbnail: thumbnailUrl,
      video: videoUrl,
    });

    await newCourse.save();

    res.status(201).json({
      message: "Tạo khóa học thành công.",
      course: newCourse,
    });
  } catch (error) {
    console.error("Lỗi tạo khóa học:", error);
    res.status(500).json({ message: "Đã xảy ra lỗi.", error });
  }
};

const updateCourse = async (req, res) => {
  try {
    const { id } = req.params;
    const {
      name,
      description,
      type_id,
      price,
      lesson_num,
      video_length,
      follow,
      score,
    } = req.body;

    // Lấy thông tin file từ Multer
    const thumbnailFile = req.files?.thumbnail?.[0];
    const videoFile = req.files?.video?.[0];

    // Tìm khóa học
    const course = await Course.findById(id);
    if (!course) {
      return res.status(404).json({ message: "Khóa học không tồn tại." });
    }

    // Cập nhật thông tin
    course.name = name || course.name;
    course.description = description || course.description;
    course.type_id = type_id || course.type_id;
    course.price = price || course.price;
    course.lesson_num = lesson_num || course.lesson_num;
    course.video_length = video_length || course.video_length;
    course.follow = follow || course.follow;
    course.score = score || course.score;

    // Nếu có file mới, cập nhật URL từ Cloudinary
    if (thumbnailFile) {
      course.thumbnail = thumbnailFile.path; // URL từ Cloudinary
    }
    if (videoFile) {
      course.video = videoFile.path; // URL từ Cloudinary
    }

    // Lưu lại khóa học
    await course.save();

    res.status(200).json({
      message: "Cập nhật thành công khóa học.",
      course,
    });
  } catch (error) {
    console.error("Lỗi cập nhật khóa học:", error);
    res.status(500).json({ message: "Đã xảy ra lỗi." });
  }
};

// Soft delete a course
const deletedCourse = async (req, res) => {
  try {
    const { id } = req.params;

    const course = await Course.findById(id);
    if (!course) {
      return res.status(404).json({ message: "Khóa học không tồn tại." });
    }

    course.deleted = true;
    await course.save();

    res.status(200).json({ message: "Xóa thành công khóa học." });
  } catch (error) {
    console.error("Lỗi xóa khóa học:", error);
    res.status(500).json({ message: "Đã xảy ra lỗi." });
  }
};
// Lấy danh sách tất cả khóa học
const getCourses = async (req, res) => {
  try {
    const courses = await Course.find({ deleted: false });

    res.status(200).json({
      message: "Danh sách các khóa học.",
      courses,
    });
  } catch (error) {
    console.error("Lỗi khi lấy danh sách khóa học:", error);
    res
      .status(500)
      .json({ message: "Đã xảy ra lỗi khi lấy danh sách khóa học." });
  }
};
// Lấy danh sách tất cả khóa học
const getCoursesDetails = async (req, res) => {
  try {
    const { id } = req.params;
    const courses = await Course.findById(id);
    if (courses) {
      res.status(200).json({
        message: "Chi tiết khóa học.",
        courses,
      });
    }
  } catch (error) {
    console.error("Lỗi khi lấy danh sách khóa học:", error);
    res
      .status(500)
      .json({ message: "Đã xảy ra lỗi khi lấy danh sách khóa học." });
  }
};

const processPayment = async (req, res) => {
  const { id } = req.params; // ID của khóa học
  const userId = req.userId; // ID người dùng đã được xác thực

  try {
    // Tìm khóa học từ cơ sở dữ liệu
    const course = await Course.findById(id);
    if (!course) {
      return res.status(404).json({ message: "Course not found" });
    }

    // Tạo Checkout Session
    const session = await stripe.checkout.sessions.create({
      payment_method_types: ["card"], // Loại thanh toán được hỗ trợ
      line_items: [
        {
          price_data: {
            currency: "usd",
            product_data: {
              name: course.name,
            },
            unit_amount: course.price * 100, // Giá (đơn vị nhỏ nhất)
          },
          quantity: 1,
        },
      ],
      mode: "payment",
      success_url: `http://localhost:3000/success?courseId=${id}`, // URL thành công
      cancel_url: "http://localhost:3000/cancel", // URL hủy
    });

    // Trả về URL của trang thanh toán
    res.status(200).json({ url: session.url });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: error.message });
  }
};

const searchCourses = async (req, res) => {
  try {
    const { name } = req.query; // Lấy từ khóa tìm kiếm từ query

    if (!name) {
      return res
        .status(400)
        .json({ message: "Vui lòng nhập từ khóa để tìm kiếm." });
    }

    // Tìm kiếm các khóa học có tên chứa từ khóa (không phân biệt chữ hoa/thường)
    const courses = await Course.find({
      name: { $regex: name, $options: "i" }, // $regex: tìm kiếm với biểu thức chính quy, $options: "i" để không phân biệt hoa/thường
      deleted: false, // Bỏ qua các khóa học đã bị xóa
    });

    if (courses.length === 0) {
      return res
        .status(404)
        .json({ message: "Không tìm thấy khóa học phù hợp." });
    }

    res.status(200).json({
      message: "Danh sách khóa học phù hợp.",
      courses,
    });
  } catch (error) {
    console.error("Lỗi khi tìm kiếm khóa học:", error);
    res.status(500).json({ message: "Đã xảy ra lỗi khi tìm kiếm khóa học." });
  }
};

export {
  createCourse,
  updateCourse,
  deletedCourse,
  getCourses,
  getCoursesDetails,
  processPayment,
  searchCourses,
};
