import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../domain/entities/user_registration.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final String baseUrl = 'http://localhost:8080/api/v1';

  @override
  Future<void> registerUser(UserRegistration userRegistration) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {
          'Content-Type': 'application/json',
        },
        // body: jsonEncode(userRegistration.toJson()),  // cmt for test
        // body test
        body: '''
      {
        "firstName": "Test",
        "lastName": "User",
        "email": "vnhat.dev@gmail.copm",
        "password": "test123"
      }
      ''',
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        // Registration successful
        return;
      } else {
        // Handle different error status codes
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['message'] ?? 'Registration failed');
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Network error: $e');
    }
  }

  @override
  Future<bool> checkEmailAvailability(String email) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/auth/check-email?email=$email'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['available'] ?? false;
      } else {
        throw Exception('Failed to check email availability');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  @override
  Future<bool> checkUsernameAvailability(String username) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/auth/check-username?username=$username'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['available'] ?? false;
      } else {
        throw Exception('Failed to check username availability');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}

