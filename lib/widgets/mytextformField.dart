import 'package:flutter/material.dart';

class MyTextFormField extends StatelessWidget {
  final String name;
  final void Function(String)? onChanged;
  final String? Function(String?) validator;

  const MyTextFormField({
    required this.name,
    required this.onChanged,
    required this.validator,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      onChanged: onChanged,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        hintText: name,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}
