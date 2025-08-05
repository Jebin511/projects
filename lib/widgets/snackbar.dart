import 'package:flutter/material.dart';

class TopSnackBar extends StatefulWidget {
  final String title;
  final String subtitle;
 

  const TopSnackBar({
    super.key,
    required this.title,
    required this.subtitle,
  
  });

  @override
  State<TopSnackBar> createState() => _TopSnackBarState();
}

class _TopSnackBarState extends State<TopSnackBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, -1.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: Material(
        elevation: 8,
        borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
        color: const Color(0xFF0F1C2E),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.shield_outlined, color: Colors.lightBlue, size: 40),
              const SizedBox(height: 8),
              Text(
                widget.title,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20),
              ),
              const SizedBox(height: 4),
              Text(
                widget.subtitle,
                style: const TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 12),
             
            ],
          ),
        ),
      ),
    );
  }
  void showTopSnackBar(BuildContext context, TopSnackBar snackBarWidget) {
  final overlay = Overlay.of(context);
  late OverlayEntry overlayEntry;

  overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: MediaQuery.of(context).padding.top + 10,
      left: 0,
      right: 0,
      child: snackBarWidget,
    ),
  );

  // Insert the snackBar
  overlay.insert(overlayEntry);

  // Remove it after a delay
  Future.delayed(const Duration(seconds: 3)).then((_) {
    overlayEntry.remove();
  });
}
}