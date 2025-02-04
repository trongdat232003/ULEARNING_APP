import mongoose from "mongoose";

const courseTypeSchema = new mongoose.Schema(
  {
    title: {
      type: String,
      required: true,
    },
    description: {
      type: String,
      required: true,
    },
    order: {
      type: Number,
      required: true,
    },
    deleted: {
      type: Boolean,
      default: false,
    },
  },
  {
    timestamps: true,
  }
);
const courseTypeModel =
  mongoose.models.courseType || mongoose.model("courseType", courseTypeSchema);
export default courseTypeModel;
