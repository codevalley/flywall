import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  final Function(String) onSubmitted;

  const SearchBar({
    super.key,
    required this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Ask anything...',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        filled: true,
        fillColor: Colors.grey[200],
        suffixIcon: const Icon(Icons.send),
      ),
      onSubmitted: onSubmitted,
    );
  }
}
