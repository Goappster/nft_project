import 'package:flutter/material.dart';
import 'package:untitled/main.dart';
import 'package:untitled/views/auth/acc_create_options.dart';
import 'package:untitled/views/auth/login_screen.dart';
import 'package:untitled/views/auth/signUp_screen.dart';
import 'package:untitled/views/auth/splash_screeen.dart';
import 'package:untitled/views/auth/user_profile_screen.dart';
import 'package:untitled/views/wallet/deposit_methods.dart';
import 'package:untitled/views/wallet/withdraw/withdraw_screen.dart';

class AppRoutes {
  static const String splash = '/Splash';
  static const String login = '/login';
  static const String signUp = '/signUp';
  static const String home = '/home';
  static const String createAccountOptions = '/createAccountOptions';
  static const String DepositMethods = '/DepositMethods';
  static const String depositScreen = '/DepositScreen';
  static const String settingScreen = '/UserProfileScreen';
  static const String withdrawScreen = '/WithdrawalScreen';


  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case login:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case signUp:
        return MaterialPageRoute(builder: (_) => SignUpScreen());
      case home:
        return MaterialPageRoute(builder: (_) => CustomBottomNavScreen());
        case createAccountOptions:
        return MaterialPageRoute(builder: (_) => const CreateAccountScreen());
        case DepositMethods:
        return MaterialPageRoute(builder: (_) =>  DepositMethodsDraggableSheet ());
        case settingScreen:
        return MaterialPageRoute(builder: (_) =>  UserProfileScreen());
        case withdrawScreen:
        return MaterialPageRoute(builder: (_) =>  WithdrawScreen());
      default:
        return MaterialPageRoute(builder: (_) => SplashScreen());
    }
  }
}
