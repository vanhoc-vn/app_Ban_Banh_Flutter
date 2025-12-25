import 'package:flutter/material.dart';
import 'dart:async';
import '../main.dart'; // Để gọi AuthGate

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  static const Color primary = Color(0xFFF23B7E);
  static const Color bg = Color(0xFFFFF6FB);

  @override
  void initState() {
    super.initState();

    // Tự động chuyển trạng thái sau 3 giây
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        // Chuyển đến AuthGate để kiểm tra login thay vì vào thẳng Login screen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (ctx) => const AuthGate()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Logo
              SizedBox(
                height: 220,
                child: Image.asset(
                  "images/dream_cake_2.png",
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.cake, size: 100, color: primary),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                "Welcome to Dream Cake",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                "Sẵn sàng mua sắm những chiếc bánh ngọt xinh?",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 48),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(primary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}