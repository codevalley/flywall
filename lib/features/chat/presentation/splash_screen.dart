// lib/features/chat/presentation/splash_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/theme.dart';
import '../../../core/widgets/app_logo.dart';
import '../../../core/widgets/buttons.dart';
import '../../auth/presentation/providers/auth_provider.dart';
import '../../../core/providers/core_providers.dart';
import 'package:flutter/services.dart';

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
  bool _showWelcome = false;
  String? _enteredValue;
  String? _actualSecret; // Store the actual secret separately
  bool _showTextField = true;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
      _enteredValue = _controller.text.trim();
    });
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

  String _formatSecretText(String text) {
    if (text.length <= 6) return text;
    return '${text.substring(0, 3)}•••${text.substring(text.length - 3)}';
  }

  Future<void> _pasteFromClipboard() async {
    final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    if (clipboardData?.text != null) {
      setState(() {
        _actualSecret = clipboardData!.text!.trim(); // Store actual secret
        _controller.text =
            _formatSecretText(_actualSecret!); // Show formatted version
        _enteredValue = _actualSecret; // Use this for authentication
      });
    }
  }

  Future<void> _handleAuth() async {
    if (_isLoading) return;

    final value = widget.isRestore ? _actualSecret : _controller.text;
    if (value?.isEmpty ?? true) {
      _showError(widget.isRestore
          ? 'Please enter your secret'
          : 'Please enter your name');
      return;
    }

    setState(() {
      _isLoading = true;
      _showWelcome = true;
      _showTextField = false;
      _enteredValue = value;
    });

    try {
      if (widget.isRestore) {
        await ref.read(authProvider.notifier).checkAuth(value);
      } else {
        await ref.read(authProvider.notifier).registerAndLogin(value!);
      }
    } catch (e) {
      if (mounted) {
        _showError(e.toString());
        setState(() {
          _isLoading = false;
          _showWelcome = false;
          _showTextField = true;
        });
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
            children: [
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AnimatedSlide(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                        offset:
                            _showTextField ? Offset.zero : const Offset(0, 0.2),
                        child: AnimatedCrossFade(
                          duration: const Duration(milliseconds: 300),
                          firstChild: Text(
                            widget.isRestore
                                ? 'Enter your secret'
                                : "What's your name?",
                            style: AppTypography.inputLabel.copyWith(
                              color: AppColors.black,
                            ),
                          ),
                          secondChild: Text(
                            widget.isRestore
                                ? 'Welcome back'
                                : 'Welcome, ${_enteredValue ?? ""}',
                            style: AppTypography.heading2.copyWith(
                              color: AppColors.black,
                            ),
                          ),
                          crossFadeState: _showWelcome
                              ? CrossFadeState.showSecond
                              : CrossFadeState.showFirst,
                        ),
                      ),
                      if (_showTextField) ...[
                        const SizedBox(height: 24),
                        AnimatedOpacity(
                          duration: const Duration(milliseconds: 200),
                          opacity: _showTextField ? 1.0 : 0.0,
                          child: SizedBox(
                            height: 64,
                            child: TextField(
                              controller: _controller,
                              style: AppTypography.input,
                              enabled: !_isLoading,
                              readOnly: widget.isRestore,
                              decoration: InputDecoration(
                                hintText: widget.isRestore
                                    ? 'Tap to paste your secret'
                                    : 'Enter your name',
                                hintStyle: AppTypography.input.copyWith(
                                  color: AppColors.black.withOpacity(0.3),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: AppColors.white.withOpacity(0.1),
                                isCollapsed: true,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                suffixIcon: widget.isRestore
                                    ? IconButton(
                                        icon: const Icon(
                                          Icons.content_paste_rounded,
                                          color: AppColors.black,
                                        ),
                                        onPressed: _isLoading
                                            ? null
                                            : _pasteFromClipboard,
                                      )
                                    : null,
                              ),
                              onTap:
                                  widget.isRestore ? _pasteFromClipboard : null,
                              onSubmitted: (_) => _handleAuth(),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              BottomRowButton(
                text: _isLoading
                    ? (widget.isRestore ? 'Restoring...' : 'Getting ready...')
                    : (widget.isRestore
                        ? 'Restore account'
                        : 'Setup my account'),
                color: AppColors.white,
                onPressed: _isLoading ? null : _handleAuth,
                showDivider: true,
                showSpinner: _isLoading,
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
  bool _isBottomSheetVisible = false;

  @override
  void initState() {
    super.initState();
    _checkExistingSession();
  }

  Future<void> _checkExistingSession() async {
    try {
      final storage = ref.read(sessionStorageProvider);
      final sessionManager = ref.read(sessionManagerProvider);

      // First quickly check if we have a username stored
      final userName = await storage.getUserName();
      if (mounted) {
        setState(() {
          _userName = userName;
          _isChecking =
              storage.hasSession(); // Only show loading if we have a session
        });
      }

      // Then attempt to restore the session if we have one
      if (storage.hasSession()) {
        final hasSession = await sessionManager.restoreSession();

        if (mounted) {
          setState(() {
            _hasSession = hasSession;
            _isChecking = false;
          });

          if (hasSession && sessionManager.currentUser != null) {
            ref.read(authProvider.notifier).setAuthenticated(
                  sessionManager.currentUser!,
                );
          }
        }
      } else {
        if (mounted) {
          setState(() {
            _isChecking = false;
            _hasSession = false;
          });
        }
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
    setState(() => _isBottomSheetVisible = true);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: !isRestore,
      builder: (context) => AuthBottomSheet(isRestore: isRestore),
    ).whenComplete(() {
      if (mounted) {
        setState(() => _isBottomSheetVisible = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isChecking || _hasSession) {
      return _buildLoadingScreen();
    }

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
            // Animate the Get Started button
            AnimatedSlide(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              offset: _isBottomSheetVisible ? const Offset(0, 1) : Offset.zero,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: _isBottomSheetVisible ? 0.0 : 1.0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: OutlinedActionButton(
                    text: 'Get started',
                    color: AppColors.green,
                    onPressed: () => _showBottomSheet(false),
                  ),
                ),
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
