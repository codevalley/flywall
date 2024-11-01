// lib/features/chat/presentation/splash_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/app_logo.dart';
import '../../../core/widgets/buttons.dart';
import '../../auth/presentation/providers/auth_provider.dart';
import '../../../core/providers/core_providers.dart';

// Separate widget for the bottom sheet
class AuthBottomSheet extends ConsumerStatefulWidget {
  final bool isRestore;

  const AuthBottomSheet({
    super.key,
    required this.isRestore,
  });

  @override
  ConsumerState<AuthBottomSheet> createState() => _AuthBottomSheetState();
}

class _AuthBottomSheetState extends ConsumerState<AuthBottomSheet> {
  late final TextEditingController _controller;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _handleAuth() async {
    if (_isLoading) return;

    final value = _controller.text.trim();
    if (value.isEmpty) {
      _showError(widget.isRestore
          ? 'Please enter your secret'
          : 'Please enter your name');
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (widget.isRestore) {
        await ref.read(authProvider.notifier).checkAuth();
      } else {
        await ref.read(authProvider.notifier).registerAndLogin(value);
      }
    } catch (e) {
      if (mounted) {
        _showError(e.toString());
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(
      authProvider,
      (previous, next) {
        if (!mounted) return;

        if (next.status == AuthStatus.authenticated) {
          // Close bottom sheet when authenticated
          Navigator.of(context).pop();
        }

        if (next.status == AuthStatus.error && next.error != null) {
          _showError(next.error!);
        }
      },
    );

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.yellow,
        border: Border(
          top: BorderSide(color: AppColors.white, width: 1),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.isRestore
                          ? 'Enter your secret'
                          : "What's your name?",
                      style: AppTypography.inputLabel.copyWith(
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      controller: _controller,
                      style: AppTypography.input,
                      decoration: InputDecoration(
                        hintText:
                            widget.isRestore ? 'Secret' : 'Enter your name',
                        hintStyle: AppTypography.input.copyWith(
                          color: AppColors.black.withOpacity(0.3),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: AppColors.white.withOpacity(0.1),
                        enabled: !_isLoading,
                      ),
                      onSubmitted: (_) => _handleAuth(),
                    ),
                  ],
                ),
              ),
              BottomRowButton(
                text: _isLoading
                    ? 'Please wait...'
                    : (widget.isRestore
                        ? 'Restore account'
                        : 'Setup my account'),
                color: AppColors.white,
                onPressed: _isLoading ? null : _handleAuth,
                showDivider: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  bool _isChecking = true;
  String? _userName;
  bool _hasSession = false;

  @override
  void initState() {
    super.initState();
    _checkExistingSession();
  }

  Future<void> _checkExistingSession() async {
    try {
      final sessionManager = ref.read(sessionManagerProvider);
      final storage = ref.read(sessionStorageProvider);

      setState(() => _isChecking = true);

      final userName = await storage.getUserName();
      final hasSession = await sessionManager.restoreSession();

      debugPrint(
          'Session check - Username: $userName, HasSession: $hasSession');

      if (mounted) {
        setState(() {
          _userName = userName;
          _hasSession = hasSession;
          _isChecking = false;
        });

        if (hasSession && sessionManager.currentUser != null) {
          ref.read(authProvider.notifier).setAuthenticated(
                sessionManager.currentUser!,
              );
        }

        // Force rebuild if _userName changes
        Future.microtask(() => setState(() {}));
      }
    } catch (e) {
      debugPrint('Error in session check: $e');
      if (mounted) {
        setState(() {
          _isChecking = false;
          _hasSession = false;
        });
        _showError('Error checking session: $e');
      }
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  Widget _buildLoadingScreen() {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 48),
            // Logo Section
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: AppLogo(),
            ),

            const SizedBox(height: 48), // Space between logo and welcome text

            // Welcome back text
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 62),
              child: Text(
                _userName != null ? 'Welcome back, $_userName' : 'Welcome back',
                textAlign: TextAlign.center,
                style: AppTypography.heading1.copyWith(
                  color: AppColors.yellow,
                  fontSize: 36,
                  fontWeight: FontWeight.w700,
                  height: 0,
                ),
              ),
            ),

            const Spacer(), // Push loading indicator to bottom

            // Loading indicator and text
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(AppColors.yellow),
                  strokeWidth: 2,
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 88),
                  child: Text(
                    'loading your profile',
                    textAlign: TextAlign.center,
                    style: AppTypography.subtitle.copyWith(
                      color: AppColors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      height: 0,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 80), // Bottom padding
          ],
        ),
      ),
    );
  }

  void _showBottomSheet(bool isRestore) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: !isRestore,
      builder: (context) => AuthBottomSheet(isRestore: isRestore),
    );
  }

  @override
  Widget build(BuildContext context) {
    // If checking or has valid session, show loading screen
    if (_isChecking || _hasSession) {
      return _buildLoadingScreen();
    }

    // Show normal splash screen
    return Scaffold(
      backgroundColor: AppColors.black,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 48),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: AppLogo(),
            ),
            const Spacer(),
            // Moved Get Started section to middle
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: OutlinedActionButton(
                text: 'Get started',
                color: AppColors.green,
                onPressed: () => _showBottomSheet(false),
              ),
            ),
            const Spacer(),
            // Keep Restore button at bottom
            Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: BottomRowButton(
                text: 'Restore',
                color: AppColors.yellow,
                onPressed: () => _showBottomSheet(true),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
