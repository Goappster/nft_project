import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:intl/intl.dart';
import 'package:untitled/app_theme.dart';
import '../../Controller/balance.dart';
import '../../SaveUser/services/user_storage.dart';
import 'deposit_methods.dart';
import '../../routes.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final FundsController controller = Get.put(FundsController());

  String userName = '';

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    final user = await UserStorage.getUser();
    if (user != null) {
      setState(() => userName = user.name);
      controller.fetchFunds(user.userId.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.secondaryLight,
        toolbarHeight: 0.h,
      ),
      body: SingleChildScrollView(
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  SizedBox(height: 20.h),
                  _buildStatCards(),
                SizedBox(height: 10.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Text(
                      "Recent Transactions",
                      style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  _buildTransactions(),
                ],
              ),
            ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30.r),
          bottomRight: Radius.circular(30.r),
        ),
                border: Border.all(
      color: Colors.grey, // Border color
      width: .2,           // Border width
    ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // CircleAvatar(radius: 24.r),
          SizedBox(height: 10.h),
          Text("Welcome Back!", style: TextStyle(color: Colors.black87, fontSize: 16.sp)),
          SizedBox(height: 4.h),
          Text(userName, style: TextStyle(color: Colors.black, fontSize: 22.sp, fontWeight: FontWeight.bold)),
          SizedBox(height: 20.h),
          Obx(() {
            String balance = NumberFormat("#,##0.00", "en_US").format(controller.funds.value);
            return Text("\$$balance", style: TextStyle(color: Colors.black, fontSize: 36.sp, fontWeight: FontWeight.bold));
          }),
          Obx(() {
            String balancePKR = NumberFormat("#,##0.00", "en_US").format(controller.estimatedPKR.value);
            return Text("Est. PKR $balancePKR", style: TextStyle(color: Colors.black, fontSize: 16.sp));
          }),
          SizedBox(height: 10.h),
          Row(
            children: [
              _buildActionButton("Deposit", () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.green,
                  builder: (context) => DepositMethodsDraggableSheet(),
                );
              }),
              SizedBox(width: 10.w),
              _buildActionButton("Withdraw", () {
                Navigator.pushNamed(context, AppRoutes.withdrawScreen);
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String text, VoidCallback onPressed) {
    return Expanded(
      child: ElevatedButton(
      
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: Color(0xFfBFFB4F),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.r)),
        ),
        child: Text(text, style: TextStyle(color: Colors.black, fontSize: 14.sp)),
      ),
    );
  }

Widget _buildStatCards() {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 10.w).copyWith(bottom: 0), // 👈 no bottom padding
    child: GridView(
      padding: EdgeInsets.zero, // 👈 Ensure grid has no internal padding
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10.h, // 👈 Add some space between rows if needed
        crossAxisSpacing: 10.w,
        childAspectRatio: 1.2,
      ),
      children: [
        _buildCard("Total Earning", "\$543.52", HugeIcons.strokeRoundedWallet02),
        Obx(() => _buildCard("Total Deposit", "\$${controller.deposits.value.toStringAsFixed(2)}", HugeIcons.strokeRoundedCircleArrowDown02)),
        Obx(() => _buildCard("Total Withdraw", "\$${controller.totalWithdrawals.value.toStringAsFixed(2)}", Icons.attach_money)),
        Obx(() => _buildCard("Team Earning", "\$${controller.referralBalance.value.toStringAsFixed(2)}", HugeIcons.strokeRoundedUserGroup03)),
        // _buildCard("Total Withdraw", "\$465.50", Icons.attach_money),
        // _buildCard("Team Earning", "\$243.26", HugeIcons.strokeRoundedUserGroup03),
      ],
    ),
  );
}


  Widget _buildCard(String title, String amount, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        //  color: Colors.red.withOpacity(0.1), // debugging
         color: Colors.white70,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
      color: Colors.grey, // Border color
      width: .2,           // Border width
    ),
      ),
      padding: EdgeInsets.all(12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xFFE6FFB8),
            child: Icon(icon, color: Colors.black),
          ),
          SizedBox(height: 10.h),
          Text(title, style: TextStyle( fontSize: 14.sp)),
          SizedBox(height: 5.h),
          Text(amount, style: TextStyle( fontSize: 20.sp, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildTransactions() {
    final dummyTransactions = [
      {"title": "Food", "amount": "-\$4.02", "time": "Today, 12:04PM"},
      {"title": "Shopping", "amount": "-\$50.30", "time": "Yesterday, 5:00PM"},
      {"title": "Transport", "amount": "-\$10.50", "time": "2 Days ago"},
       {"title": "Transport", "amount": "-\$10.50", "time": "2 Days ago"},
    ];

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: dummyTransactions.length,
          // padding: EdgeInsets.symmetric(horizontal: 20.w),
          // padding: const EdgeInsets.all(8.0),
          itemBuilder: (_, i) {
            final item = dummyTransactions[i];
            return ListTile(
              // contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.fastfood, size: 24.sp),
              title: Text(item["title"]!, style: TextStyle(fontSize: 14.sp)),
              subtitle: Text(item["time"]!, style: TextStyle(color: Colors.white54, fontSize: 12.sp)),
              trailing: Text(item["amount"]!, style: TextStyle(color: Colors.redAccent, fontSize: 14.sp)),
            );
          },
        ),
      ),
    );
  }
}
