import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:music_mind_client/constants/constants.dart';
import 'package:music_mind_client/view/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:music_mind_client/view/home/mind/mind.dart';
import 'package:music_mind_client/view/home/mind/mind_missions/mind_missions.dart';
import 'package:music_mind_client/view/splash_Screen/splash_screen.dart';
import 'package:music_mind_client/view/user/login.dart';
import 'package:music_mind_client/view/user/register.dart';

void main() => runApp(MusicMindApp());

class MusicMindApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      theme: ThemeData(
        fontFamily: 'Noto Sans',
        scaffoldBackgroundColor: KPrimaryColor,
        accentColor: KPrimaryColor.withOpacity(0.5),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          color: KPrimaryColor,
        ),
      ),
      themeMode: ThemeMode.light,
      initialRoute: '/splash_screen',
      getPages: [
        GetPage(name: '/splash_screen', page: ()=> SplashScreen()),
        GetPage(name: '/login', page: ()=> Login()),
        GetPage(name: '/register', page: ()=> Register()),
        GetPage(name: '/bottom_nav_bar', page: ()=> BottomNavBar()),
        GetPage(name: '/mind', page: ()=> Mind()),
        GetPage(name: '/mind_missions', page: ()=> MindMissions()),
      ],
    );
  }
}
