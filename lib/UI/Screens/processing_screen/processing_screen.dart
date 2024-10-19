import 'package:flutter/material.dart';
import 'dart:io';

class ProcessingScreen extends StatefulWidget {
  final File imageFile; // Accept the image file

  ProcessingScreen({required this.imageFile}); // Pass image in the constructor

  @override
  _ProcessingScreenState createState() => _ProcessingScreenState();
}

class _ProcessingScreenState extends State<ProcessingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late double _screenHeight;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true); // Continuous animation, reversing for smoother effect
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Now, safely access the screen height here
    _screenHeight = MediaQuery.of(context).size.height;

    // Initialize the animation range based on screen height
    _animation = Tween<double>(
      begin: -_screenHeight * 0.4,
      end: _screenHeight * 0.4,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut, // Smooth continuous scanning
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 50),
              child: Text(
                "Processing...",
                style: TextStyle(
                    fontFamily: 'Bebas',
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: _screenHeight * 0.4,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Display the image taken from the user
                    Image.file(
                      widget.imageFile, // Display the user-selected image
                      fit: BoxFit.contain,
                    ),
                    // Scanning effect
                    Positioned.fill(
                      child: AnimatedBuilder(
                        animation: _animation,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0, _animation.value),
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.8,
                              height: _screenHeight * 0.2,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.greenAccent.withOpacity(0.3),
                                    Colors.greenAccent.withOpacity(0.6),
                                    Colors.greenAccent.withOpacity(0.3),
                                    Colors.transparent,
                                  ],
                                  stops: [0.0, 0.2, 0.5, 0.8, 1.0],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Column(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text(
                    "Processing your prescription...",
                    style: TextStyle(
                      fontFamily: 'Bebas',
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
