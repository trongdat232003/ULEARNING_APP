import admin from "firebase-admin";
import serviceAccount from "../Backend_ulearning_app/google-services.json"; // Tải từ Firebase Console

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

export default admin;
