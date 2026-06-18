import 'package:flutter/material.dart';

class AppEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? actionButtonText;
  final VoidCallback? onActionPressed;
  final String? actionButtonSemanticsLabel;
  final Key? actionButtonKey;
  final IconData? buttonIcon;

  const AppEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.actionButtonText,
    this.onActionPressed,
    this.actionButtonSemanticsLabel,
    this.actionButtonKey,
    this.buttonIcon,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 120,
                  width: 120,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEF2FF),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF6366F1).withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Icon(
                    icon,
                    size: 64,
                    color: const Color(0xFF6366F1),
                  ),
                ),
                const SizedBox(height: 28),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Colors.black87,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    height: 1.5,
                  ),
                ),
                if (actionButtonText != null && onActionPressed != null) ...[
                  const SizedBox(height: 32),
                  Semantics(
                    label: actionButtonSemanticsLabel,
                    identifier: actionButtonSemanticsLabel,
                    button: true,
                    child: _buildButton(),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildButton() {
    final style = ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF6366F1),
      padding: const EdgeInsets.symmetric(
        horizontal: 28,
        vertical: 16,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 4,
      shadowColor: const Color(0xFF6366F1).withOpacity(0.3),
    );

    final textStyle = const TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    );

    if (buttonIcon != null) {
      return ElevatedButton.icon(
        key: actionButtonKey,
        onPressed: onActionPressed,
        icon: Icon(
          buttonIcon,
          color: Colors.white,
          size: 20,
        ),
        label: Text(
          actionButtonText!,
          style: textStyle,
        ),
        style: style,
      );
    } else {
      return ElevatedButton(
        key: actionButtonKey,
        onPressed: onActionPressed,
        style: style,
        child: Text(
          actionButtonText!,
          style: textStyle,
        ),
      );
    }
  }
}
