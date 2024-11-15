import 'package:flutter/material.dart';
import '../../../core/theme/theme.dart';

class SuggestionBubbles extends StatefulWidget {
  final List<String> suggestions;
  final Function(String) onSuggestionTap;
  final bool visible;

  const SuggestionBubbles({
    super.key,
    required this.suggestions,
    required this.onSuggestionTap,
    this.visible = true,
  });

  @override
  State<SuggestionBubbles> createState() => _SuggestionBubblesState();
}

class _SuggestionBubblesState extends State<SuggestionBubbles>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _initializeAnimations();

    if (widget.visible) {
      _controller.forward();
    }
  }

  void _initializeAnimations() {
    // Create staggered animations for each bubble
    final staggerInterval = 0.4 / widget.suggestions.length; // Distribute over 0.4 of total duration
    _animations = List.generate(
      widget.suggestions.length,
      (index) => Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            index * staggerInterval, // Start time for this bubble
            (index * staggerInterval) + 0.6, // End time (0.6 duration for each)
            curve: Curves.easeOutBack,
          ),
        ),
      ),
    );
  }

  @override
  void didUpdateWidget(SuggestionBubbles oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Reinitialize animations if the number of suggestions changes
    if (widget.suggestions.length != oldWidget.suggestions.length) {
      _initializeAnimations();
    }
    
    // Handle visibility changes
    if (widget.visible != oldWidget.visible) {
      if (widget.visible) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.visible && _controller.isDismissed) {
      return const SizedBox.shrink();
    }

    return AnimatedOpacity(
      opacity: widget.visible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 200),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        alignment: WrapAlignment.center,
        children: List.generate(
          widget.suggestions.length,
          (index) => ScaleTransition(
            scale: _animations[index],
            child: _SuggestionBubble(
              suggestion: widget.suggestions[index],
              onTap: () => widget.onSuggestionTap(widget.suggestions[index]),
            ),
          ),
        ),
      ),
    );
  }
}

class _SuggestionBubble extends StatelessWidget {
  final String suggestion;
  final VoidCallback onTap;

  const _SuggestionBubble({
    required this.suggestion,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.black.withOpacity(0.5),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.yellow.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Text(
            suggestion,
            style: AppTypography.body.copyWith(
              color: AppColors.yellow,
            ),
          ),
        ),
      ),
    );
  }
}
