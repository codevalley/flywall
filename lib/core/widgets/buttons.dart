// lib/core/widgets/buttons.dart
import 'package:flutter/material.dart';
import '../theme/theme.dart';

class OutlinedActionButton extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback? onPressed;

  const OutlinedActionButton({
    super.key,
    required this.text,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: color, width: 1),
        padding: const EdgeInsets.symmetric(
          horizontal: 32,
          vertical: 16,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            text,
            style: AppTypography.buttonAction.copyWith(color: color),
          ),
          const SizedBox(width: 8),
          Icon(
            Icons.arrow_forward,
            color: color,
            size: 20,
          ),
        ],
      ),
    );
  }
}

class BottomRowButton extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback? onPressed;
  final bool showDivider;
  final bool showSpinner;

  const BottomRowButton({
    super.key,
    required this.text,
    required this.color,
    required this.onPressed,
    this.showDivider = true,
    this.showSpinner = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showDivider)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              height: 1,
              color: AppColors.white,
            ),
          ),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 18,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    text,
                    style: AppTypography.button.copyWith(
                      color: onPressed == null ? AppColors.textDisabled : color,
                    ),
                  ),
                  if (showSpinner)
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(color),
                      ),
                    )
                  else
                    Transform.rotate(
                      angle: -45 * 3.14 / 180,
                      child: Icon(
                        Icons.arrow_forward,
                        color:
                            onPressed == null ? AppColors.textDisabled : color,
                        size: 20,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
