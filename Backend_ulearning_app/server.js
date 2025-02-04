import express from "express";
import mongoose from "mongoose";
import dotenv from "dotenv";
import userRouter from "./routes/userRouter.js";
import courseTypeRouter from "./routes/courseTypeRouter.js";
import courseRouter from "./routes/courseRouter.js";
import bodyParser from "body-parser";
import { createServer } from "http";
import { Server } from "socket.io";
import friendRoutes from "./routes/friendRoutes.js";
import messageRouter from "./routes/messageRouter.js";
const app = express();
const server = createServer(app);
const io = new Server(server, {
  cors: {
    origin: "*",
  },
});
// Lưu danh sách người dùng đang kết nối
const onlineUsers = new Map();

io.on("connection", (socket) => {
  console.log("A user connected:", socket.id);

  // Đăng ký user khi kết nối
  socket.on("register", (userId) => {
    console.log(`📌 User registered: ${userId} with socket ID: ${socket.id}`);
    onlineUsers.set(userId, socket.id);
  });

  // Xử lý khi nhận tin nhắn
  socket.on("sendMessage", ({ senderId, receiverId, content }) => {
    console.log(
      `📩 Message received from ${senderId} to ${receiverId}: ${content}`
    );
    // Thêm timestamp vào tin nhắn
    const timestamp = new Date().toISOString();
    const receiverSocketId = onlineUsers.get(receiverId);
    if (receiverSocketId) {
      io.to(receiverSocketId).emit("receiveMessage", {
        senderId,
        receiverId,
        content,
        timestamp,
      });
    } else {
      console.log(`⚠️ Receiver ${receiverId} is not online`);
    }
  });

  // Xử lý khi user disconnect
  socket.on("disconnect", () => {
    console.log("User disconnected:", socket.id);
    for (let [key, value] of onlineUsers) {
      if (value === socket.id) {
        console.log(`🗑 Removing user ${key} from online users`);
        onlineUsers.delete(key);
        break;
      }
    }
  });
});

server.listen(3000, () => console.log("Server running on port 3000"));
dotenv.config();
// Middleware
app.use(bodyParser.json());

// Connect MongoDB
const PORT = process.env.PORT || 7000;
const MONGOURL = process.env.MONGOURL;
console.log(PORT, MONGOURL);

mongoose
  .connect(MONGOURL)
  .then(() => {
    console.log("MongoDB connected successfully");
    app.listen(PORT, () => {
      console.log(`Server running on port ${PORT}`);
    });
  })
  .catch((error) => {
    console.error("MongoDB connection error:", error);
  });

// Routes
app.use("/api/users", userRouter);
app.use("/api/courseType", courseTypeRouter);
app.use("/api/courses", courseRouter);
app.use("/api/friends", friendRoutes);
app.use("/api/messages", messageRouter);
