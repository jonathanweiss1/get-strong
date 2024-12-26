import 'package:flutter/material.dart';

/// A panel consisting of a label and a value on a gradient background
class FactPanel extends StatelessWidget {
  final String label;
  final String value;
  final Gradient colorGradient;

  const FactPanel(
      {super.key, required this.label, required this.value, required this.colorGradient});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
            gradient: colorGradient,
            borderRadius: BorderRadius.circular(20)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(label, style: const TextStyle(color: Color(0xFFFFFFFF), fontWeight: FontWeight.w300, fontSize: 15)),
            Text(value, style: const TextStyle(color: Color(0xFFFFFFFF), fontWeight: FontWeight.bold, fontSize: 30))
          ],
          )
    );
  }
}
