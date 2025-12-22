import 'package:flutter/material.dart';

class LocationScreen extends StatelessWidget {
  const LocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Fitur Lokasi Rental Terdekat',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
