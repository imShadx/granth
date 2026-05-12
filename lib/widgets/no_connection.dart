import 'package:flutter/material.dart';

class NoConnectionWidget extends StatelessWidget {
  final VoidCallback onRetry;
  const NoConnectionWidget({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Colors.black,
                border: Border(
                  top: BorderSide(color: Colors.black, width: 3),
                  bottom: BorderSide(color: Colors.black, width: 3),
                  left: BorderSide(color: Colors.black, width: 3),
                  right: BorderSide(color: Colors.black, width: 3),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFFFF3F00),
                    offset: Offset(6, 6),
                    blurRadius: 0,
                  ),
                ],
              ),
              child: const Icon(Icons.wifi_off, size: 48, color: Color(0xFFFF3F00)),
            ),
            const SizedBox(height: 24),
            const Text(
              'NO CONNECTION.',
              style: TextStyle(
                fontFamily: 'JimNightshade',
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'check your internet and try again.',
              style: TextStyle(
                fontSize: 13,
                color: Colors.black45,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: onRetry,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: const BoxDecoration(
                  color: Color(0xFFF5F0E8),
                  border: Border(
                    top: BorderSide(color: Colors.black, width: 2),
                    bottom: BorderSide(color: Colors.black, width: 2),
                    left: BorderSide(color: Colors.black, width: 2),
                    right: BorderSide(color: Colors.black, width: 2),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      offset: Offset(4, 4),
                      blurRadius: 0,
                    ),
                  ],
                ),
                child: const Text(
                  'RETRY →',
                  style: TextStyle(
                    fontFamily: 'JimNightshade',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}