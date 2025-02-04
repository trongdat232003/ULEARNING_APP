import multer from "multer";
import { v2 as cloudinary } from "cloudinary";
import { CloudinaryStorage } from "multer-storage-cloudinary";

cloudinary.config({
  cloud_name: "dluwhbsel", // Thay bằng Cloud Name của bạn
  api_key: "164868145516717", // Thay bằng API Key của bạn
  api_secret: "3j_wIiiYPmTGugr9TOpLKV_TkGA", // Thay bằng API Secret của bạn
});

// Cấu hình Multer để sử dụng CloudinaryStorage
const storage = new CloudinaryStorage({
  cloudinary: cloudinary,
  params: {
    folder: "your-folder-name", // Thư mục lưu trữ trên Cloudinary
    allowed_formats: ["jpg", "png", "mp4"], // Các định dạng file cho phép
    resource_type: "auto", // Hỗ trợ tự động xác định loại file
  },
});

const upload = multer({ storage });

export default upload;
