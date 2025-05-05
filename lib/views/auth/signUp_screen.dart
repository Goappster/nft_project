import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:untitled/Controller/signUp.dart';
import 'package:untitled/tes.dart';
import 'package:untitled/widget/all_widget.dart';

class SignUpScreen extends StatelessWidget {
  final SignUpController controller = Get.put(SignUpController());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  SignUpScreen({super.key});

  final RxString selectedMethod = "TRC20".obs;
  final List<String> paymentMethods = ["TRC20", "BNB", "ETH", "BTC"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFF111417),
      appBar: AppBar(
        backgroundColor: const Color(0XFF111417),
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text("Create Account",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text("Sign up to continue.",
                  style: TextStyle(color: Colors.grey, fontSize: 14)),
              const SizedBox(height: 30),
              _buildTextField(
                  "Name", controller.nameController, "Enter your name",
                  validator: controller.validateName),
              _buildTextField("Mobile Number", controller.mobileController,
                  "Enter your mobile number",
                  isPhone: true, validator: controller.validateMobile),
              _buildTextField(
                  "Email", controller.emailController, "Enter your email",
                  validator: controller.validateEmail),
              _buildPasswordField(),
              _buildConfirmPasswordField(),
              const TermsAndConditions(),
              const SizedBox(height: 30),
              CustomButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _showBottomSheet(context);
                  }
                },
                text: 'Create an Account',
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label, TextEditingController controller, String hint,
      {bool isPhone = false, String? Function(String?)? validator}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 16)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: isPhone ? TextInputType.phone : TextInputType.text,
          decoration: _inputDecoration(hint),
          style: const TextStyle(color: Colors.white),
          validator: validator,
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildPasswordField() {
    return _buildTextField(
      "Password",
      controller.passwordController,
      "Enter your password",
      validator: controller.validatePassword,
    );
  }

Widget _buildConfirmPasswordField() {
  return _buildTextField(
    "Confirm Password",
    controller.confirmPasswordController,
    "Confirm your password",
    validator: (value) {
      if (value == null || value.isEmpty) {
        return "This field is required"; // 🔹 اگر خالی ہو تو ایرر
      } else if (value != controller.passwordController.text) {
        return "Passwords do not match"; // 🔹 اگر پاسورڈ میچ نہ کرے
      }
      return null; 
    },
  );
}


  Widget _buildPaymentDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Payment Method",
            style: TextStyle(color: Colors.white, fontSize: 16)),
        const SizedBox(height: 6),
        Obx(() => DropdownButtonFormField<String>(
              value: selectedMethod.value,
              items: paymentMethods.map((method) {
                return DropdownMenuItem(
                  value: method,
                  child: Row(
                    children: [
                      SvgPicture.string(
                        _getPaymentIcon(method), // آئیکون لوڈ کرے گا
                        width: 24,
                        height: 24,
                      ),
                      const SizedBox(
                          width: 10), // آئیکون اور ٹیکسٹ کے درمیان اسپیس
                      Text(method, style: const TextStyle(color: Colors.white)),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  selectedMethod.value = value;
                }
              },
              dropdownColor: Colors.grey[900],
              decoration: _inputDecoration("Select Payment Method"),
            )),
        const SizedBox(height: 12),
      ],
    );
  }

// ✅ **SVG آئیکن کے لیے فنکشن (assets سے فائل لوڈ کرے گا)**
  String _getPaymentIcon(String method) {
    switch (method) {
      case "TRC20":
        return usdTSvg;
      case "BNB":
        return usdTSvg;
      case "ETH":
        return usdTSvg;
      case "BTC":
        return usdTSvg;
      default:
        return usdTSvg; // اگر کوئی آئیکون نہ ملے
    }
  }

  InputDecoration _inputDecoration(String hintText) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.grey[900],
      hintText: hintText,
      hintStyle: const TextStyle(color: Colors.grey),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
    );
  }

void _showBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true, 
    backgroundColor: Colors.transparent, 
    builder: (context) {
      return DraggableScrollableSheet(
        initialChildSize: 0.8, 
        minChildSize: 0.3, 
        maxChildSize: 0.8, 
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: Color(0XFF131619),
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 50,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[700],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Confirm Signup",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),

                Expanded(  // Expanding the content to fill available space
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      children: [
                        _buildPaymentDropdown(),
                        _buildWalletAddressField(),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Align(
                  alignment: Alignment.bottomCenter,
                  child: CustomButton(
                    onPressed: () {
                      Navigator.pop(context);
                      if (_formKey.currentState!.validate()) {
                        controller.validateAndSignUp(context);
                      }
                    },
                    text: "Save and Sign Up",
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}


  Widget _buildWalletAddressField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Wallet Address",
            style: TextStyle(color: Colors.white, fontSize: 16)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller.walletController,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[900],
            hintText: "Enter your wallet address",
            hintStyle: const TextStyle(color: Colors.grey),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            suffixIcon: IconButton(
              icon: const Icon(HugeIcons.strokeRoundedCopy02,
                  color: Colors.white),
              onPressed: () async {
                ClipboardData? data =
                    await Clipboard.getData(Clipboard.kTextPlain);
                if (data != null) {
                  controller.walletController.text = data.text!;
                }
              },
            ),
          ),
          style: const TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
