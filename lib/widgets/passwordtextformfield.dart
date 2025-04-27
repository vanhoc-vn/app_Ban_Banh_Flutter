import 'package:flutter/material.dart';

class PassWordTextFormField extends StatelessWidget {
  final bool obserText;
  final String name;
  final String? Function(String?) validator;
  final VoidCallback onTap;

  const PassWordTextFormField({
    required this.onTap,
    required this.name,
    required this.obserText,
    required this.validator,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obserText,
      validator: validator,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: name,
        suffixIcon: GestureDetector(
          onTap: onTap,
          child: Icon(
            obserText ? Icons.visibility : Icons.visibility_off,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
