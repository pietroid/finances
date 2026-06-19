import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  const ProgressBar({
    super.key,
    required this.percentage,
    required this.targetPercentage,
  });

  final double percentage;
  final double targetPercentage;

  Color get color {
    if (percentage <= targetPercentage) {
      return Colors.green;
    } else {
      final percentageOverTarget = (percentage - targetPercentage);
      final lerpValue = (percentageOverTarget / 0.2).clamp(0, 1).toDouble();
      // Interpolate green -> yellow -> red for a smoother transition.
      if (lerpValue <= 0.5) {
        // Green to Yellow
        return lerpColor(Colors.green, Colors.yellow, (lerpValue / 0.5));
      } else {
        // Yellow to Red
        return lerpColor(Colors.yellow, Colors.red, ((lerpValue - 0.5) / 0.5));
      }
    }
  }

  Color lerpColor(Color a, Color b, double t) {
    return Color.fromARGB(
      (a.alpha + (b.alpha - a.alpha) * t).round(),
      (a.red + (b.red - a.red) * t).round(),
      (a.green + (b.green - a.green) * t).round(),
      (a.blue + (b.blue - a.blue) * t).round(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 15,
      width: double.infinity,
      decoration: BoxDecoration(border: Border.all(color: Colors.black)),
      child: Stack(
        children: [
          Row(
            children: [
              Flexible(
                flex: (percentage * 100).toInt(),
                child: Container(color: color),
              ),
              Flexible(
                flex: ((1 - percentage) * 100).toInt(),
                child: Container(),
              ),
            ],
          ),
          Row(
            children: [
              Flexible(
                flex: (targetPercentage * 100).toInt(),
                child: Container(),
              ),
              Container(width: 1, color: Colors.black),
              Flexible(
                flex: ((1 - targetPercentage) * 100).toInt(),
                child: Container(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
