import express from "express";
import {
  createCourseType,
  updateCourseType,
  deleteCourseType,
} from "../controllers/courseTypeController.js";
const router = express.Router();
router.post("/create", createCourseType);
router.patch("/update/:id", updateCourseType);
router.delete("/delete/:id", deleteCourseType);
export default router;
