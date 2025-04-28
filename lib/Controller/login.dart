import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:untitled/service/dio_service.dart';
import 'package:untitled/main.dart';

class LoginController extends GetxController {
  final box = GetStorage();
  var isLoading = false.obs;
  var isPasswordHidden = true.obs;
  var emailError = ''.obs;
  var passwordError = ''.obs;

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void validateAndLogin(String email, String password) {
    emailError.value = email.isEmpty ? "Email cannot be empty" : '';
    passwordError.value = password.isEmpty ? "Password cannot be empty" : '';

    if (emailError.value.isEmpty && passwordError.value.isEmpty) {
      login(email, password);
    }
  }

  Future<void> login(String email, String password) async {
    isLoading.value = true;
    var response = await HttpService.login(email, password);
    isLoading.value = false;

    if (response != null && response["status"] == "success") {

      box.write('isLoggedIn', true);
      box.write('userEmail', email); // optional: save email or token
      print(response);
      Get.to(() => MainScreen());
    } else {
      emailError.value = response?["message"] ?? "Login failed.";
    }
  }
}
