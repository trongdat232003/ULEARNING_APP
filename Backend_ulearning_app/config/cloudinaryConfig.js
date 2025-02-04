import { v2 as cloudinary } from "cloudinary";

cloudinary.config({
  cloud_name: "dluwhbsel", // Thay bằng Cloud Name của bạn
  api_key: "164868145516717", // Thay bằng API Key của bạn
  api_secret: "3j_wIiiYPmTGugr9TOpLKV_TkGA", // Thay bằng API Secret của bạn
});

export default cloudinary;
