import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Dialer',
      debugShowCheckedModeBanner: false,
      home: DialerScreen(),
    );
  }
}

class DialerScreen extends StatefulWidget {
  @override
  _DialerScreenState createState() => _DialerScreenState();
}

class _DialerScreenState extends State<DialerScreen> {
  final TextEditingController _numberController = TextEditingController();
  bool _isMuted = false;
  bool _isSpeakerOn = false;
  bool _isCalling = false;
  String _status = "Idle";

  void _startCall() {
    setState(() {
      _isCalling = true;
      _status = "Calling...";
    });
    // Trigger Twilio call via backend here
  }

  void _endCall() {
    setState(() {
      _isCalling = false;
      _status = "Call Ended";
    });
    // Trigger Twilio hangup here
  }

  void _toggleMute() {
    setState(() => _isMuted = !_isMuted);
    // Twilio mute logic here
  }

  void _toggleSpeaker() {
    setState(() => _isSpeakerOn = !_isSpeakerOn);
    // Twilio speaker toggle logic here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Flutter Dialer",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _numberController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter phone number',
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Status: $_status",
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: _isCalling ? null : _startCall,
                    icon: Icon(Icons.call),
                    label: Text("Call"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: _isCalling ? _endCall : null,
                    icon: Icon(Icons.call_end),
                    label: Text("End"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              if (_isCalling)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      onPressed: _toggleMute,
                      icon: Icon(_isMuted ? Icons.mic_off : Icons.mic),
                    ),
                    IconButton(
                      onPressed: _toggleSpeaker,
                      icon: Icon(_isSpeakerOn ? Icons.volume_up : Icons.hearing),
                    ),
                  ],
                )
            ],
          ),
        ),
      ),
    );
  }
}