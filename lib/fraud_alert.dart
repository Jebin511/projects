import 'package:flutter/material.dart';

class FraudAlertScreen extends StatelessWidget {
  const FraudAlertScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: SafeArea(
        child: Column(
          children: [
            

            const Spacer(),

            // ⚠️ Alert card
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(36),
              decoration: BoxDecoration(
                color: const Color(0xFF0D1117),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.warning_amber, color: Colors.red, size: 56),
                  const SizedBox(height: 12),
                  const Text(
                    '⚠️ FRAUD ALERT',
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'This number is reported as a fraud source.\nProceed with caution.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 24),

                  // Block Call button
                  ElevatedButton(
                    onPressed: () {
                      // Handle block call
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Block Call',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Dismiss button
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.white24),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Dismiss',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}