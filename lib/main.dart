import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:music_mind_client/constants/constants.dart';
import 'package:music_mind_client/controller/bindings/auth_binding.dart';
import 'package:music_mind_client/utils/root.dart';
import 'package:music_mind_client/view/bottom_nav_bar/bottom_nav_bar.dart';
import 'package:music_mind_client/view/home/body/body_missions/body_missions.dart';
import 'package:music_mind_client/view/home/mind/mind.dart';
import 'package:music_mind_client/view/home/mind/mind_missions/mind_missions.dart';
import 'package:music_mind_client/view/home/body/body.dart';
import 'package:music_mind_client/view/splash_Screen/splash_screen.dart';
import 'package:music_mind_client/view/user/login.dart';
import 'package:music_mind_client/view/user/register.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp();
  Stripe.publishableKey = 'pk_test_neFiWZmP73t6MxcbqrATir3y00YX32CRnz';
  runApp(MusicMindApp());
}

class MusicMindApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      initialBinding: AuthBinding(),
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
        GetPage(name: '/root', page: ()=> Root()),
        GetPage(name: '/splash_screen', page: ()=> SplashScreen()),
        GetPage(name: '/login', page: ()=> Login()),
        GetPage(name: '/register', page: ()=> Register()),
        GetPage(name: '/bottom_nav_bar', page: ()=> BottomNavBar()),
        GetPage(name: '/mind', page: ()=> Mind()),
        GetPage(name: '/mind_missions', page: ()=> MindMissions()),
        GetPage(name: '/body', page: ()=> Boddy()),
        GetPage(name: '/body_missions', page: ()=> BodyMissions())
      ],
    );
  }
}
