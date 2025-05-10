// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData.light().copyWith(
//         primaryColor: Colors.blue,
//         scaffoldBackgroundColor: Colors.white,
//       ),
//       darkTheme: ThemeData.dark().copyWith(
//         primaryColor: Colors.blue,
//         scaffoldBackgroundColor: Colors.black,
//       ),
//       themeMode: ThemeMode.system,
//       home: NFTMarketScreen(),
//     );
//   }
// }
//
// class NFTMarketController extends GetxController {
//   final RxList<String> categories = [
//     'All NFTs', 'Art', 'Collectibles', 'Music', 'Photo'
//   ].obs; // Changed to RxList for reactivity
//
//   final RxString selectedCategory = 'All NFTs'.obs;
//
//   final List<Color> cardColors = [
//     Colors.pink.shade100,
//     Colors.green.shade700,
//     Colors.blue.shade200,
//     Colors.green.shade400,
//     Colors.orange.shade700,
//   ];
//
//   // Background images
//   final String lightBackground = 'assets/background.jpg';
//   final String darkBackground = 'assets/background.jpg';
// }
//
// class NFTMarketScreen extends StatelessWidget {
//   NFTMarketScreen({super.key});
//   final NFTMarketController controller = Get.put(NFTMarketController());
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           // Fixed: No need for Obx here
//           Positioned.fill(
//             child: Image.asset(
//               Get.isDarkMode ? controller.darkBackground : controller.lightBackground,
//               fit: BoxFit.cover,
//             ),
//           ),
//
//           Column(
//             children: [
//               AppBar(
//                 title: const Text('Market', style: TextStyle(color: Colors.white)),
//                 backgroundColor: Colors.transparent,
//                 elevation: 0,
//                 actions: [
//                   IconButton(
//                     icon: Icon(
//                       Get.isDarkMode ? Icons.light_mode : Icons.dark_mode,
//                       color: Get.isDarkMode ? Colors.white : Colors.black,
//                     ),
//                     onPressed: () {
//                       Get.changeThemeMode(Get.isDarkMode ? ThemeMode.light : ThemeMode.dark);
//                     },
//                   ),
//                 ],
//               ),
//
//               // Category Filters (Fixed)
//               SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: Obx(() => Row(
//                   children: controller.categories.map((category) {
//                     return Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 6),
//                       child: ChoiceChip(
//                         label: Text(category),
//                         selected: controller.selectedCategory.value == category,
//                         selectedColor: Colors.green,
//                         showCheckmark: false,
//                         backgroundColor: Colors.transparent,
//                         labelStyle: const TextStyle(color: Colors.white),
//                         onSelected: (selected) => controller.selectedCategory.value = category,
//                       ),
//                     );
//                   }).toList(),
//                 )),
//               ),
//
//               // NFT Grid (No Obx needed as grid items don’t change)
//               Expanded(
//                 child: GridView.builder(
//                   padding: const EdgeInsets.all(10),
//                   gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 2,
//                     crossAxisSpacing: 10,
//                     mainAxisSpacing: 10,
//                     childAspectRatio: 0.8,
//                   ),
//                   itemCount: controller.cardColors.length,
//                   itemBuilder: (context, index) {
//                     return NFTCard(color: controller.cardColors[index]);
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class NFTCard extends StatelessWidget {
//   final Color color;
//   const NFTCard({super.key, required this.color});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.85),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: const [
//           Icon(Icons.image, size: 50, color: Colors.white),
//           SizedBox(height: 10),
//           Text(
//             'Super Influencers',
//             style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
//           ),
//           Text(
//             '#1267',
//             style: TextStyle(color: Colors.white70, fontSize: 14),
//           ),
//           Text(
//             '\u{1F4B0} 6.64',
//             style: TextStyle(color: Colors.white, fontSize: 14),
//           ),
//         ],
//       ),
//     );
//   }
// }
