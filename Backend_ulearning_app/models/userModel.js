import mongoose from "mongoose";

const userSchema = new mongoose.Schema(
  {
    name: {
      type: String,
      required: true,
    },
    email: {
      type: String,
      required: true,
    },
    password: {
      type: String,
      required: true,
    },
    avatar: {
      type: String,
    },
    type: {
      type: String,
    },
    open_id: {
      type: String,
    },
    token: {
      type: String,
    },
    mycourse: [
      {
        type: mongoose.Schema.Types.ObjectId,
        ref: "Course",
      },
    ],
    friends: [{ type: mongoose.Schema.Types.ObjectId, ref: "user" }],
    friendRequests: [{ type: mongoose.Schema.Types.ObjectId, ref: "user" }],
    mydevice: {
      type: String,
      default: null,
    },
  },
  {
    timestamps: true,
  }
);
const userModel = mongoose.models.user || mongoose.model("user", userSchema);
export default userModel;
