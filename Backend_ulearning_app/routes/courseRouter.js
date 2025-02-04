import express from "express";
import upload from "../config/multerConfig.js";
import multer from "multer";
import {
  createCourse,
  updateCourse,
  deletedCourse,
  getCourses,
  getCoursesDetails,
  processPayment,
  searchCourses,
} from "../controllers/courseController.js";
import { authMiddleware } from "../middlewares/verifyToken.js";
const storage = multer.diskStorage({});
const uploads = multer({ storage });
const router = express.Router();
router.post(
  "/create",
  upload.fields([
    { name: "thumbnail", maxCount: 1 },
    { name: "video", maxCount: 1 },
  ]),
  createCourse
);

router.patch(
  "/update/:id",
  upload.fields([
    { name: "thumbnail", maxCount: 1 },
    { name: "video", maxCount: 1 },
  ]),
  updateCourse
);
router.delete("/delete/:id", deletedCourse);
// Thêm route lấy danh sách khóa học
router.get("/list", authMiddleware, getCourses);
router.get("/details/:id", authMiddleware, getCoursesDetails);
router.post("/checkout/:id", authMiddleware, processPayment);
router.get("/search", authMiddleware, searchCourses);
export default router;
