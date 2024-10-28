import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChatTitleBar extends StatelessWidget {
  final String? userSecret;
  final VoidCallback? onCopy;

  const ChatTitleBar({
    super.key,
    this.userSecret,
    this.onCopy,
  });

  Future<void> _copyToClipboard(BuildContext context) async {
    if (userSecret != null) {
      await Clipboard.setData(ClipboardData(text: userSecret!));
      if (onCopy != null) onCopy!();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User secret copied to clipboard'),
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Text(
            'User Secret:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              userSecret ?? 'Not available',
              style: TextStyle(
                color: Colors.grey[600],
                fontFamily: 'monospace',
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (userSecret != null)
            IconButton(
              icon: const Icon(Icons.copy, size: 20),
              onPressed: () => _copyToClipboard(context),
              tooltip: 'Copy user secret',
              splashRadius: 20,
            ),
        ],
      ),
    );
  }
}
