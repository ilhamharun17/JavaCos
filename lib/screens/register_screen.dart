import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'home_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool rememberMe = true;
  bool obscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Back button
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
              ),
            ),

            const SizedBox(height: 16),

            const Text(
              'Sign Up',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 40),

            _field('Username'),
            _field(
              'Password',
              obscure: obscure,
              suffix: const Text(
                'Strong',
                style: TextStyle(color: Colors.green),
              ),
              toggle: () => setState(() => obscure = !obscure),
            ),
            _field(
              'Email Address',
              suffix: const Icon(Icons.check, color: Colors.green),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Remember me'),
                  Switch(
                    value: rememberMe,
                    onChanged: (v) => setState(() => rememberMe = v),
                    activeThumbColor: Colors.green,
                  ),
                ],
              ),
            ),

            const Spacer(),

            _bottomButton(
              text: 'Sign Up',
              onTap: () async {
                await AuthService.login(rememberMe);

                if (!context.mounted) return;

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const HomeScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(
    String label, {
    bool obscure = false,
    Widget? suffix,
    VoidCallback? toggle,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          TextField(
            obscureText: obscure,
            decoration: InputDecoration(
              border: const UnderlineInputBorder(),
              suffixIcon: toggle != null
                  ? IconButton(
                      icon: const Icon(Icons.visibility),
                      onPressed: toggle,
                    )
                  : suffix,
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomButton({required String text, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 64,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Colors.black, Color(0xFF1A1A1A)]),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: Color(0xFFD4AF37),
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
