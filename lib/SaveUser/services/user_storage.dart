import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class UserStorage {
  static Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('userId', user.userId);
    await prefs.setString('name', user.name);
    await prefs.setString('email', user.email);
    await prefs.setString('walletAddress', user.walletAddress);
  }

  static Future<User?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');
    final name = prefs.getString('name');
    final email = prefs.getString('email');
    final walletAddress = prefs.getString('walletAddress');

    if (userId != null && name != null && email != null && walletAddress != null) {
      return User(
        userId: userId,
        name: name,
        email: email,
        walletAddress: walletAddress,
      );
    }
    return null;
  }

  static Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
