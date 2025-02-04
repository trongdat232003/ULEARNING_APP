import express from "express";
import { authMiddleware } from "../middlewares/verifyToken.js";
import {
  sendFriendRequest,
  acceptFriendRequest,
  rejectFriendRequest,
  removeFriend,
  getFriendRequests,
  getFriends,
} from "../controllers/userController.js";

const router = express.Router();

router.post("/send", authMiddleware, sendFriendRequest);
router.post("/accept", authMiddleware, acceptFriendRequest);
router.post("/reject", authMiddleware, rejectFriendRequest);
router.post("/remove", authMiddleware, removeFriend);
router.get("/requests", authMiddleware, getFriendRequests);
router.get("/friends", authMiddleware, getFriends);
export default router;
