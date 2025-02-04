import 'dart:convert';
import 'package:http/http.dart' as http;

class FriendService {
  static const String apiUrl =
      "http://10.0.2.2:8000/api/friends"; // Update to your API URL

  // Gửi lời mời kết bạn
  static Future<void> sendFriendRequest(String receiverId, String token) async {
    final url = '$apiUrl/send'; // Đường dẫn API để gửi yêu cầu kết bạn

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': token, // Đảm bảo thêm Bearer token vào header
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'receiverId': receiverId}),
      );

      if (response.statusCode == 200) {
        // Gửi lời mời thành công
        print("Gửi lời mời kết bạn thành công.");
      } else {
        final responseBody = jsonDecode(response.body);
        // Xử lý lỗi nếu có
        print("Lỗi: ${responseBody['message']}");
      }
    } catch (e) {
      print('Lỗi khi gửi yêu cầu kết bạn: $e');
    }
  }

  // Chấp nhận lời mời kết bạn
  static Future<void> acceptFriendRequest(String senderId, String token) async {
    final url = '$apiUrl/accept'; // Đường dẫn API để chấp nhận yêu cầu kết bạn

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': token, // Đảm bảo thêm Bearer token vào header
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'senderId': senderId}),
      );

      if (response.statusCode == 200) {
        // Chấp nhận kết bạn thành công
        print("Chấp nhận lời mời kết bạn thành công.");
      } else {
        final responseBody = jsonDecode(response.body);
        // Xử lý lỗi nếu có
        print("Lỗi: ${responseBody['message']}");
      }
    } catch (e) {
      print('Lỗi khi chấp nhận yêu cầu kết bạn: $e');
    }
  }

  // Từ chối lời mời kết bạn
  static Future<void> rejectFriendRequest(String senderId, String token) async {
    final url = '$apiUrl/reject'; // Đường dẫn API để từ chối yêu cầu kết bạn

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': token, // Đảm bảo thêm Bearer token vào header
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'senderId': senderId}),
      );

      if (response.statusCode == 200) {
        // Từ chối yêu cầu kết bạn thành công
        print("Đã từ chối lời mời kết bạn.");
      } else {
        final responseBody = jsonDecode(response.body);
        // Xử lý lỗi nếu có
        print("Lỗi: ${responseBody['message']}");
      }
    } catch (e) {
      print('Lỗi khi từ chối yêu cầu kết bạn: $e');
    }
  }

  // Hủy kết bạn
  static Future<void> removeFriend(String friendId, String token) async {
    final url = '$apiUrl/remove'; // Đường dẫn API để hủy kết bạn

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': token, // Đảm bảo thêm Bearer token vào header
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'friendId': friendId}),
      );

      if (response.statusCode == 200) {
        // Hủy kết bạn thành công
        print("Đã hủy kết bạn.");
      } else {
        final responseBody = jsonDecode(response.body);
        // Xử lý lỗi nếu có
        print("Lỗi: ${responseBody['message']}");
      }
    } catch (e) {
      print('Lỗi khi hủy kết bạn: $e');
    }
  }

  // Lấy danh sách lời mời kết bạn
  static Future<List<Map<String, dynamic>>> getFriendRequests(
      String token) async {
    final url = '$apiUrl/requests';
    List<Map<String, dynamic>> friendRequests = [];

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': token,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body)['requests'];
        friendRequests = List<Map<String, dynamic>>.from(data);
      } else {
        final responseBody = jsonDecode(response.body);
        // Xử lý lỗi nếu có
        print(responseBody['message']);
      }
    } catch (e) {
      print('Lỗi khi tải danh sách lời mời kết bạn: $e');
    }

    return friendRequests;
  }

  // Lấy danh sách bạn bè
  static Future<List<Map<String, dynamic>>> getFriends(String token) async {
    final url = '$apiUrl/friends';
    List<Map<String, dynamic>> friends = [];

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': token,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body)['friends'];
        friends = List<Map<String, dynamic>>.from(data);
      } else {
        final responseBody = jsonDecode(response.body);
        // Xử lý lỗi nếu có
        print(responseBody['message']);
      }
    } catch (e) {
      print('Lỗi khi tải danh sách bạn bè: $e');
    }

    return friends;
  }
}
