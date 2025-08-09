import 'package:flutter/material.dart';
import 'package:cyber_sheild/permissons_page.dart';

class StartingPage extends StatelessWidget {
  const StartingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0F12),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1A1C20),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF00CFFF).withOpacity(0.5),
                  blurRadius: 25,
                  spreadRadius: 1,
                ),
              ],
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.shield, size: 60, color: Color(0xFF00CFFF)),
                const SizedBox(height: 10),
                const Text(
                  "CyberShield",
                  style: TextStyle(
                    fontSize: 24,
                    color: Color(0xFF00CFFF),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  "Fraud Call Detection & Protection",
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 20),
                buildText(
                  Icons.security,
                  "Real-time fraud detection",
                  const Color(0xFF00CFFF),
                ),
                buildText(
                  Icons.warning_amber,
                  "Instant security alerts",
                  const Color(0xFFFF3B3B),
                ),
                buildText(
                  Icons.call,
                  "Call monitoring protection",
                  const Color(0xFF00D47E),
                ),
                const SizedBox(height: 30),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00CFFF),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 10,
                  ),
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) =>  PermissonsPage(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.lock_outline),
                  label: const Text("Sign in with Google"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildText(IconData icon, String text, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: const TextStyle(color: Colors.white))),
        ],
      ),
    );
  }
}
