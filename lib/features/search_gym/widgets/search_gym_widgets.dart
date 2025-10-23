import 'package:flutter/material.dart';

class GymBadge extends StatelessWidget {
  final String label;
  final EdgeInsetsGeometry padding;
  final Color? background;
  final Color? textColor;
  final double radius;

  const GymBadge(
    this.label, {
    super.key,
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    this.background,
    this.textColor,
    this.radius = 12,
  });

  @override
  Widget build(BuildContext context) {
    final bg = background ?? Theme.of(context).colorScheme.surfaceContainerHighest;
    final tc = textColor ?? Theme.of(context).textTheme.bodySmall?.color ?? Colors.black;

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 12, color: tc),
      ),
    );
  }
}