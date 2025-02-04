import 'dart:convert';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ChatService {
  static const String apiUrl =
      "http://10.0.2.2:8000/api/messages"; // API Backend
  static const String socketUrl = "http://10.0.2.2:3000"; // WebSocket Server
  late io.Socket socket;
  String token = "";

  ChatService() {
    _loadToken();
  }

  // Load token từ SharedPreferences
  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? "";
    print(token);
  }

  void initSocket(String userId) {
    socket = io.io(socketUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
      'query': {'token': token},
    });

    socket.on('connect', (_) {
      print("✅ Connected to WebSocket");
      socket.emit('register', userId); // Đăng ký user ID ngay khi kết nối
    });

    socket.on('disconnect', (_) {
      print("❌ Disconnected from WebSocket");
    });

    socket.connect();
  }

  void sendMessage(String senderId, String receiverId, String message) {
    if (socket.connected) {
      final data = {
        'senderId': senderId,
        'receiverId': receiverId,
        'content': message,
      };

      socket.emit('sendMessage', data);
      print("📤 Sent message: $data");
    } else {
      print("❌ Socket not connected.");
    }
  }

  void onMessageReceived(Function(Map<String, dynamic>) callback) {
    socket.on('receiveMessage', (data) {
      print("🔔 Received raw message data: $data"); // Kiểm tra dữ liệu nhận
      if (data == null) {
        print("⚠️ Dữ liệu nhận được là null!");
        return;
      }
      if (data is Map<String, dynamic>) {
        print("lllllllllllllllllllllllll");
        callback(data);
      } else {
        try {
          final parsedData = Map<String, dynamic>.from(jsonDecode(data));
          callback(parsedData);
        } catch (e) {
          print("❌ Lỗi khi parse dữ liệu: $e");
        }
      }
    });
  }

  // Ngắt kết nối WebSocket
  void disconnect() {
    socket.disconnect();
  }

  // Gửi tin nhắn qua API
  Future<void> sendMessageAPI(
      String senderId, String receiverId, String content) async {
    await _loadToken();
    final response = await http.post(
      Uri.parse("$apiUrl/send"),
      headers: {"Content-Type": "application/json", "Authorization": token},
      body: jsonEncode({
        "senderId": senderId,
        "receiverId": receiverId,
        "content": content,
      }),
    );

    if (response.statusCode == 200) {
      print("✅ Tin nhắn đã gửi thành công");
    } else {
      print("❌ Lỗi khi gửi tin nhắn: ${response.statusCode}");
    }
  }

  // Lấy danh sách tin nhắn giữa hai người dùng
  Future<List<dynamic>> fetchMessages(
      String senderId, String receiverId) async {
    await _loadToken();
    final response = await http.get(
      Uri.parse("$apiUrl/messages?senderId=$senderId&receiverId=$receiverId"),
      headers: {"Content-Type": "application/json", "Authorization": token},
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return jsonResponse['messages'];
    } else {
      print("❌ Lỗi khi lấy tin nhắn: ${response.statusCode}");
      return [];
    }
  }
}
