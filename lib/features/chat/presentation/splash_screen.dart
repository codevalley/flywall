// lib/features/chat/presentation/splash_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/app_logo.dart';
import '../../../core/widgets/buttons.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  final _nameController = TextEditingController();
  final _secretController = TextEditingController();
  bool _isRestore = false;

  @override
  void dispose() {
    _nameController.dispose();
    _secretController.dispose();
    super.dispose();
  }

  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppColors.yellow,
          border: Border.all(color: AppColors.white, width: 1),
        ),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _isRestore ? 'Enter your secret' : "What's your name?",
                  style: AppTypography.inputLabel,
                ),
                const SizedBox(height: 24),
                TextField(
                  controller: _isRestore ? _secretController : _nameController,
                  style: AppTypography.input,
                  decoration: InputDecoration(
                    hintText: _isRestore ? 'Secret' : 'Enter your name',
                    hintStyle: AppTypography.input.copyWith(
                      color: AppColors.black.withOpacity(0.3),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                BottomRowButton(
                  text: _isRestore ? 'Restore account' : 'Setup my account',
                  color: AppColors.black,
                  onPressed: () {
                    // Handle authentication
                  },
                  showDivider: false,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: SafeArea(
        child: Column(
          children: [
            const Expanded(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32),
                  child: AppLogo(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Center(
                    child: OutlinedActionButton(
                      text: 'Get started',
                      color: AppColors.green,
                      onPressed: () {
                        setState(() => _isRestore = false);
                        _showBottomSheet();
                      },
                    ),
                  ),
                  const SizedBox(height: 32),
                  BottomRowButton(
                    text: 'Restore',
                    color: AppColors.yellow,
                    onPressed: () {
                      setState(() => _isRestore = true);
                      _showBottomSheet();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
