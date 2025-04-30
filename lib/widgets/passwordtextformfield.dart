import 'package:flutter/material.dart';

class PassWordTextFormField extends StatelessWidget {
  final bool obserText;
  final String name;
  final String? Function(String?) validator;
  final VoidCallback onTap;
  final void Function(String)? onChanged;

  const PassWordTextFormField({
    required this.onChanged,
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
      onChanged: onChanged,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        hintText: name,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
