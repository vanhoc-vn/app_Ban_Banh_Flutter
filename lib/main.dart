import 'package:e_commerical/provider/categorie_provider.dart';
import 'package:e_commerical/provider/product_provider.dart';
import 'package:e_commerical/screens/homepage.dart';
import 'package:e_commerical/screens/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const AppWrapper());
}

class AppWrapper extends StatelessWidget {
  const AppWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: MultiProvider(
        providers: [
          ListenableProvider<ProductProvider>(
              create: (ctx) => ProductProvider()),
          ListenableProvider<CategoryProvider>(
              create: (ctx) => CategoryProvider()),
        ],
        child: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasData) {
              return HomePage(); // người dùng đã đăng nhập
            } else {
              return const Login(); // chưa đăng nhập
            }
          },
        ),
      ),
    );
  }
}
