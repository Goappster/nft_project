import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:untitled/service/dio_service.dart';
import 'package:untitled/main.dart';

import '../Provider /user_provider.dart';

class LoginController extends GetxController {
  final box = GetStorage();
  var isLoading = false.obs;
  var isPasswordHidden = true.obs;
  var emailError = ''.obs;
  var passwordError = ''.obs;

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void validateAndLogin(BuildContext context, String email, String password) {
    emailError.value = email.isEmpty ? "Email cannot be empty" : '';
    passwordError.value = password.isEmpty ? "Password cannot be empty" : '';

    if (emailError.value.isEmpty && passwordError.value.isEmpty) {
      login(context, email, password);
    }
  }

  Future<void> login(BuildContext context,String email, String password) async {
    isLoading.value = true;
    var response = await HttpService.login(email, password);
    isLoading.value = false;

    if (response != null && response["status"] == "success") {

      String userIdFromApi = response['id'].toString();
      Provider.of<UserProvider>(context, listen: false).setUserId(userIdFromApi);
      print(response);
      Get.to(() => MainScreen());
    } else {
      emailError.value = response?["message"] ?? "Login failed.";
    }
  }
}
