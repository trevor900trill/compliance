import 'package:flutter/material.dart';

/// A modern card widget with gradient icon background
class GradientIcon extends StatelessWidget {
  final IconData icon;
  final Gradient gradient;
  final double size;
  final Color iconColor;

  const GradientIcon({
    super.key,
    required this.icon,
    required this.gradient,
    this.size = 56,
    this.iconColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: gradient,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: gradient.colors.first.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(
        icon,
        color: iconColor,
        size: size * 0.5,
      ),
    );
  }
}
