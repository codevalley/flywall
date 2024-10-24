import 'package:flutter/material.dart';

// chat/widgets/search_input.dart
class SearchInput extends StatefulWidget {
  final Function(String) onSubmitted;
  final bool enabled;

  const SearchInput({
    super.key,
    required this.onSubmitted,
    this.enabled = true,
  });

  @override
  State<SearchInput> createState() => _SearchInputState();
}

class _SearchInputState extends State<SearchInput> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        enabled: widget.enabled,
        decoration: InputDecoration(
          hintText: widget.enabled ? 'Type something...' : 'Please wait...',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: widget.enabled ? Colors.white : Colors.grey[100],
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
          prefixIcon: const Icon(Icons.search),
          suffixIcon: widget.enabled && controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => controller.clear(),
                )
              : null,
        ),
        onSubmitted: (value) {
          if (value.trim().isNotEmpty && widget.enabled) {
            widget.onSubmitted(value);
            controller.clear();
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
