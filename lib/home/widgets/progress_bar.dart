import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  const ProgressBar({super.key, required this.percentage});

  final double percentage;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 10,
      width: double.infinity,
      decoration: BoxDecoration(border: Border.all(color: Colors.black)),
      child: Row(
        children: [
          Flexible(
            flex: (percentage * 100).toInt(),
            child: Container(color: Colors.black),
          ),
          Flexible(
            flex: ((1 - percentage) * 100).toInt(),
            child: Container(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
