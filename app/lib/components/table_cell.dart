import 'package:flutter/material.dart';

/// Wrapper for any widget that adds styling for minimalistic tables
class GSTableCell extends StatelessWidget {
  final Widget content;
  const GSTableCell(
      {super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: content
    );
  }
}
