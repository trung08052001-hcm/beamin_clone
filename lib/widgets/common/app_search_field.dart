import 'package:flutter/material.dart';

class AppSearchField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Function(String)? onSubmitted;
  final bool autofocus;
  final Widget? prefixIcon;
  final double height;
  final Color? backgroundColor;

  const AppSearchField({
    super.key,
    required this.controller,
    required this.hintText,
    this.onSubmitted,
    this.autofocus = false,
    this.prefixIcon,
    this.height = 44,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: controller,
        autofocus: autofocus,
        onSubmitted: onSubmitted,
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
          prefixIcon:
              prefixIcon ??
              Icon(Icons.search, color: Colors.grey.shade400, size: 20),
          border: InputBorder.none,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        ),
      ),
    );
  }
}
