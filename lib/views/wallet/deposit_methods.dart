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
                      return Card(
                        color: Colors.limeAccent.shade400,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),

                        ),
                        margin: EdgeInsets.symmetric(vertical: 6),
                        elevation: 3,
                        child: ListTile(
                          contentPadding: EdgeInsets.all(12),
                          leading: method.logoUrl != null
                              ? Image.network(
                            method.logoUrl!,
                            width: 40,
                            height: 40,
                            errorBuilder: (context, error, stackTrace) => Icon(Icons.wallet),
                          )
                              : Icon(Icons.wallet),
                          title: Text("${method.currency} (${method.network})"),
                          subtitle: Text("Address: ${method.walletAddress}"),
                          trailing: IconButton(
                            icon: Icon(Icons.copy),
                            onPressed: () {
                              Clipboard.setData(ClipboardData(text: method.walletAddress));
                              // Get.snackbar("Copied", "Wallet address copied");
                            },
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DepositScreen(),
                              ),
                            );

                          },
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
