import 'package:flutter/material.dart';
import '../../../core/theme/theme.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/widgets/app_logo.dart';

class SearchInput extends StatefulWidget {
  final Function(String) onSubmitted;
  final bool enabled;
  final bool isThreadActive;

  const SearchInput({
    super.key,
    required this.onSubmitted,
    this.enabled = true,
    this.isThreadActive = false,
  });

  @override
  State<SearchInput> createState() => _SearchInputState();
}

class _SearchInputState extends State<SearchInput>
    with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  bool _hasText = false;
  late final AnimationController _spinController;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_updateHasText);
    _spinController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.removeListener(_updateHasText);
    _controller.dispose();
    _spinController.dispose();
    super.dispose();
  }

  void _updateHasText() {
    setState(() {
      _hasText = _controller.text.trim().isNotEmpty;
    });
  }

  void _handleSubmit() {
    final text = _controller.text.trim();
    if (text.isNotEmpty && widget.enabled) {
      widget.onSubmitted(text);
      _controller.clear();
      _updateHasText();
    }
  }

  Widget _buildSpinningLogo() {
    return AnimatedBuilder(
      animation: _spinController,
      builder: (context, child) {
        return Transform.rotate(
          angle: _spinController.value * 4 * 3.14159,
          child: SvgPicture.string(
            logoSvg,
            width: 20,
            height: 20,
            color: AppColors.white,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Container(
            height: 1,
            color: AppColors.white,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  enabled: widget.enabled,
                  style: AppTypography.inputAction.copyWith(
                    color: AppColors.white,
                  ),
                  decoration: InputDecoration(
                    hintText:
                        widget.enabled ? 'Ask anything...' : 'Please wait...',
                    hintStyle: AppTypography.inputAction.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    fillColor: Colors.transparent,
                    filled: false,
                    contentPadding: const EdgeInsets.symmetric(vertical: 18),
                  ),
                  onSubmitted: (_) => _handleSubmit(),
                  maxLines: null,
                ),
              ),
              if (!widget.enabled)
                _buildSpinningLogo()
              else
                GestureDetector(
                  onTap: _hasText ? _handleSubmit : null,
                  child: Transform.rotate(
                    angle: -45 * 3.14 / 180,
                    child: Icon(
                      Icons.arrow_forward,
                      color:
                          _hasText ? AppColors.white : AppColors.textDisabled,
                      size: 20,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
