import courseTypeModel from "../models/courseTypeModel.js";

const createCourseType = async (req, res) => {
  try {
    const { title, description, order } = req.body;
    const existingCourseType = await courseTypeModel.findOne({ title });
    if (existingCourseType) {
      return res.status(400).json({ message: "loại khóa học đã tồn tại" });
    }
    const newCourseType = new courseTypeModel({
      title,
      description,
      order,
    });
    await newCourseType.save();
    res
      .status(201)
      .json({ message: "Tạo thành công loại khóa học.", newCourseType });
  } catch (error) {
    console.error("Lỗi đăng ký:", error);
    res.status(500).json({ message: "Đã xảy ra lỗi." });
  }
};
// Update a course type
const updateCourseType = async (req, res) => {
  try {
    const { id } = req.params;
    const { title, description, order } = req.body;

    const courseType = await courseTypeModel.findById(id);
    if (!courseType) {
      return res.status(404).json({ message: "Loại khóa học không tồn tại." });
    }

    courseType.title = title || courseType.title;
    courseType.description = description || courseType.description;
    courseType.order = order || courseType.order;

    await courseType.save();
    res
      .status(200)
      .json({ message: "Cập nhật thành công loại khóa học.", courseType });
  } catch (error) {
    console.error("Lỗi cập nhật:", error);
    res.status(500).json({ message: "Đã xảy ra lỗi." });
  }
};

// Soft delete a course type
const deleteCourseType = async (req, res) => {
  try {
    const { id } = req.params;

    const courseType = await courseTypeModel.findById(id);
    if (!courseType) {
      return res.status(404).json({ message: "Loại khóa học không tồn tại." });
    }

    courseType.deleted = true;
    await courseType.save();

    res.status(200).json({ message: "Xóa thành công loại khóa học." });
  } catch (error) {
    console.error("Lỗi xóa:", error);
    res.status(500).json({ message: "Đã xảy ra lỗi." });
  }
};
export { createCourseType, updateCourseType, deleteCourseType };
