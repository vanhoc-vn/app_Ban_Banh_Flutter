import 'package:e_commerical/screens/admin/layout/admin_layout.dart';
import 'package:e_commerical/screens/homepage.dart';
import 'package:e_commerical/screens/signup.dart';
import 'package:e_commerical/widgets/changescreen.dart';
import 'package:e_commerical/widgets/mybutton.dart';
import 'package:e_commerical/widgets/mytextformField.dart';
import 'package:e_commerical/widgets/passwordtextformfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
String p =
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

RegExp regExp = RegExp(p);

bool obserText = true;
String? email;
String? password;

class _LoginState extends State<Login> {
  Widget _buildAllPart() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 100),
          const Center(
            child: Text(
              "Login",
              style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 30),
          MyTextFormField(
            name: "Email",
            onChanged: (value) {
              setState(() {
                email = value;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please Fill Email";
              } else if (!regExp.hasMatch(value)) {
                return "Email không đúng.";
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          PassWordTextFormField(
            obserText: obserText,
            name: "Password",
            onChanged: (value) {
              setState(() {
                password = value;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please Fill Password";
              } else if (value.length < 6) {
                return "Mật khẩu phải có ít nhất 6 ký tự";
              }
              return null;
            },
            onTap: () {
              FocusScope.of(context).unfocus();
              setState(() {
                obserText = !obserText;
              });
            },
          ),
          const SizedBox(height: 20),
          MyButton(
            onPressed: () {
              validation();
            },
            name: "Login",
          ),
          const SizedBox(height: 10),
          ChangeScreen(
            name: "SignUp",
            whichAccount: "I Have Not Account!",
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (ctx) => const Signup()),
              );
            },
          ),
        ],
      ),
    );
  }

  void validation() async {
    final FormState? form = _formKey.currentState;
    if (form!.validate()) {
      try {
        // Đăng nhập với Firebase Auth
        UserCredential result = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
              email: email!.trim(),
              password: password!.trim(),
            );

        // Lấy thông tin user từ Firestore
        DocumentSnapshot userDoc =
            await FirebaseFirestore.instance
                .collection('users')
                .doc(result.user!.uid)
                .get();

        if (userDoc.exists) {
          String role = userDoc.get('role') ?? 'user';
          String storedPassword = userDoc.get('password') ?? '';

          // Kiểm tra isBlocked với giá trị mặc định là false nếu chưa tồn tại
          bool isBlocked = false;
          if (userDoc.data() != null) {
            Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
            isBlocked = data['isBlocked'] ?? false;
          }

          // Kiểm tra xem tài khoản có bị chặn không
          if (isBlocked) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    "Tài khoản của bạn đã bị chặn. Vui lòng liên hệ admin để được hỗ trợ.",
                  ),
                  backgroundColor: Colors.red,
                ),
              );
              // Đăng xuất người dùng nếu tài khoản bị chặn
              await FirebaseAuth.instance.signOut();
              return;
            }
          }

          // Kiểm tra password
          if (password!.trim() == storedPassword) {
            if (mounted) {
              if (role == 'admin') {
                // Chuyển đến trang admin
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const AdminLayout()),
                );
              } else {
                // Chuyển đến trang user
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Đăng nhập thành công!")),
                );
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              }
            }
          } else {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Mật khẩu không đúng")),
              );
            }
          }
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Không tìm thấy thông tin người dùng"),
              ),
            );
          }
        }
      } on FirebaseAuthException catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.message ?? "Lỗi không xác định")),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[_buildAllPart()],
            ),
          ),
        ),
      ),
    );
  }
}
