import 'package:e_commerical/screens/signup.dart';
import 'package:e_commerical/widgets/changescreen.dart';
import 'package:e_commerical/widgets/mybutton.dart';
import 'package:e_commerical/widgets/mytextformField.dart';
import 'package:e_commerical/widgets/passwordtextformfield.dart';
import 'package:flutter/material.dart';

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

class _LoginState extends State<Login> {
  void validation() {
    final FormState? form = _formKey.currentState;
    if (form != null && form.validate()) {
      print("Yes");
    } else {
      print("No");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // <-- Canh trái cho đẹp hơn
              children: <Widget>[
                const SizedBox(height: 100), // <-- thêm khoảng trống để đẩy xuống
                const Center(
                  child: Text(
                    "Login",
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                MyTextFormField(
                  name: "Email",
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
          ),
        ),
      ),
    );
  }
}
