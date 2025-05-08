import 'package:e_commerical/screens/login.dart';
import 'package:e_commerical/widgets/changescreen.dart';
import 'package:e_commerical/widgets/mybutton.dart';
import 'package:e_commerical/widgets/mytextformfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/passwordtextformfield.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();


String p =
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
RegExp regExp = RegExp(p);
bool obserText = true;
String? email;
String? password;

class _SignupState extends State<Signup> {
  void validation() async {
    final FormState? form = _formKey.currentState;
    if (form!.validate()) {
      try {
        UserCredential result = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
            email: email!.trim(), password: password!.trim());
        print(result.user!.uid);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Đăng ký thành công!")),
        );

        // ✅ Sau khi đăng ký thành công, chuyển về màn hình Login
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const Login()),
        );

      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? "Lỗi không xác định")),
        );
      }
    }
  }


  Widget _buildAllTextFormField() {
    return Column(
      children: <Widget>[
        MyTextFormField(
          name: "UserName",
          onChanged: (value) {},
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Vui lòng điền User Name.";
            } else if (value.length < 6) {
              return "User Name quá ngắn.";
            }
            return null;
          },
        ),
        const SizedBox(height: 15),
        MyTextFormField(
          name: "Email",
          onChanged: (value) {
            setState(() {
              email = value;
            });
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Vui lòng nhập Email";
            } else if (!RegExp(
                r"^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$")
                .hasMatch(value)) {
              return "Email không hợp lệ";
            }
            return null;
          },
        ),

        const SizedBox(height: 15),

        PassWordTextFormField(
          name: "Password",
          obserText: obserText,
          onChanged: (value) {
            setState(() {
              password = value;
            });
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Vui lòng nhập mật khẩu";
            } else if (value.length < 6) {
              return "Mật khẩu ít nhất 6 ký tự";
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


        const SizedBox(height: 15),

        MyTextFormField(
          name: "Phone Number",
          onChanged: (value) {},
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Vui lòng nhập số điện thoại.";
            } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
              return "Số điện thoại chỉ được chứa số.";
            } else if (value.length < 9) {
              return "Số điện thoại phải có ít nhất 9 chữ số.";
            }
            return null;
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 50),
                  const Text(
                    "Register",
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),
                  _buildAllTextFormField(),
                  const SizedBox(height: 30),
                  MyButton(
                    name: "Sign Up",
                    onPressed: validation,
                  ),
                  const SizedBox(height: 20),
                  ChangeScreen(
                    name: "Login",
                    whichAccount: "I already have an account!",
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (ctx) => const Login()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
