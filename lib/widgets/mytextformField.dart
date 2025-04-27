import 'package:flutter/material.dart';

class MyTextFormField extends StatelessWidget {
  final String name;
  final String? Function(String?) validator;

  const MyTextFormField({required this.name, required this.validator, super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: name,
      ),
    );
  }
}
