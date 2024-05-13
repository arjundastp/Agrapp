import 'package:agriplant/auth/auth.dart';
import 'package:agriplant/auth/login_or_register.dart';
import 'package:agriplant/pages/cart_page.dart';
import 'package:agriplant/pages/forum_page.dart';
import 'package:agriplant/pages/home_page.dart';

import 'package:agriplant/pages/profile_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
        textTheme: GoogleFonts.nunitoTextTheme(),
      ),
      routes: {
        '/login_or_register_page': (context) => const LoginOrRegister(),
        '/home_page': (context) => const HomePage(),
        '/profile_page': (context) => ProfilePage(),
        '/ai_doctor': (context) => const CartPage(),
        '/forum_page': (context) => ForumPage(),
      },
      home: const AuthPage(),
    );
  }
}
