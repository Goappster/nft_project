import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
            return user == null ? LoginScreen() :  CustomBottomNavScreen();
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

  // Your screen widgets (replace with actual implementations)
  final List<Widget> _screens = [
     GridScreen(),
    WalletScreen(),
    NFTScreen(),
    const HomePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,

        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home, color: Colors.black,),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_balance_wallet_outlined),
            selectedIcon: Icon(Icons.account_balance_wallet, color: Colors.black,),
            label: 'Wallet',
          ),
          NavigationDestination(
            icon: Icon(Icons.pie_chart_outline),
            selectedIcon: Icon(Icons.pie_chart, color: Colors.black,),
            label: 'Portfolio',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings, color: Colors.black,),
            label: 'Settings',
          ),
        ],
        elevation: 10,
        shadowColor: Colors.black,
        backgroundColor:  Colors.white,
        indicatorColor: Theme.of(context).colorScheme.primary,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
      ),
    );
  }
}

// class CustomBottomNavScreen extends StatefulWidget {
//   @override
//   State<CustomBottomNavScreen> createState() => _CustomBottomNavScreenState();
// }

// class _CustomBottomNavScreenState extends State<CustomBottomNavScreen> {
//   int _selectedIndex = 0;

//   final List<Widget> _screens = [
//     GridScreen(),
//     // const SearchScreen(),
//     const WalletScreen(),

//   ];

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _screens[_selectedIndex],
//       bottomNavigationBar: NavigationBar(
//         selectedIndex: _selectedIndex,
//         onDestinationSelected: _onItemTapped,
//         backgroundColor: Colors.white,
//         indicatorColor: Colors.green,
//         labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
//         destinations: const [
//           NavigationDestination(
//             icon: FaIcon(FontAwesomeIcons.house),
//             selectedIcon: FaIcon(FontAwesomeIcons.houseChimney),
//             label: 'Home',
//           ),
//           NavigationDestination(
//             icon: FaIcon(FontAwesomeIcons.wallet),
//             selectedIcon: FaIcon(FontAwesomeIcons.wallet),
//             label: 'Wallet',
//           ),
//           NavigationDestination(
//             icon: FaIcon(FontAwesomeIcons.chartPie),
//             selectedIcon: FaIcon(FontAwesomeIcons.chartSimple),
//             label: 'Portfolio',
//           ),
//           NavigationDestination(
//             icon: FaIcon(FontAwesomeIcons.gear),
//             selectedIcon: FaIcon(FontAwesomeIcons.solidCircleUser),
//             label: 'Settings',
//           ),
//         ],
//       ),
//     );
//   }
// }







