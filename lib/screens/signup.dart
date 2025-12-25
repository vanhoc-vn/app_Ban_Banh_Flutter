import 'package:e_commerical/screens/login.dart';
import 'package:e_commerical/widgets/changescreen.dart';
import 'package:e_commerical/widgets/mybutton.dart';
import 'package:e_commerical/widgets/mytextformfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/passwordtextformfield.dart';
import '../model/user_model.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

const _emailRegex =
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,4}$))';

bool obserText = true;
String? email;
String? password;
String? userName;
String? phoneNumber;

class _SignupState extends State<Signup> {
  bool _isLoading = false;
  final Color primary = const Color(0xFFF23B7E);
  final Color bg = const Color(0xFFFFF6FB);

  Future<void> validation() async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;

    setState(() => _isLoading = true);
    try {
      final result = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email!.trim(),
        password: password!.trim(),
      );

      final uid = result.user?.uid;
      if (uid == null) {
        throw FirebaseAuthException(code: 'no-uid', message: 'Không lấy được UID');
      }

      final userModel = UserModel(
        uid: uid,
        email: email!.trim(),
        phone: phoneNumber?.trim(),
        userName: userName?.trim(),
        role: 'user',
        isBlocked: false,
      );

      await FirebaseFirestore.instance.collection('users').doc(uid).set(userModel.toMap());

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Đăng ký thành công!")),
      );
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const Login()),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? "Lỗi không xác định")),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Widget _buildAllTextFormField() {
    return Column(
      children: <Widget>[
        MyTextFormField(
          name: "UserName",
          onChanged: (value) => setState(() => userName = value),
          validator: (value) {
            if (value == null || value.isEmpty) return "Vui lòng điền User Name.";
            if (value.length < 3) return "User Name quá ngắn.";
            return null;
          },
        ),
        const SizedBox(height: 15),
        MyTextFormField(
          name: "Email",
          onChanged: (value) => setState(() => email = value),
          validator: (value) {
            if (value == null || value.isEmpty) return "Vui lòng nhập Email";
            if (!RegExp(_emailRegex).hasMatch(value)) return "Email không hợp lệ";
            return null;
          },
        ),
        const SizedBox(height: 15),
        PassWordTextFormField(
          name: "Password",
          obserText: obserText,
          onChanged: (value) => setState(() => password = value),
          validator: (value) {
            if (value == null || value.isEmpty) return "Vui lòng nhập mật khẩu";
            if (value.length < 6) return "Mật khẩu ít nhất 6 ký tự";
            return null;
          },
          onTap: () {
            FocusScope.of(context).unfocus();
            setState(() => obserText = !obserText);
          },
        ),
        const SizedBox(height: 15),
        MyTextFormField(
          name: "Phone Number",
          onChanged: (value) => setState(() => phoneNumber = value),
          validator: (value) {
            if (value == null || value.isEmpty) return "Vui lòng nhập số điện thoại.";
            if (!RegExp(r'^[0-9]+$').hasMatch(value)) return "Số điện thoại chỉ được chứa số.";
            if (value.length < 9) return "Số điện thoại phải có ít nhất 9 chữ số.";
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
      backgroundColor: bg,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 170,
                      child: Image.asset(
                        'images/dream_cake_2.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 26),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          _buildAllTextFormField(),
                          const SizedBox(height: 30),
                          _isLoading
                              ? const CircularProgressIndicator()
                              : SizedBox(
                            width: double.infinity,
                            child: MyButton(name: "Sign Up", onPressed: validation),
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
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}