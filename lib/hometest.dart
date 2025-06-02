import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        toolbarHeight: 90.h,
        title: Row(
          children: [
            CircleAvatar(
              radius: 20.r,
              backgroundImage: const AssetImage('assets/avatar.png'),
            ),
            SizedBox(width: 10.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("yourEmailHere@gmail.com", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14.sp)),
                Text("Lvl One", style: TextStyle(color: Colors.grey, fontSize: 12.sp))
              ],
            ),
            const Spacer(),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.settings, color: Colors.black, size: 24.sp),
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: const Color(0xFF65D693),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Refer and Earn", style: TextStyle(color: Colors.white70, fontSize: 12.sp)),
                        SizedBox(height: 4.h),
                        Text("Refer your Friend\nand Win Cryptocoins",
                            style: TextStyle(fontSize: 16.sp, color: Colors.white, fontWeight: FontWeight.bold))
                      ],
                    ),
                  ),
                  Image.asset('assets/refer.png', width: 60.w)
                ],
              ),
            ),
            SizedBox(height: 20.h),
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.stars, color: Colors.amber, size: 24.sp),
                      SizedBox(width: 8.w),
                      Text("10,000", style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Text("Earn points by daily claims, staking, and invites.", style: TextStyle(fontSize: 14.sp)),
                  SizedBox(height: 10.h),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                    ),
                    child: Text("Redeem Now", style: TextStyle(fontSize: 14.sp)),
                  )
                ],
              ),
            ),
            SizedBox(height: 30.h),
            Text("How to Use", style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold)),
            SizedBox(height: 16.h),
            SizedBox(
              height: 120.h,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  useCard('assets/step1.png', 'How to Use the App to Earn money'),
                  useCard('assets/step2.png', 'How to Deposit Funds into Your Wallet'),
                  useCard('assets/step3.png', 'How to Invite Friends, Earn Bonus Points'),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        currentIndex: 1,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.pie_chart), label: 'Portfolio'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  Widget useCard(String assetPath, String detailsText) => Container(
    width: 100.w,
    margin: EdgeInsets.only(right: 12.w),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20.r),
    ),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.center,
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(assetPath, width: 60.w),
          Text(detailsText, style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.bold, ), textAlign: TextAlign.center)
        ],
      ),
    ),
  );
}
