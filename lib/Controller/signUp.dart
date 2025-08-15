import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:untitled/main.dart';
import 'package:untitled/service/dio_service.dart';

import '../Provider /user_provider.dart';

class SignUpController extends GetxController {
  var isLoading = false.obs;
  var isPasswordHidden = true.obs;
  var selectedWallet = "TRC20".obs;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController walletController = TextEditingController();

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  Future<void> validateAndSignUp(BuildContext context) async {
    if (nameController.text.isEmpty ||
        mobileController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        confirmPasswordController.text.isEmpty ||
        walletController.text.isEmpty) {
      return;
    }



    isLoading.value = true;

    var response = await HttpService.signup(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      mobile: mobileController.text.trim(),
      password: passwordController.text.trim(),
      confirmPassword: confirmPasswordController.text.trim(),
      walletAddress: walletController.text.trim(),
    );

    isLoading.value = false;

    if (response != null && response["status"] == "success") {
      Get.snackbar("Success", "Signup successful!",
          snackPosition: SnackPosition.BOTTOM);
               Get.to(() => CustomBottomNavScreen());
      String userIdFromApi = response['id'].toString();
      Provider.of<UserProvider>(context, listen: false).setUserId(userIdFromApi);
    } else {
      _showErrorDialog('$response');
    }
  }

  void _showErrorDialog(String message) {
    Get.defaultDialog(
      title: "Error",
      middleText: message,
      textConfirm: "OK",
      confirmTextColor: Colors.white,
      onConfirm: () => Get.back(),
    );
  }

  String? validateName(String? value) =>
      value!.isEmpty ? "Name is required" : null;
  String? validateMobile(String? value) =>
      value!.length < 10 ? "Enter a valid mobile number" : null;
  String? validateEmail(String? value) =>
      !value!.contains("@") ? "Enter a valid email" : null;
  String? validatePassword(String? value) =>
      value!.length < 6 ? "Password must be at least 6 characters" : null;
}
