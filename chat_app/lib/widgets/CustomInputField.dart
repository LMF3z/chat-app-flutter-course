import 'package:flutter/material.dart';

class CustomInputField extends StatelessWidget {
  final TextEditingController textEditingController;

  final bool? autoCorrect;
  final bool? obscuredText;
  final TextInputType? textInputType;
  final IconData? prefixIcon;
  final String? hintText;

  const CustomInputField({
    super.key,
    required this.textEditingController,
    this.autoCorrect = false,
    this.obscuredText = false,
    this.textInputType,
    this.prefixIcon,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 5, left: 5, bottom: 5, right: 20),
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 5),
            blurRadius: 5,
          ),
        ],
      ),
      child: TextField(
        controller: textEditingController,
        autocorrect: autoCorrect!,
        keyboardType: textInputType,
        obscureText: obscuredText!,
        decoration: InputDecoration(
          prefixIcon: Icon(prefixIcon),
          focusedBorder: InputBorder.none,
          border: InputBorder.none,
          hintText: hintText,
        ),
      ),
    );
  }
}
