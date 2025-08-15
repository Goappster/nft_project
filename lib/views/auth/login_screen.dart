import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/Controller/login.dart';
import 'package:untitled/app_theme.dart';

class LoginScreen extends StatelessWidget {
  final LoginController controller = Get.put(LoginController());
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.white, elevation: 0),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                "Login",
                style: TextStyle(color: Colors.black, fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "Enter your registered email address.",
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 30),
        
              // Email Field
              const Text("Email", style: TextStyle(color: Colors.black, fontSize: 16)),
              const SizedBox(height: 6),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.black12,
                  hintText: "Email",
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: const TextStyle(color: Colors.black),
              ),
        
              // Email Validation Message
              Obx(() => controller.emailError.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(top: 4, left: 4),
                      child: Text(controller.emailError.value,
                          style: const TextStyle(color: Colors.red, fontSize: 12)),
                    )
                  : const SizedBox()),
        
              const SizedBox(height: 12),
        
              // Password Field with Toggle
              const Text("Password", style: TextStyle(color: Colors.black, fontSize: 16)),
              const SizedBox(height: 6),
              Obx(() => TextField(
                    controller: passwordController,
                    obscureText: controller.isPasswordHidden.value, // Toggle password visibility
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.black12,
                      hintText: "Password",
                      hintStyle: const TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.isPasswordHidden.value
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey,
                        ),
                        onPressed: controller.togglePasswordVisibility,
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                  )),
        
              // Password Validation Message
              Obx(() => controller.passwordError.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(top: 4, left: 4),
                      child: Text(controller.passwordError.value,
                          style: const TextStyle(color: Colors.red, fontSize: 12)),
                    )
                  : const SizedBox()),
        
              const SizedBox(height: 30),
        
              // Login Button with Validation
              Obx(() => SizedBox(
                
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: AppColors.primaryLight,
                      ),
                      onPressed: controller.isLoading.value
                          ? null
                          : () => controller.validateAndLogin(
                        context,
                                emailController.text.trim(),
                                passwordController.text.trim(),
                              ),
                      child: controller.isLoading.value
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text("Login", style: TextStyle(color: Colors.black),),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
