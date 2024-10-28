import 'package:flutter/material.dart';

class SearchInput extends StatefulWidget {
  final Function(String) onSubmitted;
  final bool enabled;
  final bool isThreadActive;
  final String? userName;

  const SearchInput({
    super.key,
    required this.onSubmitted,
    this.enabled = true,
    this.isThreadActive = false,
    this.userName,
  });

  @override
  State<SearchInput> createState() => _SearchInputState();
}

class _SearchInputState extends State<SearchInput>
    with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  bool _hasText = false;
  late final AnimationController _animationController;
  late final Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_updateHasText);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _slideAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void didUpdateWidget(SearchInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isThreadActive != oldWidget.isThreadActive) {
      if (widget.isThreadActive) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_updateHasText);
    _controller.dispose();
    _animationController.dispose();
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
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header section with animated opacity and slide
            if (!widget.isThreadActive)
              Transform.translate(
                offset: Offset(0, -50 * _slideAnimation.value),
                child: Opacity(
                  opacity: 1 - _animationController.value,
                  child: Column(
                    children: [
                      const SizedBox(height: 80),
                      ShaderMask(
                        shaderCallback: (bounds) => const LinearGradient(
                          colors: [Colors.blue, Colors.purple],
                        ).createShader(bounds),
                        child: const Text(
                          'Flywall',
                          style: TextStyle(
                            fontSize: 64,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      if (widget.userName != null) ...[
                        const SizedBox(height: 24),
                        Text(
                          'Hello, ${widget.userName}',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                      const SizedBox(height: 48),
                    ],
                  ),
                ),
              ),
            // Search input section
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: widget.isThreadActive ? 16 : 32,
                vertical: 16,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      enabled: widget.enabled,
                      decoration: InputDecoration(
                        hintText: widget.enabled
                            ? 'Ask anything...'
                            : 'Please wait...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor:
                            widget.enabled ? Colors.white : Colors.grey[100],
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                      ),
                      onSubmitted: _handleSubmit,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: _hasText && widget.enabled
                        ? () => _handleSubmit(_controller.text)
                        : null,
                    color:
                        _hasText && widget.enabled ? Colors.blue : Colors.grey,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
