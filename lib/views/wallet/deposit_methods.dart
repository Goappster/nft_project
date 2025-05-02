import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Controller/deposit_methods_controller.dart';


import 'package:flutter/services.dart';

import 'DepositMethodScreen.dart';

class DepositMethodsDraggableSheet extends StatelessWidget {
  final controller = Get.put(DepositMethodsController());

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.8,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade900,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: EdgeInsets.all(15),
          child: Obx(() {
            if (controller.isLoading.value) {
              return Center(child: CircularProgressIndicator());
            }

            if (controller.depositMethods.isEmpty) {
              return Center(child: Text("No deposit methods available"));
            }

            return Column(

              children: [
                Container(
                  width: 50,
                  height: 5,
                  margin: EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: Colors.limeAccent.shade400,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                Text(
                  "Select Deposit Method",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                // Divider(),
                SizedBox(height: 12,),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: controller.depositMethods.length,
                    itemBuilder: (context, index) {
                      final method = controller.depositMethods[index];
                      return InkWell(

                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DepositScreen(name: method.name, network: method.network,),
                            ),
                          );
                        },
                        child: Card(
                          color: Color(0xFFCCFF00), // Matches neon yellow/green
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          // margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                          elevation: 4,
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Logo
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    method.logoUrl ?? '',
                                    width: 48,
                                    height: 48,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) =>
                                        Icon(Icons.wallet, size: 40),
                                  ),
                                ),
                                SizedBox(width: 14),

                                // Details
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${method.name} (${method.network})",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.black,
                                        ),
                                      ),
                                      SizedBox(height: 12),
                                      Wrap(
                                        spacing: 6,
                                        runSpacing: 6,
                                        children: [
                                          InfoTag(label: "Fast: 0–30 min"),
                                          InfoTag(label: "No Network Fee"),
                                          InfoTag(label: "Start from 100 USDT"),


                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );


                    },
                  ),
                ),
              ],
            );
          }),
        );
      },
    );
  }
}


class InfoTag extends StatelessWidget {
  final String label;
  const InfoTag({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.black87),
      ),
    );
  }
}
