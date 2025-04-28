import 'package:http/http.dart' as http;
import 'dart:convert';



class HttpService {
  static const String baseUrl = "https://dev.appezio.com/";

  // Secure POST login request
  static Future<Map<String, dynamic>?> login(String email, String password) async {
    final String url = "${baseUrl}login.php";

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print("Login Error: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Request Failed: $e");
      return null;
    }
  }

  // Secure POST signup request

  static Future<Map<String, dynamic>?> signup({
    required String name,
    required String email,
    required String mobile,
    required String password,
    required String confirmPassword,
    required String walletAddress,
  }) async {
    final String url = "${baseUrl}register.php";

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json"
        },
        body: jsonEncode({
          "name": name,
          "email": email,
          "mobile": mobile,
          "password": password,
          "confirmPassword": confirmPassword,
          "walletAddress": walletAddress
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print("Signup Error: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Request Failed: $e");
      return null;
    }
  }

}




