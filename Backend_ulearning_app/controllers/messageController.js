// controllers/messageController.js
import Message from "../models/messageModel.js";
import userModel from "../models/userModel.js";

// Gửi tin nhắn
const sendMessage = async (req, res) => {
  try {
    const { receiverId, content } = req.body;
    const senderId = req.userId; // Lấy senderId từ middleware xác thực người dùng

    if (senderId === receiverId) {
      return res
        .status(400)
        .json({ message: "Không thể gửi tin nhắn cho chính mình." });
    }

    const receiver = await userModel.findById(receiverId);
    if (!receiver) {
      return res.status(404).json({ message: "Người nhận không tồn tại." });
    }

    const newMessage = new Message({
      senderId,
      receiverId,
      content,
      timestamp: new Date(),
    });

    await newMessage.save();
    console.log("Messages with timestamps:", newMessage);
    res.status(200).json({ message: "Tin nhắn đã được gửi thành công." });
  } catch (error) {
    console.error("Lỗi gửi tin nhắn:", error);
    res.status(500).json({ message: "Đã xảy ra lỗi khi gửi tin nhắn." });
  }
};

const getMessages = async (req, res) => {
  try {
    const { senderId, receiverId } = req.query;
    if (!senderId || !receiverId) {
      return res.status(400).json({ message: "Thông tin không đầy đủ." });
    }
    const messages = await Message.find({
      $or: [
        { senderId, receiverId },
        { senderId: receiverId, receiverId: senderId },
      ],
    })
      .sort({ timestamp: 1 }) // Sắp xếp tin nhắn theo thời gian
      .populate("senderId", "name avatar") // Lấy thông tin người gửi
      .populate("receiverId", "name avatar")
      .select("senderId receiverId content timestamp"); // Đảm bảo lấy timestamp
    console.log("Messages with timestamps:", messages);
    res.status(200).json({ messages });
  } catch (error) {
    console.error("Lỗi lấy tin nhắn:", error);
    res.status(500).json({ message: "Đã xảy ra lỗi khi lấy tin nhắn." });
  }
};

export { sendMessage, getMessages };
