import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'home_screen.dart';
import 'favorite_screen.dart';
import 'cart_screen.dart';
import 'profile_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final pages = const [
    HomeScreen(),
    FavoriteScreen(),
    CartScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _requestNotificationPermission();
  }

  // 🔔 REQUEST NOTIFICATION PERMISSION (ANDROID 13+)
  Future<void> _requestNotificationPermission() async {
    final status = await Permission.notification.status;

    if (status.isDenied) {
      await Permission.notification.request();
    }

    // Jika user menolak permanen
    if (status.isPermanentlyDenied) {
      await openAppSettings();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_currentIndex],

      // 🔽 NAVBAR AMAN UNTUK 3-BUTTON NAVIGATION
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          height: 72,
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [Colors.black, Color(0xFF1A1A1A)]),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(Icons.home, 0),
              _navItem(Icons.favorite_border, 1),
              _navItem(Icons.shopping_bag_outlined, 2),
              _navItem(Icons.person_outline, 3),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, int index) {
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: Icon(
        icon,
        size: 26,
        color: _currentIndex == index
            ? const Color(0xFFD4AF37)
            : Colors.white54,
      ),
    );
  }
}
