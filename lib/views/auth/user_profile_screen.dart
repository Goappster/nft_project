import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../Controller/user_controller.dart';


class UserProfileScreen extends StatelessWidget {
  final userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Obx(() {
        final user = userController.user.value;
        if (userController.isLoading.value && user == null) {
          return Center(child: CircularProgressIndicator());
        }
        // if (user == null) {
        //   return Center(child: Text("No user data available.", style: TextStyle(fontSize: 12.sp)));
        // }

        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(toolbarHeight: 0, backgroundColor: Colors.limeAccent.shade400,),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(8.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle("Account", "Update your info to keep your account"),
                  SizedBox(height: 6.h),
                  Card(
                    color: Colors.limeAccent.shade400,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.w)),
                    elevation: 2,
                    child: Padding(
                      padding:  EdgeInsets.all(10.w),
                      child: Column(
                        children: [
                          _buildOptionTile(Icons.person, "Account information", () {}),
                          _buildOptionTile(Icons.people, "Friends", () {}),
                          _buildOptionTile(Icons.notifications, "Notifications", () {}),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  _buildSectionTitle("Privacy", "Customize your privacy to make experience better"),
                  SizedBox(height: 6.h),
                  Card(
                    color: Colors.limeAccent.shade400,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.w)),
                    elevation: 2,
                    child: Padding(
                      padding:  EdgeInsets.all(10.w),
                      child: Column(
                        children: [
                          _buildOptionTile(Icons.lock, "Security", () {}),
                          _buildOptionTile(Icons.login, "Login details", () {}),
                          _buildOptionTile(Icons.attach_money, "Billing", () {}),
                          _buildOptionTile(Icons.privacy_tip, "Privacy", () {}),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildSectionTitle(String title, String subtitle) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0.5.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold, color: Colors.white)),
          SizedBox(height: 0.5.h),
          Text(subtitle, style: TextStyle(color: Colors.grey, fontSize: 14.sp, )),
          SizedBox(height: 1.h),
        ],
      ),
    );
  }

  Widget _buildOptionTile(IconData icon, String label, VoidCallback onTap) {
    return ListTile(
      leading: CircleAvatar(
          radius: 20.w,
          backgroundColor: Colors.limeAccent.shade700.withOpacity(0.9),
          child: Icon(icon, color: Colors.black, size: 25.w)),
      title: Text(label, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500)),
      trailing: Icon(Icons.arrow_forward_ios, size: 16.w),
      onTap: onTap,
    );
  }
}
