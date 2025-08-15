import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
        backgroundColor: AppColors.scaffoldLight,
        toolbarHeight: 0.h,
        surfaceTintColor: Colors.white,
      ),
      body: SingleChildScrollView(
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  SizedBox(height: 20.h),
                  _buildStatCards(),
                SizedBox(height: 16.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Recent Transactions",
                          style: TextStyle(fontSize: 16.sp, ),
                        ),
                        Text(
                          "View All",
                          style: TextStyle(fontSize: 12.sp, ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 6.h),
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
  boxShadow: [
    BoxShadow(
      color: Colors.black12.withOpacity(.1),  // Light shadow color
      blurRadius: 5,         // How soft the shadow is
      offset: Offset(0, 2),   // Position of the shadow (x, y)
    ),
  ],
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
  final List<TransactionItem> transactions = [
    TransactionItem(
      icon: FontAwesomeIcons.arrowDown,
      title: 'Online Shopping',
      time: '1 Sep 9:29',
      amount: 120.00,
      status: 'Success',
    ),
    TransactionItem(
      icon: FontAwesomeIcons.arrowDown,
      title: 'To: Ailsa Salsa',
      time: '1 Sep 9:29',
      amount: 2000.00,
      status: 'Failed',
    ),
    TransactionItem(
      icon: FontAwesomeIcons.arrowDown,
      title: 'Buy Food',
      time: '1 Sep 9:29',
      amount: 80.00,
      status: 'Success',
    ),
  ];

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Success':
        return Colors.green[100]!;
      case 'Failed':
        return Colors.red[100]!;
      default:
        return Colors.grey[200]!;
    }
  }

  Color _getTextColor(String status) {
    switch (status) {
      case 'Success':
        return Colors.green[800]!;
      case 'Failed':
        return Colors.red[800]!;
      default:
        return Colors.black;
    }
  }

  return ListView.separated(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: transactions.length,
   separatorBuilder: (_, __) => SizedBox.shrink(),
    itemBuilder: (context, index) {
      final item = transactions[index];
      return ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
        leading: CircleAvatar(
          backgroundColor: AppColors.secondaryLight,
          radius: 24.r,
          child: Icon(item.icon, color: Colors.black),
        ),
        title: Text(item.title, style: TextStyle(fontSize: 16.sp)),
        subtitle: Text(item.time, style: TextStyle(fontSize: 12.sp, color: Colors.grey)),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '+\$${item.amount.toStringAsFixed(2)}',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp),
            ),
            SizedBox(height: 4.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: _getStatusColor(item.status),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                item.status,
                style: TextStyle(
                  color: _getTextColor(item.status),
                  fontSize: 12.sp,
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
}

class TransactionItem {
  final IconData icon;
  final String title;
  final String time;
  final double amount;
  final String status;

  TransactionItem({
    required this.icon,
    required this.title,
    required this.time,
    required this.amount,
    required this.status,
  });
}
