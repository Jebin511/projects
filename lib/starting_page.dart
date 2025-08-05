import 'package:cyber_sheild/permissons_page.dart';
import 'package:cyber_sheild/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class StartingPage extends StatelessWidget {
  StartingPage({super.key});

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0F12),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
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
                  onPressed: () async {
                    final currentContext = context; // ✅ Capture context safely

                    try {
                      showTopSnackBar(
                        currentContext,
                        const TopSnackBar(
                          title: "Signing in",
                          subtitle: "Connecting to Google authentication",
                        ),
                      );

                      final GoogleSignInAccount? googleUser =
                          await _googleSignIn.signIn();
                      if (googleUser == null) {
                        showTopSnackBar(
                          currentContext,
                          const TopSnackBar(
                            title: "Sign-in canceled",
                            subtitle: "You didn't complete the sign-in",
                          ),
                        );
                        return;
                      }

                      final GoogleSignInAuthentication googleAuth =
                          await googleUser.authentication;

                      final credential = GoogleAuthProvider.credential(
                        accessToken: googleAuth.accessToken,
                        idToken: googleAuth.idToken,
                      );

                      await _auth.signInWithCredential(credential);

                      // ✅ Only navigate if the widget is still in the widget tree
                      if (currentContext.mounted) {
                        Navigator.of(currentContext).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => PermissonsPage(),
                          ),
                        );
                      }
                    } catch (e) {
                      showTopSnackBar(
                        currentContext,
                        TopSnackBar(
                          title: "Sign-in failed",
                          subtitle: e.toString(),
                        ),
                      );
                    }
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
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text, style: const TextStyle(color: Colors.white)),
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
        child: Material(color: Colors.transparent, child: snackBarWidget),
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(const Duration(seconds: 3)).then((_) {
      if (overlayEntry.mounted) overlayEntry.remove();
    });
  }
}
