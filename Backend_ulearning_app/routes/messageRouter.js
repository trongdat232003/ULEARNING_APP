// routes/messageRoutes.js
import express from "express";
import { sendMessage, getMessages } from "../controllers/messageController.js";
import { authMiddleware } from "../middlewares/verifyToken.js";

const router = express.Router();

// API gửi tin nhắn
router.post("/send", authMiddleware, sendMessage);

// API lấy tin nhắn giữa 2 người dùng
router.get("/messages", authMiddleware, getMessages);

export default router;
