import 'package:flutter/material.dart';
import '../theme/theme.dart';

class OutlinedActionButton extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback onPressed;

  const OutlinedActionButton({
    super.key,
    required this.text,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            side: BorderSide(width: 1, color: color),
            borderRadius: BorderRadius.circular(50),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              style: AppTypography.button.copyWith(color: color),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.arrow_forward,
              color: color,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class BottomRowButton extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback onPressed;
  final bool showDivider;

  const BottomRowButton({
    super.key,
    required this.text,
    required this.color,
    required this.onPressed,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showDivider)
          Container(
            height: 1,
            color: Colors.white.withOpacity(0.1),
          ),
        InkWell(
          onTap: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              children: [
                Text(
                  text,
                  style: AppTypography.buttonSerif.copyWith(color: color),
                ),
                const Spacer(),
                Transform.rotate(
                  angle: -45 * 3.14 / 180, // 45 degrees upward
                  child: Icon(
                    Icons.arrow_forward,
                    color: color,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
