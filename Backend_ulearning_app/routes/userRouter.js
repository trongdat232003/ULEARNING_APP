import express from "express";
import {
  registerUser,
  loginUser,
  getUserProfile,
} from "../controllers/userController.js";
import { authMiddleware } from "../middlewares/verifyToken.js";
const router = express.Router();

// Đăng ký người dùng
router.post("/register", registerUser);

// Đăng nhập người dùng
router.post("/login", loginUser);
// Lấy thông tin người dùng
router.get("/profile", authMiddleware, getUserProfile);
export default router;
