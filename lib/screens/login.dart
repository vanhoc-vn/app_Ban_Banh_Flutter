import 'package:e_commerical/screens/admin/layout/admin_layout.dart';
import 'package:e_commerical/screens/homepage.dart';
import 'package:e_commerical/screens/signup.dart';
import 'package:e_commerical/widgets/changescreen.dart';
import 'package:e_commerical/widgets/mybutton.dart';
import 'package:e_commerical/widgets/mytextformField.dart';
import 'package:e_commerical/widgets/passwordtextformfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

final _formKey = GlobalKey<FormState>();
const _emailRegex =
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

class _LoginState extends State<Login> {
  bool obserText = true;
  bool _isLoading = false;
  String? email;
  String? password;

  final Color primary = const Color(0xFFF23B7E);
  final Color bg = const Color(0xFFFFF6FB);

  Future<void> _login() async {
    final form = _formKey.currentState;
    if (form == null || !form.validate() || email == null || password == null) return;

    setState(() => _isLoading = true);
    try {
      final cred = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email!.trim(),
        password: password!.trim(),
      );
      final uid = cred.user?.uid;
      if (uid == null) throw FirebaseAuthException(code: 'no-uid', message: 'Không lấy được UID');

      final token = await FirebaseAuth.instance.currentUser?.getIdTokenResult(true);
      final isAdminClaim = token?.claims?['admin'] == true;

      final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
      final data = doc.data() as Map<String, dynamic>?;
      final isBlocked = (data?['isBlocked'] as bool?) ?? false;
      final role = (data?['role'] as String?) ?? 'user';

      if (isBlocked) {
        await FirebaseAuth.instance.signOut();
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Tài khoản bị chặn. Liên hệ admin để được hỗ trợ."),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (!mounted) return;
      final isAdmin = isAdminClaim || role == 'admin';
      if (isAdmin) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const AdminLayout()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Đăng nhập thành công!")),
        );
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomePage()));
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? "Lỗi không xác định")),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  children: [
                    SizedBox(
                      height: 170,
                      child: Image.asset(
                        'images/dream_cake_2.png', // đảm bảo file nằm trong thư mục images/
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 26),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          MyTextFormField(
                            name: "Email",
                            onChanged: (v) => setState(() => email = v),
                            validator: (v) {
                              if (v == null || v.isEmpty) return "Please Fill Email";
                              if (!RegExp(_emailRegex).hasMatch(v)) return "Email không đúng.";
                              return null;
                            },
                          ),
                          const SizedBox(height: 14),
                          PassWordTextFormField(
                            obserText: obserText,
                            name: "Password",
                            onChanged: (v) => setState(() => password = v),
                            validator: (v) {
                              if (v == null || v.isEmpty) return "Please Fill Password";
                              if (v.length < 6) return "Mật khẩu phải có ít nhất 6 ký tự";
                              return null;
                            },
                            onTap: () {
                              FocusScope.of(context).unfocus();
                              setState(() => obserText = !obserText);
                            },
                          ),
                          const SizedBox(height: 22),
                          _isLoading
                              ? const CircularProgressIndicator()
                              : SizedBox(
                            width: double.infinity,
                            child: MyButton(onPressed: _login, name: "Login"),
                          ),
                          const SizedBox(height: 12),
                          ChangeScreen(
                            name: "SignUp",
                            whichAccount: "I Have Not Account!",
                            onTap: () => Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (_) => const Signup()),
                            ),
                          ),
                          const SizedBox(height: 8),
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