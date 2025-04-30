import 'package:e_commerical/screens/signup.dart';
import 'package:e_commerical/widgets/changescreen.dart';
import 'package:e_commerical/widgets/mybutton.dart';
import 'package:e_commerical/widgets/mytextformField.dart';
import 'package:e_commerical/widgets/passwordtextformfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
              } else if (value.length < 8) {
                return "Mật khẩu phải có ít nhất 8 ký tự";
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
        UserCredential result = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
            email: email!.trim(), password: password!.trim());
        print(result.user!.uid);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Đăng nhập thành công!")),
        );
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? "Lỗi không xác định")),
        );
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
