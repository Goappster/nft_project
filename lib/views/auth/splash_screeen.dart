import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';
import 'package:untitled/routes.dart';

import '../../Provider /user_provider.dart';


class SplashScreen extends StatefulWidget {

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  // Check if user is logged in
  Future<void> _checkLoginStatus() async {
    await Provider.of<UserProvider>(context, listen: false).loadUserId();

    String? userId = Provider.of<UserProvider>(context, listen: false).userId;

    if (userId != null) {
      // If userId exists, navigate to the home screen
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } else {
      // If no user ID, navigate to login screen after a short delay
      Future.delayed(Duration(seconds: 3), () {
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.png'), // Replace with your image path
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Content
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Logo
              Text(
                'ART.AI',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.limeAccent.shade400,
                  letterSpacing: 2,
                ),
              ),
              SizedBox(height: 20),
              // Tagline
              Text(
                'Create artwork with AI',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: Colors.limeAccent.shade400,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),
              // Buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                       Navigator.pushNamed(context, AppRoutes.createAccountOptions);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.limeAccent.shade400,
                        minimumSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Create an Account',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    OutlinedButton(
                      onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.login);
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.limeAccent.shade400),
                        minimumSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.limeAccent.shade400,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
