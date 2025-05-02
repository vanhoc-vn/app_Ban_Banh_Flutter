import 'package:e_commerical/screens/homepage.dart';
import 'package:flutter/material.dart';
import 'package:e_commerical/screens/signup.dart'; // đảm bảo đúng đường dẫn của bạn
import 'package:e_commerical/screens/login.dart';
import 'package:e_commerical/screens/listproduct.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
      home:  PhoneFrame(child: ListProduct()), // chạy Signup với giao diện điện thoại
    );
  }
}
// Widget giả lập giao diện khung điện thoại
class PhoneFrame extends StatelessWidget {
  final Widget child;

  const PhoneFrame({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300], // viền nền ngoài
      body: Center(
        child: Container(
          width: 390, // chiều rộng iPhone 13
          height: 844, // chiều cao iPhone 13
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
            border: Border.all(color: Colors.black12, width: 1),
          ),
          clipBehavior: Clip.hardEdge,
          child: Stack(
            children: [
              child,

              // phần notch mô phỏng (trên đầu)
              Positioned(
                top: 0,
                left: (390 / 2) - 60,
                child: Container(
                  width: 120,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(15),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
