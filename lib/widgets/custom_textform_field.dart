import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputAction textInputAction;
  final String labelText;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final TextCapitalization? textCapitalization;
  final int? maxLines;
  final int? maxLength;

  const CustomTextFormField({
    super.key,
    required this.controller,
    this.textInputAction = TextInputAction.none,
    this.textCapitalization = TextCapitalization.none,
    required this.labelText,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.maxLines,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: controller,
        textInputAction: defaultTargetPlatform == TargetPlatform.iOS
            ? TextInputAction.done
            : textInputAction,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(fontSize: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          alignLabelWithHint: true,
        ),
        keyboardType: keyboardType,
        validator: validator,
        maxLines: maxLines,
        maxLength: maxLength);
  }
}
