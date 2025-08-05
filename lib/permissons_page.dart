
import 'package:cyber_sheild/dash_board.dart';
import 'package:cyber_sheild/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissonsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0D111A),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Glowing Shield
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.cyanAccent.withOpacity(0.6),
                        blurRadius: 30,
                        spreadRadius: 10,
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.shield_outlined,
                    size: 60,
                    color: Colors.cyanAccent,
                  ),
                ),
                SizedBox(height: 24),

                // Title
                Text(
                  "Setup Protection",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),

                // Subtitle
                Text(
                  "CyberShield needs access to your device features to provide comprehensive protection.",
                  style: TextStyle(fontSize: 14, color: Colors.grey[400]),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 32),

                // Permission Cards
                _buildPermissionCard(
                  Icons.phone,
                  "Phone Access",
                  "Monitor incoming calls",
                ),
                SizedBox(height: 16),
                _buildPermissionCard(
                  Icons.contacts,
                  "Contacts",
                  "Verify trusted numbers",
                ),
                SizedBox(height: 16),
                _buildPermissionCard(
                  Icons.location_on,
                  "Location",
                  "Regional fraud database",
                ),
                Spacer(),

                // Grant Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF00CFFF),
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                      try {
                        showTopSnackBar(
                          context,
                          TopSnackBar(
                            title: "Permission granted",
                            subtitle: "",
                            
                          ),
                        );

                        await Future.delayed(const Duration(seconds: 1)); // let the snackbar animate in

                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => Dash_board()),
                        );
                      } catch (e) {
                        print("Error: $e");
                      }
                    },
                  child: Text(
                    "Grant Permissions",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPermissionCard(IconData icon, String title, String subtitle) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.cyanAccent.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(12),
        color: Colors.transparent,
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.cyanAccent),
          SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(color: Colors.grey[400], fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> requestPermissions() async {
    // Request each permission one by one
    final phoneStatus = await Permission.phone.request();
    final contactsStatus = await Permission.contacts.request();
    final locationStatus = await Permission.location.request();

    // Check individual permission statuses
    if (phoneStatus.isGranted &&
        contactsStatus.isGranted &&
        locationStatus.isGranted) {
      print("✅ All permissions granted!");
    } else {
      print("❌ Some permissions denied.");
      if (phoneStatus.isPermanentlyDenied) {
        openAppSettings(); // Optional: Show app settings to grant manually
      }
    }
  }
   // make sure this import points to your TopSnackBar file

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
