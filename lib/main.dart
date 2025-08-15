import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:untitled/app_theme.dart';
import 'package:untitled/constants.dart';
import 'package:untitled/hometest.dart';
import 'package:untitled/routes.dart';
import 'package:untitled/views/Nft/ChipFilter/bloc.dart';
import 'package:untitled/views/Nft/home_screen.dart';
import 'package:untitled/views/UserPortolio/bloc/nft_bloc.dart';
import 'package:untitled/views/UserPortolio/bloc/nft_event.dart';
import 'package:untitled/views/UserPortolio/repository/nft_repository.dart';
import 'package:untitled/views/UserPortolio/user_portfollio.dart';
import 'package:untitled/views/auth/login_screen.dart';
import 'package:untitled/views/auth/user_profile_screen.dart';
import 'package:untitled/views/wallet/wallet.dart';


import 'Controller/user_controller.dart';
import 'SaveUser/cubit/user_cubit.dart';
import 'SaveUser/models/user.dart';
import 'SaveUser/services/user_storage.dart';

// Screens
class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text("Search Screen", )));
  }
}


// Main App
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(UserController());
  final user = await UserStorage.getUser();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<NFTBloc>(
          create: (_) => NFTBloc(NFTRepository())..add(LoadNFTs(user!.userId)),
        ),
        BlocProvider(
          create: (_) => UserCubit(user),  // pass nullable user safely
        ),
        BlocProvider(
        create: (_) => ChipFilterBloc(),
  
      ),
      ],
      child:  MyApp(),
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
        // initialRoute: AppRoutes.home,
        onGenerateRoute: AppRoutes.generateRoute,
        home: BlocBuilder<UserCubit, User?>(
          builder: (context, user) {
            return user == null ? LoginScreen() :  LoginScreen();
          },
        ),
         theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: ThemeMode.light,
      ),
    );
  }
}

class CustomBottomNavScreen extends StatefulWidget {
  @override
  State<CustomBottomNavScreen> createState() => _CustomBottomNavScreenState();
}

class _CustomBottomNavScreenState extends State<CustomBottomNavScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
     GridScreen(),
    const SearchScreen(),
    const WalletScreen(),
    NFTScreen(),
    const HomePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildNavItem({required IconData icon, required String label, required int index}) {
    final bool isSelected = _selectedIndex == index;
    final Color color = isSelected ? Color(0xffdcf6ac) : Color(0xff76a221);

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color),
          Text(label, style: TextStyle(color: color, fontSize: 12)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
  
       extendBody: true,
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomAppBar(
        elevation: 6,
        shape: const CircularNotchedRectangle(),
        color: Color(0xff32460e),
        notchMargin: 12,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Left side icons
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildNavItem(icon: HugeIcons.strokeRoundedHome01, label: "Home", index: 0),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildNavItem(icon: HugeIcons.strokeRoundedNews, label: "News", index: 1),
                ],
              ),
              SizedBox(width: 50), // Space for FAB
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildNavItem(icon: HugeIcons.strokeRoundedChartRose, label: "Portfolio", index: 3),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildNavItem(icon: HugeIcons.strokeRoundedAccountSetting03, label: "Setting", index: 4),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        elevation: 3,
      
        tooltip: 'wallet',
        backgroundColor: AppColors.primaryLight,
        shape: CircleBorder(
   
  ),
        onPressed: () => _onItemTapped(2),
        child: SvgPicture.asset(SvgIcons.Wallet, width: 24, height: 24, color: Colors.black,),
      ),
    );
  }
}











