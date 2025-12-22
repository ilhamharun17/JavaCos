import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'home_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool rememberMe = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 60),
            const Text(
              'Welcome',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Please enter your data to continue',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 40),

            _field('Username'),
            _field('Password', obscure: true),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Remember me'),
                  Switch(
                    value: rememberMe,
                    onChanged: (v) => setState(() => rememberMe = v),
                  ),
                ],
              ),
            ),

            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RegisterScreen()),
                );
              },
              child: const Text(
                "Don't have an account? Sign Up",
                style: TextStyle(color: Color(0xFFD4AF37)),
              ),
            ),

            const Spacer(),

            GestureDetector(
              onTap: () async {
                await AuthService.login(rememberMe);
                if (!context.mounted) return;
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const HomeScreen()),
                );
              },
              child: Container(
                height: 64,
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black, Color(0xFF1A1A1A)],
                  ),
                ),
                child: const Center(
                  child: Text(
                    'Login',
                    style: TextStyle(
                      color: Color(0xFFD4AF37),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(String label, {bool obscure = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          TextField(
            obscureText: obscure,
            decoration: const InputDecoration(border: UnderlineInputBorder()),
          ),
        ],
      ),
    );
  }
}
