import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    required this.label,
    this.onSubmitted,
    this.inputformatters,
    this.keyboardType,
    this.validator, this.controller,
  });
  final String label;
  final ValueChanged<String>? onSubmitted;
  final List<TextInputFormatter>? inputformatters;
  final TextInputType? keyboardType;
  final FormFieldValidator<String>? validator;
  final TextEditingController? controller;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onFieldSubmitted: onSubmitted,
      controller: controller,
      inputFormatters: inputformatters,
      keyboardType: keyboardType,
      validator: validator,
      cursorColor: Color(0xFFF2796B),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 0),
        constraints: BoxConstraints(maxHeight: 58, minHeight: 43),
        filled: true,
        fillColor: Colors.white,
        label: Text(label, style: TextStyle(fontSize: 13)),
        labelStyle: TextStyle(color: Colors.grey[800]),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFF2796B)),
        ),
      ),
    );
  }
}
