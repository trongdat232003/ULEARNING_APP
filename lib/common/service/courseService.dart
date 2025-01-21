import 'dart:convert';
import 'package:http/http.dart' as http;

class CourseService {
  static const String apiUrl = "http://10.0.2.2:8000/api/courses";

  static Future<List<dynamic>> getListCourse(String token) async {
    try {
      final response = await http.get(
        Uri.parse("$apiUrl/list"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": token,
        },
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['courses']; // Trả về danh sách khóa học
      } else {
        throw Exception(
            jsonDecode(response.body)['message'] ?? 'Failed to fetch courses');
      }
    } catch (e) {
      print("Error fetching courses: $e");
      return [];
    }
  }

// Lấy chi tiết khóa học từ API
  static Future<Map<String, dynamic>?> getCourseDetails(
      String id, String token) async {
    try {
      final response = await http.get(
        Uri.parse("$apiUrl/details/$id"), // URL lấy chi tiết khóa học
        headers: {
          "Content-Type": "application/json",
          "Authorization": token,
        },
      );
      print("Response body: ${response.body}"); // In ra nội dung của response

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Ensure that 'courses' exists in the response and is correctly accessed
        if (data.containsKey('courses')) {
          return data['courses']; // Trả về chi tiết khóa học từ API
        } else {
          throw Exception('Courses data is missing');
        }
      } else {
        throw Exception(
            "Error: ${jsonDecode(response.body)['message'] ?? 'Failed to fetch course details'}");
      }
    } catch (e) {
      print("Error fetching course details: $e");
      return null;
    }
  }
}
