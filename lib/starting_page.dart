
import 'package:cyber_sheild/permissons_page.dart';
import 'package:cyber_sheild/widgets/snackbar.dart';
import 'package:flutter/material.dart';


class StartingPage extends StatelessWidget {
  StartingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0D0F12),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xFF1A1C20),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF00CFFF).withOpacity(0.5),
                  blurRadius: 25,
                  spreadRadius: 1,
                ),
              ],
            ),
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.shield, size: 60, color: Color(0xFF00CFFF)),
                SizedBox(height: 10),
                Text(
                  "CyberShield",
                  style: TextStyle(
                    fontSize: 24,
                    color: Color(0xFF00CFFF),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Fraud Call Detection & Protection",
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(height: 20),
                buildText(
                  Icons.security,
                  "Real-time fraud detection",
                  Color(0xFF00CFFF),
                ),
                buildText(
                  Icons.warning_amber,
                  "Instant security alerts",
                  Color(0xFFFF3B3B),
                ),
                buildText(
                  Icons.call,
                  "Call monitoring protection",
                  Color(0xFF00D47E),
                ),
                SizedBox(height: 30),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF00CFFF),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 10,
                  ),
                  onPressed: () async {
                      try {
                        showTopSnackBar(
                          context,
                          TopSnackBar(
                            title: "Signing in",
                            subtitle: "Connecting to Google authentication",
                            
                          ),
                        );

                        await Future.delayed(const Duration(seconds: 1)); // let the snackbar animate in

                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => PermissonsPage()),
                        );
                      } catch (e) {
                        print("Error: $e");
                      }
                    },
                  icon: Icon(Icons.lock_outline),
                  label: Text("Sign in with Google"),
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
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, color: color),
          SizedBox(width: 10),
          Expanded(
            child: Text(text, style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

void showTopSnackBar(BuildContext context, TopSnackBar snackBarWidget) {
  final overlay = Overlay.of(context);
  late OverlayEntry overlayEntry;

  overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: MediaQuery.of(context).padding.top + 10,
      left: 16,
      right: 16,
      child: Material( // This ensures it's clickable
        color: Colors.transparent,
        child: snackBarWidget,
      ),
    ),
  );

  overlay.insert(overlayEntry);

  // Auto-remove after 3 seconds
  Future.delayed(const Duration(seconds: 3)).then((_) {
    if (overlayEntry.mounted) overlayEntry.remove();
  });
}
}
