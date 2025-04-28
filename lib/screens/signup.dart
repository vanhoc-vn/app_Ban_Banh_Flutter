import 'package:e_commerical/screens/login.dart';
import 'package:e_commerical/widgets/changescreen.dart';
import 'package:e_commerical/widgets/mybutton.dart';
import 'package:flutter/material.dart';
import 'package:e_commerical/widgets/mytextformField.dart';

import '../widgets/passwordtextformfield.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
String p =
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
RegExp regExp = new RegExp(p);
bool obserText = true;

class _SignupState extends State<Signup> {
  void validation() {
    final form = _formKey.currentState;
    if (form != null && form.validate()) {
      print("Yes");
    } else {
      print("No");
    }
  }

  Widget _buildAllTextFormField(){
    return Container(
      height: 300,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          MyTextFormField(
            name: "UserName",
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Vui lòng điền User Name.";
              } else if (value.length < 6) {
                return "User Name quá ngắn.";
              }
              return null; // hợp lệ thì return null
            },
          ),

          MyTextFormField(
            name: "Email",
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Vui lòng nhập Email";
              } else if (!regExp.hasMatch(value)) {
                return "Email không đúng.";
              }
              return null;
            },
          ),

          PassWordTextFormField(
            obserText: obserText,
            name: "Password",
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Vui lòng nhập Password";
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
          MyTextFormField(
            name: "Phone Number",
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
      ),
    );
  }

  Widget _buildBottomPart() {
    return Container(
      height: 400,
      margin: EdgeInsets.symmetric(horizontal: 10),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildAllTextFormField(),
          MyButton(
            name: "SignUp",
            onPressed: () {
              validation();
            },
          ),
          ChangeScreen(
            name: "Login",
            whichAccount: "I have Alrealy An Account!",
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (ctx) => Login()),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  height: 200,
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: const <Widget>[
                      Padding(
                        padding: EdgeInsets.only(bottom: 30),
                        child: Text(
                          "Register",
                          style: TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                /////
                // Thêm các input ở đây nếu muốn
                _buildBottomPart(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
