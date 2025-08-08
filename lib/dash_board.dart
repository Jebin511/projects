import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

class Dash_board extends StatefulWidget {
  const Dash_board({super.key});

  @override
  State<Dash_board> createState() => _Dash_boardState();
}

class _Dash_boardState extends State<Dash_board> {
  bool isProtected = false;
  bool isRecording = false;
  String? recordedFilePath;

  static const platform = MethodChannel('com.yourapp.protection');

  @override
  void initState() {
    super.initState();
    requestPermissions();
  }

  Future<void> requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.phone,
      Permission.microphone,
      Permission.audio,
    ].request();

    if (statuses[Permission.phone]!.isDenied ||
        statuses[Permission.microphone]!.isDenied) {
      debugPrint("❌ Permissions not granted");
    } else {
      debugPrint("✅ All required permissions granted");
    }
  }

  Future<void> startProtectionService() async {
    try {
      final result = await platform.invokeMethod('startMonitoring');

      if (result != null && result is String) {
        setState(() {
          isRecording = true;
          recordedFilePath = result;
        });
        debugPrint("🎙️ Recording started at: $recordedFilePath");
      } else {
        debugPrint("⚠️ Unexpected result from native: $result");
      }
    } on PlatformException catch (e) {
      debugPrint("🚨 Error: ${e.message}");
    }
  }

  void toggleProtection() {
    setState(() {
      isProtected = !isProtected;
    });

    if (isProtected) {
      startProtectionService();
    } else {
      setState(() {
        isRecording = false;
        recordedFilePath = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          isProtected ? 'Protection Active' : 'Not Protected',
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                isProtected
                    ? 'Monitoring incoming calls for fraud detection'
                    : 'Start monitoring to activate protection',
                style: const TextStyle(color: Colors.white70),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF161B22),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.shield,
                      color: isProtected ? Colors.green : Colors.grey,
                      size: 64,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      isProtected ? 'Protected' : 'Not Protected',
                      style: TextStyle(
                        color: isProtected ? Colors.green : Colors.redAccent,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (isRecording) const RecordingIndicator(),
                    if (isRecording && recordedFilePath != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          'Saved to:\n$recordedFilePath',
                          style: const TextStyle(
                            color: Colors.white38,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    Text(
                      isProtected
                          ? 'Monitoring active • Safe to receive calls'
                          : 'Monitoring is currently inactive',
                      style: const TextStyle(color: Colors.white70),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: toggleProtection,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            isProtected ? Colors.red : Colors.green,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        isProtected ? 'Stop Protection' : 'Start Protection',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  InfoCard(label: 'Calls Blocked', value: '123'),
                  InfoCard(label: 'Threats Detected', value: '3'),
                ],
              ),
              const SizedBox(height: 24),
              const FeatureTile(
                icon: Icons.call,
                title: 'Call Monitoring',
                subtitle: 'Real-time analysis of incoming calls',
              ),
              const FeatureTile(
                icon: Icons.warning,
                title: 'Fraud Database',
                subtitle: 'Updated threat intelligence',
              ),
              const FeatureTile(
                icon: Icons.shield_outlined,
                title: 'Emergency Alerts',
                subtitle: 'Instant notifications for threats',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final String label;
  final String value;

  const InfoCard({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF161B22),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                color: Colors.cyanAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(label, style: const TextStyle(color: Colors.white70)),
          ],
        ),
      ),
    );
  }
}

class FeatureTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const FeatureTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF161B22),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.cyanAccent),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(subtitle, style: const TextStyle(color: Colors.white70)),
              ],
            ),
          ),
          const Icon(Icons.circle, color: Colors.green, size: 14),
        ],
      ),
    );
  }
}

class RecordingIndicator extends StatefulWidget {
  const RecordingIndicator({super.key});

  @override
  State<RecordingIndicator> createState() => _RecordingIndicatorState();
}

class _RecordingIndicatorState extends State<RecordingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 12),
      child: FadeTransition(
        opacity: _controller,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.fiber_manual_record, color: Colors.red, size: 16),
            SizedBox(width: 6),
            Text(
              'Recording...',
              style: TextStyle(color: Colors.redAccent),
            ),
          ],
        ),
      ),
    );
  }
}