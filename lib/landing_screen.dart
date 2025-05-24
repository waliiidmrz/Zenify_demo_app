import 'package:flutter/material.dart';
import 'package:zenify_chat/matrix/matrix_client_service.dart';
import 'package:zenify_chat/zenify_chat_entry.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final unreadCount = MatrixClientService().notificationService.unreadCount;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Welcome to Zenify"),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.message),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ZenifyChatEntry(),
                    ),
                  );
                },
              ),
              ValueListenableBuilder<int>(
                valueListenable: unreadCount,
                builder: (context, count, _) {
                  if (count == 0) return const SizedBox.shrink();
                  return Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints:
                          const BoxConstraints(minWidth: 16, minHeight: 16),
                      child: Text(
                        '$count',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                },
              ),
            ],
          )
        ],
      ),
      body: const Center(
        child: Text(
          'Landing Page Content',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
