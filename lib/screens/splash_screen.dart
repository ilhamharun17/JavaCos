import 'dart:math';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';
import '../data/favorite_data.dart';
import '../data/cart_data.dart';
import 'main_navigation.dart';
import '../services/notification_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _next();
  }

  Future<void> _next() async {
    // 🚀 Jangan blocking splash
    NotificationService.init();

    await CartData.load();
    await FavoriteData.loadFavorites();

    await Future.delayed(const Duration(seconds: 2));

    final loggedIn = await AuthService.isLoggedIn();

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => loggedIn
            ? MainNavigation(key: MainNavigation.globalKey)
            : const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Transform.rotate(
            angle: -pi / 4,
            child: Container(
              width: MediaQuery.of(context).size.width * 2,
              height: MediaQuery.of(context).size.height * 2,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Color(0xFF000000),
                    Color(0xFF1A1A1A),
                    Color(0xFFD4AF37),
                  ],
                ),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                    children: [
                      TextSpan(
                        text: 'JAVA',
                        style: TextStyle(color: Color(0xFFD4AF37)),
                      ),
                      TextSpan(
                        text: 'COS',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Container(width: 180, height: 2, color: Colors.white),
                const SizedBox(height: 12),
                RichText(
                  text: const TextSpan(
                    style: TextStyle(fontSize: 14, letterSpacing: 1.2),
                    children: [
                      TextSpan(
                        text: "LET’S MAKE IT ",
                        style: TextStyle(color: Colors.black),
                      ),
                      TextSpan(
                        text: "LOOKS",
                        style: TextStyle(
                          color: Color(0xFFD4AF37),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: " GREAT",
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
