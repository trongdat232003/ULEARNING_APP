import jwt from "jsonwebtoken";

const authMiddleware = (req, res, next) => {
  const token = req.header("Authorization"); // Chỉ lấy token trực tiếp

  if (!token) {
    return res.status(401).json({ message: "Bạn cần đăng nhập để truy cập." });
  }

  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    req.userId = decoded.id; // Lưu userId vào request để sử dụng sau
    next(); // Tiếp tục tới controller
  } catch (error) {
    return res.status(401).json({ message: "Token không hợp lệ." });
  }
};
export { authMiddleware };
