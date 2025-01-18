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
}
