import bcrypt from "bcrypt";
import jwt from "jsonwebtoken";
import userModel from "../models/userModel.js";
const registerUser = async (req, res) => {
  try {
    const { name, email, password, avatar, type } = req.body;
    console.log("REquest body", req.body);

    // Kiểm tra nếu người dùng đã tồn tại
    const existingUser = await userModel.findOne({ email });
    if (existingUser) {
      return res.status(400).json({ message: "Email đã được sử dụng." });
    }

    // Mã hoá mật khẩu
    const hashedPassword = await bcrypt.hash(password, 10);

    // Tạo người dùng mới
    const newUser = new userModel({
      name,
      email,
      password: hashedPassword,
      avatar,
      type,
    });

    await newUser.save();
    res.status(201).json({ message: "Đăng ký thành công.", newUser });
  } catch (error) {
    console.error("Lỗi đăng ký:", error);
    res.status(500).json({ message: "Đã xảy ra lỗi." });
  }
};

const loginUser = async (req, res) => {
  try {
    const { email, password } = req.body;

    // Tìm người dùng theo email
    const user = await userModel.findOne({ email });
    if (!user) {
      return res.status(404).json({ message: "Email không tồn tại." });
    }

    // So sánh mật khẩu
    const isPasswordValid = await bcrypt.compare(password, user.password);
    if (!isPasswordValid) {
      return res.status(401).json({ message: "Mật khẩu không đúng." });
    }

    // Tạo JWT
    const token = jwt.sign(
      { id: user._id, email: user.email, type: user.type },
      process.env.JWT_SECRET,
      { expiresIn: "1d" } // Token hết hạn sau 1 ngày
    );

    res.status(200).json({
      message: "Đăng nhập thành công.",
      user: {
        id: user._id,
        name: user.name,
        email: user.email,
        avatar: user.avatar,
        type: user.type,
        token,
      },
      token,
    });
  } catch (error) {
    console.error("Lỗi đăng nhập:", error);
    res.status(500).json({ message: "Đã xảy ra lỗi." });
  }
};
const getUserProfile = async (req, res) => {
  try {
    const userId = req.userId; // Lấy userId từ authMiddleware

    const user = await userModel.findById(userId); // Tìm user trong database

    if (!user) {
      return res.status(404).json({ message: "User không tồn tại" });
    }

    res.status(200).json({
      user: user,
    });
  } catch (error) {
    console.error("Lỗi khi lấy thông tin:", error);
    res.status(500).json({ message: "Đã xảy ra lỗi." });
  }
};

const sendFriendRequest = async (req, res) => {
  try {
    const { receiverId } = req.body;
    const senderId = req.userId; // Lấy từ middleware xác thực

    if (senderId === receiverId) {
      return res
        .status(400)
        .json({ message: "Không thể tự gửi lời mời kết bạn." });
    }

    const sender = await userModel.findById(senderId);
    const receiver = await userModel.findById(receiverId);

    if (!receiver) {
      return res.status(404).json({ message: "Người dùng không tồn tại." });
    }

    // Kiểm tra nếu đã là bạn bè
    if (sender.friends.includes(receiverId)) {
      return res.status(400).json({ message: "Hai người đã là bạn bè." });
    }

    // Kiểm tra nếu đã gửi lời mời trước đó
    if (receiver.friendRequests.includes(senderId)) {
      return res
        .status(400)
        .json({ message: "Bạn đã gửi lời mời kết bạn trước đó." });
    }

    receiver.friendRequests.push(senderId);
    await receiver.save();

    res.status(200).json({ message: "Gửi lời mời kết bạn thành công." });
  } catch (error) {
    res.status(500).json({ message: "Đã xảy ra lỗi." });
  }
};

// Chấp nhận lời mời kết bạn
const acceptFriendRequest = async (req, res) => {
  try {
    const { senderId } = req.body;
    const receiverId = req.userId;

    const receiver = await userModel.findById(receiverId);
    const sender = await userModel.findById(senderId);

    if (!receiver || !sender) {
      return res.status(404).json({ message: "Người dùng không tồn tại." });
    }

    // Kiểm tra nếu lời mời tồn tại
    if (!receiver.friendRequests.includes(senderId)) {
      return res.status(400).json({ message: "Không có lời mời kết bạn này." });
    }

    // Cập nhật danh sách bạn bè
    receiver.friends.push(senderId);
    sender.friends.push(receiverId);

    // Xóa lời mời kết bạn
    receiver.friendRequests = receiver.friendRequests.filter(
      (id) => id.toString() !== senderId
    );

    await receiver.save();
    await sender.save();

    res.status(200).json({ message: "Đã chấp nhận lời mời kết bạn." });
  } catch (error) {
    res.status(500).json({ message: "Đã xảy ra lỗi." });
  }
};

// Từ chối lời mời kết bạn
const rejectFriendRequest = async (req, res) => {
  try {
    const { senderId } = req.body;
    const receiverId = req.userId;

    const receiver = await userModel.findById(receiverId);

    if (!receiver) {
      return res.status(404).json({ message: "Người dùng không tồn tại." });
    }

    receiver.friendRequests = receiver.friendRequests.filter(
      (id) => id.toString() !== senderId
    );

    await receiver.save();
    res.status(200).json({ message: "Đã từ chối lời mời kết bạn." });
  } catch (error) {
    res.status(500).json({ message: "Đã xảy ra lỗi." });
  }
};

// Hủy kết bạn
const removeFriend = async (req, res) => {
  try {
    const { friendId } = req.body;
    const userId = req.userId;

    const user = await userModel.findById(userId);
    const friend = await userModel.findById(friendId);

    if (!user || !friend) {
      return res.status(404).json({ message: "Người dùng không tồn tại." });
    }

    user.friends = user.friends.filter((id) => id.toString() !== friendId);
    friend.friends = friend.friends.filter((id) => id.toString() !== userId);

    await user.save();
    await friend.save();

    res.status(200).json({ message: "Đã hủy kết bạn." });
  } catch (error) {
    res.status(500).json({ message: "Đã xảy ra lỗi." });
  }
};
// Lấy danh sách lời mời kết bạn
const getFriendRequests = async (req, res) => {
  try {
    const userId = req.userId; // Lấy userId từ authMiddleware

    const user = await userModel
      .findById(userId)
      .populate("friendRequests", "name avatar email"); // Populate để lấy thông tin bạn bè
    if (!user) {
      return res.status(404).json({ message: "User không tồn tại." });
    }

    res.status(200).json({ requests: user.friendRequests });
  } catch (error) {
    console.error("Lỗi khi lấy danh sách lời mời kết bạn:", error);
    res.status(500).json({ message: "Đã xảy ra lỗi." });
  }
};

// Lấy danh sách bạn bè
const getFriends = async (req, res) => {
  try {
    const userId = req.userId; // Lấy userId từ authMiddleware

    const user = await userModel
      .findById(userId)
      .populate("friends", "name avatar email"); // Populate để lấy thông tin bạn bè
    if (!user) {
      return res.status(404).json({ message: "User không tồn tại." });
    }

    res.status(200).json({ friends: user.friends });
  } catch (error) {
    console.error("Lỗi khi lấy danh sách bạn bè:", error);
    res.status(500).json({ message: "Đã xảy ra lỗi." });
  }
};

export {
  registerUser,
  loginUser,
  getUserProfile,
  sendFriendRequest,
  acceptFriendRequest,
  rejectFriendRequest,
  removeFriend,
  getFriendRequests,
  getFriends,
};
