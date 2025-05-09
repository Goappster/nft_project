import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/user_model.dart';

class UserController extends GetxController {
  Rxn<UserModel> user = Rxn<UserModel>();
  RxBool isLoading = false.obs;

  /// Fetch user by ID
  Future<void> fetchUser(int userId) async {
    isLoading.value = true;

    try {
      final response = await http.post(
        Uri.parse("https://dev.appezio.com/get_user.php"),
        body: {'user_id': userId.toString()},
      );

      final jsonData = jsonDecode(response.body);

      if (jsonData['status'] == 'success') {
        user.value = UserModel.fromJson(jsonData['data']);
      } else {
        Get.snackbar("Error", jsonData['message'] ?? "User not found");
      }
    } catch (e) {
      Get.snackbar("Network Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// Update user details via API
  Future<void> updateUser({
    required int userId,
    String? name,
    String? email,
    String? mobile,
    String? walletAddress,
  }) async {
    isLoading.value = true;

    try {
      final response = await http.post(
        Uri.parse("https://dev.appezio.com/update_user.php"),
        body: {
          'user_id': userId.toString(),
          if (name != null) 'name': name,
          if (email != null) 'email': email,
          if (mobile != null) 'mobile': mobile,
          if (walletAddress != null) 'walletAddress': walletAddress,
        },
      );

      final jsonData = jsonDecode(response.body);

      if (jsonData['status'] == 'success') {
        // Re-fetch updated data
        await fetchUser(userId);
        Get.snackbar("Success", jsonData['message']);
      } else {
        Get.snackbar("Error", jsonData['message']);
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to update user\n${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }
}
