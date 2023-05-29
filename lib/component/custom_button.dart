import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.onTap,
    this.widget,
    this.borderColor = const Color(0xff61C3F2),
    this.backgroundColor = const Color(0xff61C3F2),
  });

  final Function()? onTap;
  final Widget? widget;
  final Color borderColor;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          padding: const EdgeInsets.symmetric(vertical: 13),
          width: MediaQuery.of(context).size.width * (.58),
          decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: borderColor)),
          child: widget),
    );
  }
}
