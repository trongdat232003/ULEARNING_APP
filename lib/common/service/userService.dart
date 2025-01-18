import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart'; // for decoding JSON

class UserService {
  static const String apiUrl =
      "http://10.0.2.2:8000/api/users"; // Update to your API URL

  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$apiUrl/login"),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "email": email,
          "password": password,
        }),
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': json.decode(response.body),
        };
      } else {
        return {
          'success': false,
          'message': json.decode(response.body)['message'] ?? 'Login failed',
        };
      }
    } catch (e) {
      print("Error: $e");
      return {
        'success': false,
        'message': 'An error occurred while logging in.',
      };
    }
  }

  static Future<Map<String, dynamic>> register(
      String name, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$apiUrl/register"),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "name": name,
          "email": email,
          "password": password,
          "avatar": '', // Optional field, adjust as needed
        }),
      );

      if (response.statusCode == 201) {
        return {
          'success': true,
          'data': json.decode(response.body),
        };
      } else {
        return {
          'success': false,
          'message':
              json.decode(response.body)['message'] ?? 'Registration failed',
        };
      }
    } catch (e) {
      print("Error: $e");
      return {
        'success': false,
        'message': 'An error occurred while registering.',
      };
    }
  }

  static Future<Map<String, dynamic>> getuserProfile(String token) async {
    final response = await http.get(Uri.parse("$apiUrl/profile"), headers: {
      "Content-Type": "application/json",
      "Authorization": token,
    });
    if (response.statusCode == 200) {
      return {"success": true, "data": jsonDecode(response.body)['user']};
    } else {
      return {
        "success": false,
        "message": jsonDecode(response.body)['message'] ??
            'Failed to fetch user profile'
      };
    }
  }

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
}
