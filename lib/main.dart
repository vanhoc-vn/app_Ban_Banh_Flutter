import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

// Import Options & Providers
import 'firebase_options.dart';
import 'package:e_commerical/provider/admin_product_provider.dart';
import 'package:e_commerical/provider/categorie_provider.dart';
import 'package:e_commerical/provider/product_provider.dart';
import 'package:e_commerical/provider/order_provider.dart';
import 'package:e_commerical/provider/customer_provider.dart';

// Import Screens
import 'package:e_commerical/screens/welcomescreen.dart';
import 'package:e_commerical/screens/homepage.dart';
import 'package:e_commerical/screens/login.dart';
import 'package:e_commerical/screens/admin/layout/admin_layout.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const AppWrapper());
}

class AppWrapper extends StatelessWidget {
  const AppWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AdminProductProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => CustomerProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Dream Cake',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.pinkAccent),
          useMaterial3: true,
        ),
        // Điểm bắt đầu luôn là WelcomeScreen
        home: const WelcomeScreen(),
      ),
    );
  }
}

/// Widget trung gian để kiểm tra quyền truy cập sau khi Chào mừng xong
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // 1. Nếu đang kiểm tra kết nối
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        // 2. Nếu chưa đăng nhập -> Chuyển đến Login
        if (!snapshot.hasData) {
          return const Login();
        }

        // 3. Nếu đã đăng nhập -> Kiểm tra Role (Admin hay User)
        final user = snapshot.data!;
        return FutureBuilder<IdTokenResult>(
          future: user.getIdTokenResult(true),
          builder: (context, tokenSnap) {
            if (tokenSnap.connectionState == ConnectionState.waiting) {
              return const Scaffold(body: Center(child: CircularProgressIndicator()));
            }

            final isAdmin = tokenSnap.data?.claims?['admin'] == true;

            if (isAdmin) {
              return const AdminLayout();
            } else {
              return HomePage();
            }
          },
        );
      },
    );
  }
}