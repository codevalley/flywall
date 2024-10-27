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

  @override
  Widget build(BuildContext context) {
    return Container(
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
                hintText: widget.enabled ? 'Ask anything...' : 'Please wait...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: widget.enabled ? Colors.white : Colors.grey[100],
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
                ? () => widget.onSubmitted(_controller.text)
                : null,
            color: _hasText && widget.enabled ? Colors.blue : Colors.grey,
          ),
        ],
      ),
    );
  }

  void _handleSubmit(String value) {
    if (value.trim().isNotEmpty && widget.enabled) {
      widget.onSubmitted(value);
      _controller.clear();
    }
  }
}
