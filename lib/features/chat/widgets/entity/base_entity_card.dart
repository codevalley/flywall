import 'package:flutter/material.dart';

abstract class BaseEntityCard extends StatelessWidget {
  final VoidCallback? onTap;

  const BaseEntityCard({
    super.key,
    this.onTap,
  });

  @protected
  Widget buildIcon();

  @protected
  String getTypeText();

  @protected
  Widget buildContent();

  @protected
  Widget? buildBottomRow() => null;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 332,
        height: 140,
        decoration: ShapeDecoration(
          color: Colors.transparent,
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 1, color: Colors.white),
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with icon and type
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    buildIcon(),
                    const SizedBox(width: 8),
                    Text(
                      getTypeText(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: 'Graphik',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                Transform.rotate(
                  angle: -0.79,
                  child: const Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ],
            ),

            const Spacer(),

            // Content
            buildContent(),

            const Spacer(),

            // Bottom Row (if any)
            if (buildBottomRow() != null) buildBottomRow()!,
          ],
        ),
      ),
    );
  }
}
