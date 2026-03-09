import 'package:flutter/material.dart';

class StrengthMeter extends StatelessWidget {
  final String strength;
  final double score;

  const StrengthMeter({
    super.key,
    required this.strength,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    Color getBarColor() {
      if (score >= 1.0) return Colors.green;
      if (score >= 0.7) return Colors.lightGreen;
      if (score >= 0.4) return Colors.orange;
      return Colors.red;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          strength,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: getBarColor(),
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: 80,
          height: 6,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(3),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: score,
            child: Container(
              decoration: BoxDecoration(
                color: getBarColor(),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
