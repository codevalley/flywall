import 'package:flutter/material.dart';

class UIConstants {
  // Card dimensions
  static const double maxCardWidth = 450.0;
  static const double minCardHeight = 140.0;
  static const double maxCardHeight = 600.0;

  // Common padding and spacing
  static const double cardHorizontalPadding = 24.0;
  static const double cardVerticalPadding = 20.0;
  static const double cardPeekOffset = 40.0;

  // Border properties
  static const double cardBorderRadius = 20.0;
  static const double cardBorderWidth = 1.0;
  static const double cardDividerHeight = 0.5;

  // Icon sizes
  static const double cardIconSize = 18.0;
  static const double cardArrowSize = 24.0;
  static const double cardArrowRotation = -0.79;

  // Spacing
  static const double smallSpacing = 4.0;
  static const double mediumSpacing = 8.0;
  static const double largeSpacing = 12.0;
  static const double extraLargeSpacing = 16.0;

  // Message list
  static const double messageMaxWidthFactor = 0.75;
  static const double messageCodeBlockRadius = 4.0;
  static const double messageTopSpacing = 12.0;

  // Edge insets
  static const EdgeInsets cardMainPadding = EdgeInsets.fromLTRB(
    cardHorizontalPadding,
    cardVerticalPadding,
    cardHorizontalPadding,
    largeSpacing,
  );

  static const EdgeInsets cardBottomPadding = EdgeInsets.fromLTRB(
    cardHorizontalPadding,
    largeSpacing,
    cardHorizontalPadding,
    largeSpacing,
  );

  static const EdgeInsets cardDividerPadding = EdgeInsets.symmetric(
    horizontal: 20.0,
  );
}
