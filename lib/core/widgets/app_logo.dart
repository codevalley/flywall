// lib/core/widgets/app_logo.dart
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme/theme.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.string(
          '''
<svg width="101" height="94" viewBox="0 0 101 94" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M35.8 93.84L10.36 75.6L31 53.04L29.08 52.56L29.32 52.8L0.76001 47.28L10.36 17.28L38.44 30.24L36.52 14.16C36.2 11.44 35.88 8.96 35.56 6.72C35.4 4.32 35.16 2.08 34.84 0H66.52L62.92 30.24L77.8 23.28C80.36 22 82.68 20.88 84.76 19.92C87 18.8 89.08 17.84 91 17.04L100.6 47.04L70.6 53.04L91.48 75.36L65.32 93.36L50.68 67.2L47.8 72.72L35.8 93.84ZM34.6 87.84L44.2 70.8C45.32 68.72 46.36 66.8 47.32 65.04C48.44 63.12 49.64 61.12 50.92 59.04L66.76 87.36L85.24 74.64C81.56 70.96 77.8 66.96 73.96 62.64L62.68 50.4L95.08 43.92L88.6 22.8L58.12 36.96L61.72 4.08H39.64C40.12 9.2 40.68 14.72 41.32 20.64C42.12 26.4 42.92 32 43.72 37.44L13 22.8L6.28001 43.92C9.96001 44.72 13.88 45.52 18.04 46.32C22.36 47.12 26.28 47.84 29.8 48.48L38.92 50.16L16.6 74.88L34.6 87.84ZM33.88 84.72L19.72 74.4L43 48.96C40.28 48.48 37.48 48 34.6 47.52C31.88 46.88 29 46.24 25.96 45.6C22.92 44.96 19.96 44.4 17.08 43.92C14.36 43.28 11.64 42.8 8.92001 42.48L14.44 25.68L45.88 40.56L42.04 5.99999H59.56L55.48 40.32L86.92 25.68L92.44 42.48L58.36 48.96L82.12 74.16L67.72 84.24L50.92 54.48L42.52 69.6C39.48 74.56 36.6 79.6 33.88 84.72Z" fill="#14AE5C"/>
</svg>
''',
          width: 101,
          height: 94,
        ),
        const SizedBox(height: 32),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: 'SIDE',
                style: AppTypography.logoItalic,
              ),
              TextSpan(
                text: 'KICK',
                style: AppTypography.logo,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Remember everything',
          style: AppTypography.subtitle,
        ),
      ],
    );
  }
}
