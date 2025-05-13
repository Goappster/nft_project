import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:untitled/routes.dart';
import 'package:untitled/views/Nft/home_screen.dart';
import 'package:untitled/views/auth/signUp_screen.dart';
import 'package:untitled/views/auth/splash_screeen.dart';
import 'package:untitled/views/auth/user_profile_screen.dart';
import 'package:untitled/views/wallet/wallet.dart';
import 'package:http/http.dart' as http;

import 'Controller/user_controller.dart';
import 'Provider /user_provider.dart';

// Screens
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold
  
    (body: Center(child: Text("Home Screen", style: TextStyle(color: Colors.white, fontSize: 20))));
  }
}

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text("Search Screen", )));
  }
}

class AddScreen extends StatelessWidget {
  const AddScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Add Screen", style: TextStyle(color: Colors.white, fontSize: 20)));
  }
}

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Notifications Screen", style: TextStyle(color: Colors.white, fontSize: 20)));
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Profile Screen", style: TextStyle(color: Colors.white, fontSize: 20)));
  }
}

// Controller for managing state
class BottomNavController extends GetxController {
  var selectedIndex = 0.obs;
  final List<Widget> screens = [
    GridScreen(),
    const SearchScreen(),
    WalletScreen(),
    const NotificationScreen(),
    UserProfileScreen(),
  ];
}

// Custom Bottom Navigation Bar
class CustomBottomNav extends StatelessWidget {
  final BottomNavController controller = Get.put(BottomNavController());

  final List<IconData> icons = [
   HugeIcons.strokeRoundedHome11,
    Icons.search,
    HugeIcons.strokeRoundedWallet01,
    HugeIcons.strokeRoundedCrown,
    HugeIcons.strokeRoundedUserCircle
  ];

   CustomBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Padding(
  padding: const EdgeInsets.all(8.0),
  child: Container(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
    margin: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: Colors.limeAccent.shade400,
      borderRadius: BorderRadius.circular(50),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.4), // Dark shadow for depth
          blurRadius: 10, // Increases the blur effect
          spreadRadius: 3, // Increases the shadow size
          offset: const Offset(0, 4), // Moves the shadow downward
        ),
      ],
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(icons.length, (index) {
        bool isSelected = controller.selectedIndex.value == index;
        return GestureDetector(
          onTap: () {
            if (index != 2) controller.selectedIndex.value = index;
          },
          child: index == 2
              ? FloatingActionButton(
                  onPressed: () {
                    controller.selectedIndex.value = index;
                  },
                  backgroundColor: Colors.black,
                  shape: const CircleBorder(),
                  elevation: 10, // Adds elevation shadow to FAB
                  child: Icon(icons[index], color: Colors.limeAccent.shade400, size: 28),
                )
              : Icon(
                  icons[index],
                  color: isSelected ? Colors.black : Colors.lightGreen.shade900,
                  size: 26,
                ),
        );
      }),
    ),
  ),
)

    
    );
  }
}

// Main App
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(UserController());

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()..loadUserId()),
        // Add more providers here as needed
      ],
      child: MyApp(),
    ),
  );
}



class MyApp extends StatelessWidget {
  final UserController userController = Get.find<UserController>();
  @override
  Widget build(BuildContext context) {
    userController.fetchUser(39);
    return ScreenUtilInit(
      designSize: Size(360, 690), // base design
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, __) => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: AppRoutes.splash,
        onGenerateRoute: AppRoutes.generateRoute,
       // home:  h(),
        themeMode: ThemeMode.dark,
      ),
    );
  }
}


// Main Screen with Bottom Navigation
class MainScreen extends StatelessWidget {
  final BottomNavController controller = Get.put(BottomNavController());

  MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Obx(() => controller.screens[controller.selectedIndex.value]),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: CustomBottomNav(), // Keep this on top
        ),
      ],
    );
  }
}





class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      automaticallyImplyLeading: false, // Removes default back button
      title: Row(
        children: [
          // Profile Image
          const CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(
              'https://img.freepik.com/free-psd/3d-illustration-human-avatar-profile_23-2150671142.jpg?t=st=1742389267~exp=1742392867~hmac=fb23d66d0dc7a4319faa6a3cbba8a34290703b0513842664fe5b83e7ab98147f&w=1380', // Replace with actual profile image
            ),
          ),
          const Spacer(), // Push items to the right

          // Premium Button
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              children: [
                Icon(Icons.star, color: Colors.greenAccent, size: 16),
                SizedBox(width: 4),
                Text(
                  'Premium',
                  style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          const SizedBox(width: 12), // Spacing between buttons

          // Notification Icon
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white54),
            onPressed: () {
              // Handle notification click
            },
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}






class DepositScreen extends StatelessWidget {
  // Function to make the API call

  void makeApiCall(BuildContext context) async {
    final url = 'https://dev.appezio.com/deposit.php';

    final Map<String, dynamic> body = {
      "user_id": "65",
      "amount": "50",
      "user_name": "ghani",
      "user_email": "ghani@gmail.com",
      "network": "bep20",
      "name": "bnb",
      "image_url": "http://dev.appezio.com/api/uploads/68153a76534dc_1000346221.jpg",
      "image_id": "17"
    };

    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['status'] == 'success') {
        // ✅ Show success dialog
        showPaymentSuccessDialog(context);
      } else {
        // ❌ Show error if status is not success
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text(jsonResponse['message'] ?? 'Something went wrong.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } else {
      // ❌ Network or server error
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Server Error'),
            content: Text('Failed to connect. Please try again.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Deposit API Call"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // makeApiCall(context);
            showPaymentSuccessDialog(context);
            // Trigger the API call when button is pressed
          },
          child: Text("Make Deposit"),
        ),
      ),
    );
  }
  void showPaymentSuccessDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Container(
            width: double.infinity,
            // margin: EdgeInsets.only(bottom: 20),
            padding: EdgeInsets.symmetric(vertical: 24, ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 48),
                SizedBox(height: 12),
                Text(
                  'Payment successfully processed',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'The order has been sent to the restaurant.',
                  style: TextStyle(color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

}

