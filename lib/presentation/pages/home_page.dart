import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flywall/presentation/providers/providers.dart';
import 'package:flywall/presentation/widgets/search_bar.dart' as custom_widgets;

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatState = ref.watch(chatProvider);

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: chatState.isLoading
                  ? const CircularProgressIndicator()
                  : chatState.error != null && chatState.error!.isNotEmpty
                      ? Text(
                          'Error: ${chatState.error}',
                          style: const TextStyle(color: Colors.red),
                        )
                      : chatState.response.isEmpty
                          ? const Text('Ask me anything!')
                          : Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Text(
                                chatState.response,
                                style: const TextStyle(
                                  fontFamily: "Graphik",
                                  fontSize: 16,
                                ),
                              ),
                            ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: custom_widgets.SearchBar(
              onSubmitted: (value) {
                ref.read(chatProvider.notifier).sendMessage(value);
              },
            ),
          ),
        ],
      ),
    );
  }
}
