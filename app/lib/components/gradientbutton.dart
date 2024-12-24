import 'package:app/config.dart';
import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  final Function? onPressed;
  final String label;
  final Gradient colorGradient;

  const GradientButton(
      {super.key, required this.onPressed, required this.label, required this.colorGradient});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 32,
        decoration: BoxDecoration(
            gradient: colorGradient,
            borderRadius: BorderRadius.circular(20)),
            padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
        child: TextButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
            ),
            onPressed: onPressed == null ? null : () => onPressed!(),
            child: Text(
              label, 
              style: const TextStyle(
                color: Color(0xFFFFFFFF),
                fontSize: 16))));
  }
}
