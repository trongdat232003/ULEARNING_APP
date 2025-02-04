import mongoose from "mongoose";

const courseSchema = new mongoose.Schema(
  {
    name: {
      type: String,
      required: true,
      maxlength: 200,
    },
    thumbnail: {
      type: String,
      maxlength: 150,
    },
    video: {
      type: String,
      maxlength: 150,
    },
    description: {
      type: String,
    },
    type_id: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "CourseType",
      required: true,
    },
    price: {
      type: Number,
      required: true,
    },
    lesson_num: {
      type: Number,
      required: true,
    },
    video_length: {
      type: Number,
      required: true,
    },
    follow: {
      type: Number,
      default: 0,
    },
    score: {
      type: Number,
      default: 0,
    },
    deleted: {
      type: Boolean,
      default: false,
    },
    download: {
      type: Number,
      default: 0,
    },
  },
  { timestamps: true }
);

const Course = mongoose.model("Course", courseSchema);
export default Course;
