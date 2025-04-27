import 'package:flutter/material.dart';

class ChangeScreen extends StatelessWidget {
  final String name;
  final String whichAccount;
  final VoidCallback onTap;

  const ChangeScreen({
    Key? key,
    required this.name,
    required this.whichAccount,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(whichAccount),
        SizedBox(width: 10),
        GestureDetector(
          onTap: onTap,
          child: Text(name, style: TextStyle(color: Colors.cyan, fontSize: 15)),
        ),
      ],
    );
  }
}
