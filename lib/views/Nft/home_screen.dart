import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:untitled/Controller/nft_get.dart';
import 'package:untitled/main.dart';
import 'package:untitled/tes.dart';
import 'package:untitled/views/Nft/nft_detail_screen.dart';

class GridScreen extends StatelessWidget {
  final GridController controller = Get.put(GridController());

 GridScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       backgroundColor: Colors.black,
     appBar: const CustomAppBar(),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return RefreshIndicator(
          onRefresh: () async {
            await controller.fetchItems(); // Refresh data on pull
          },
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: GridView.builder(
              itemCount: controller.items.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Adjust based on your design
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 0.7, // Adjust for image aspect ratio
              ),
              itemBuilder: (context, index) {
                final item = controller.items[index];
                return InkWell(
                  onTap: () => Get.to(() => NFTDetailScreen(), arguments: item),
                  child: Card(
                    color: Colors.black.withOpacity(0.90),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(
                        color: Colors.grey, // Change this to your desired border color
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius:
                            const BorderRadius.vertical(top: Radius.circular(12)),
                            child: CachedNetworkImage(
                              imageUrl: item.imageUrl,            // The URL of the image
                              width: double.infinity,              // Make the image take up the full width
                              fit: BoxFit.cover,                   // Make the image cover the available space
                              // placeholder: (context, url) => CircularProgressIndicator(),  // Optional: Show a loading indicator
                              // errorWidget: (context, url, error) => Icon(Icons.error),     // Optional: Show an error widget
                            )
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.name,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  const SizedBox(width: 12,),
                                  Text(
                                    '#${item.id}',
                                    // style: Theme.of(context).textTheme.headlineSmall,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  SvgPicture.string(
                                    usdTSvg,
                                    width: 10,
                                    height: 15,
                                    // semanticsLabel: 'Dart Logo',
                                  ),
                                  const SizedBox(width: 3,),
                                  Text(
                                    item.price,
                                    // style: Theme.of(context).textTheme.headlineSmall,
                                    style: const TextStyle(color: Colors.white),
                                  ),
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
        );
      }),
    );
  }
}