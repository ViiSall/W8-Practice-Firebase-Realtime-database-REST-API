import 'package:flutter/material.dart';

class Error extends StatelessWidget {
  const Error({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error, size: 50, color: Colors.orange),
          const SizedBox(height: 20),
          const Text('No data - Tap to refresh'),
        ],
      ),
    );
  }
}