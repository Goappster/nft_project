import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:untitled/Controller/nft_get.dart';
import 'package:untitled/app_theme.dart';
import 'package:untitled/tes.dart';
import 'package:untitled/views/Nft/nft_detail_screen.dart';

class GridScreen extends StatelessWidget {
  final GridController controller = Get.put(GridController());

  GridScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
         
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        elevation: 4,
        title:  Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  print("Notification tapped");
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(10),
                  child: const Icon(
                    HugeIcons.strokeRoundedNotification01,
                    size: 24,
                    color: Colors.black,
                  ),
                ),
              ),
              const Text(
                'Explore NFTs',
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: () {
                  print("Avatar tapped");
                },
                child: const CircleAvatar(
                  radius: 20,
                  child: Icon(
                    HugeIcons.strokeRoundedUserCircle,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
      ),
body: Obx(() {
  if (controller.isLoading.value) {
    return const Center(child: CircularProgressIndicator());
  }

  final categories = controller.groupedItems;
  final selectedIndex = controller.selectedCategoryIndex.value;

  return RefreshIndicator(
    onRefresh: controller.fetchItems,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),

        // 🔘 Chip Bar
        SizedBox(
          height: 40,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final isSelected = index == selectedIndex;
              return GestureDetector(
                onTap: () => controller.selectedCategoryIndex.value = index,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primaryLight : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.black12),
                    // boxShadow: isSelected
                    //     ? [BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))]
                    //     : [],
                  ),
                  child: Row(
                    children: [
                      // Icon(Icons.category, size: 16, color: isSelected ? Colors.black : Colors.black),
                      // const SizedBox(width: 5),
                      Text(
                        categories[index].category,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: isSelected ? Colors.black : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),

        // const SizedBox(height: 6),

        // 📦 NFTs of Selected Category
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: categories[selectedIndex].nfts.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.7,
            ),
            itemBuilder: (context, i) {
              final item = categories[selectedIndex].nfts[i];
              return InkWell(
                onTap: () => Get.to(() => NFTDetailScreen(), arguments: item),
                child: Card(
                  
                  color: Colors.white,
                  elevation: .5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    // side: BorderSide(color: AppColors.primaryLight,width: 1.0.r)
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius:  BorderRadius.vertical(top: Radius.circular(12.r)),
                          child: CachedNetworkImage(
                            imageUrl: item.imageUrl,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) => const Icon(Icons.broken_image),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Text('#${item.id}', style: Theme.of(context).textTheme.labelSmall),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                SvgPicture.string(usdTSvg, width: 10, height: 15),
                                const SizedBox(width: 3),
                                Text(item.price),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    ),
  );
}),
    );
  }
}
