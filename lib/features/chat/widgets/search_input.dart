import 'package:flutter/material.dart';
import '../../../core/theme/theme.dart';

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

class _SearchInputState extends State<SearchInput> {
  final TextEditingController _controller = TextEditingController();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_updateHasText);
  }

  @override
  void dispose() {
    _controller.removeListener(_updateHasText);
    _controller.dispose();
    super.dispose();
  }

  void _updateHasText() {
    setState(() {
      _hasText = _controller.text.trim().isNotEmpty;
    });
  }

  void _handleSubmit(String value) {
    if (value.trim().isNotEmpty && widget.enabled) {
      widget.onSubmitted(value);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Divider with padding
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Container(
            height: 1,
            color: AppColors.white,
          ),
        ),
        // Input row with no extra container
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
                  onSubmitted: _handleSubmit,
                  maxLines: null,
                ),
              ),
              Transform.rotate(
                angle: -45 * 3.14 / 180,
                child: Icon(
                  Icons.arrow_forward,
                  color: _hasText && widget.enabled
                      ? AppColors.white
                      : AppColors.textDisabled,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
