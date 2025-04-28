import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import '../../Controller/balance.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final FundsController controller = Get.put(FundsController());

  @override
  void initState() {
    super.initState();
    // Fetch the funds automatically when the screen is loaded
    controller.fetchFunds('39');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.limeAccent.shade400,
        toolbarHeight: 0,
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.limeAccent.shade400,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 24,
                    // backgroundImage: AssetImage('assets/avatar.png'),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Welcome Back!",
                    style: TextStyle(color: Colors.black87, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Evan Cameron",
                    style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  // Use Obx to make the balance reactive
                  Obx(() {
                    // Debug print to ensure funds.value is being updated
                    print("Current balance: \$${controller.funds.value}");

                    // Format the funds value as a string with commas and 2 decimal places
                    String formattedBalance = NumberFormat("#,##0.00", "en_US").format(controller.funds.value);

                    return controller.funds.value == 0.0
                        ? CircularProgressIndicator()  // Loading state
                        : Text(
                      "\$${formattedBalance}",  // Formatted balance with commas and 2 decimal places
                      style: TextStyle(color: Colors.black, fontSize: 36, fontWeight: FontWeight.bold),
                    );
                  }),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            controller.fetchFunds('39');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                          child: Text("Deposit", style: TextStyle(color: Colors.limeAccent.shade400)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                          child: Text("Withdraw", style: TextStyle(color: Colors.limeAccent.shade400)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Cards
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 10,
                mainAxisSpacing: 20,
                childAspectRatio: 1.5,
                children: [
                  buildCard("Saving", "\$543.52", Icons.savings),
                  buildCard("Investing", "\$${controller.invest.value}", Icons.show_chart),
                  buildCard("Allowance", "\$465.50", Icons.attach_money),
                  buildCard("Expense", "\$243.26", Icons.money_off),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Recent Transactions
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Recent Transactions",
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                buildTransactionTile("Food", "-\$4.02", "Today, 12:04PM"),
                buildTransactionTile("Shopping", "-\$50.30", "Yesterday, 5:00PM"),
                buildTransactionTile("Transport", "-\$10.50", "2 Days ago"),
                buildTransactionTile("Transport", "-\$10.50", "2 Days ago"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCard(String title, String amount, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(height: 10),
          Text(
            title,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 5),
          // For investment balance, use the reactive invest variable
          title == "Investing"
              ? Obx(() {
            return Text(
              "\$${NumberFormat("#,##0.00", "en_US").format(controller.invest.value)}",
              style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
            );
          })
              : Text(
            amount,
            style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }


  Widget buildTransactionTile(String title, String amount, String time) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(Icons.fastfood, color: Colors.white),
      title: Text(title, style: TextStyle(color: Colors.white)),
      subtitle: Text(time, style: TextStyle(color: Colors.white54)),
      trailing: Text(amount, style: TextStyle(color: Colors.redAccent)),
    );
  }
}
