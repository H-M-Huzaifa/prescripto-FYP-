import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProcessingScreen extends StatefulWidget {
  final File imageFile;

  ProcessingScreen({required this.imageFile});

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
    )..repeat(reverse: true);

    _analyzeImageWithAzure(); // No artificial delay
  }

  Future<void> _analyzeImageWithAzure() async {
    final String endpoint =
        'https://prescripto1-1.cognitiveservices.azure.com/';
    final String subscriptionKey =
        'FYouxBH18D57ufZzRASPSLXjSLRtnysBG6RoCTWb8U2h4opOxnTPJQQJ99BFACGhslBXJ3w3AAAFACOGe7Un';
    final String url = '${endpoint}vision/v3.2/read/analyze';

    try {
      final imageBytes = await widget.imageFile.readAsBytes();

      // Step 1: Send Image
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Ocp-Apim-Subscription-Key': subscriptionKey,
          'Content-Type': 'application/octet-stream',
        },
        body: imageBytes,
      );

      if (response.statusCode != 202) {
        print('Failed to initiate OCR');
        return;
      }

      final operationLocation = response.headers['operation-location'];
      if (operationLocation == null) {
        print('Operation location not found');
        return;
      }

      // Step 2: Poll for result
      while (true) {
        final pollResponse = await http.get(
          Uri.parse(operationLocation),
          headers: {
            'Ocp-Apim-Subscription-Key': subscriptionKey,
          },
        );

        final Map<String, dynamic> pollResult = json.decode(pollResponse.body);
        final status = pollResult['status'];

        if (status == 'succeeded') {
          final lines = pollResult['analyzeResult']['readResults'][0]['lines'];
          List<String> extractedText =
          lines.map<String>((line) => line['text']).toList();

          // Navigate to result screen
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => ResultScreen(textLines: extractedText),
            ),
          );
          break;
        } else if (status == 'failed') {
          print('OCR failed');
          break;
        }

        await Future.delayed(Duration(seconds: 1)); // Poll every 1 second
      }
    } catch (e) {
      print('Error during OCR: $e');
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _screenHeight = MediaQuery.of(context).size.height;

    _animation = Tween<double>(
      begin: -_screenHeight * 0.4,
      end: _screenHeight * 0.4,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
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
            const Padding(
              padding: EdgeInsets.only(top: 50),
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
                    Image.file(
                      widget.imageFile,
                      fit: BoxFit.contain,
                    ),
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
                children: const [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text(
                    "Reading prescription...",
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

class ResultScreen extends StatelessWidget {
  final List<String> textLines;

  ResultScreen({required this.textLines});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(title: const Text("Extracted Text")),
      body: textLines.isEmpty
          ? const Center(child: Text("No text found."))
          : ListView.builder(
        itemCount: textLines.length,
        itemBuilder: (context, index) => ListTile(
          leading: Icon(Icons.text_snippet),
          title: Text(textLines[index]),
        ),
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'dart:async';
// import 'dart:io';
//
// import '../results_screen/prescriptions_results_screen.dart';
//
// // You will create this next
//
//
// class ProcessingScreen extends StatefulWidget {
//   final File imageFile;
//
//   ProcessingScreen({required this.imageFile});
//
//   @override
//   _ProcessingScreenState createState() => _ProcessingScreenState();
// }
//
// class _ProcessingScreenState extends State<ProcessingScreen>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _animation;
//   late double _screenHeight;
//
//   @override
//   void initState() {
//     super.initState();
//
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 3),
//     )..repeat(reverse: true);
//
//     // Simulate API processing
//     Future.delayed(Duration(seconds: 5), () {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (_) => PrescriptionResultScreen(
//             imageFile: widget.imageFile,
//             extractedMedicines: [
//               'Paracetamol 500mg',
//               'Azithromycin 250mg',
//               'Ibuprofen 200mg',
//               'Omeprazole 20mg',
//               'Cetirizine 10mg',
//             ],
//           ),
//         ),
//       );
//     });
//   }
//
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     _screenHeight = MediaQuery.of(context).size.height;
//
//     _animation = Tween<double>(
//       begin: -_screenHeight * 0.4,
//       end: _screenHeight * 0.4,
//     ).animate(CurvedAnimation(
//       parent: _controller,
//       curve: Curves.easeInOut,
//     ));
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[900],
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Padding(
//               padding: EdgeInsets.only(top: 50),
//               child: Text(
//                 "Processing...",
//                 style: TextStyle(
//                     fontFamily: 'Bebas',
//                     fontSize: 30,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white),
//               ),
//             ),
//             Expanded(
//               child: Container(
//                 width: MediaQuery.of(context).size.width * 0.8,
//                 height: _screenHeight * 0.4,
//                 child: Stack(
//                   alignment: Alignment.center,
//                   children: [
//                     Image.file(
//                       widget.imageFile,
//                       fit: BoxFit.contain,
//                     ),
//                     Positioned.fill(
//                       child: AnimatedBuilder(
//                         animation: _animation,
//                         builder: (context, child) {
//                           return Transform.translate(
//                             offset: Offset(0, _animation.value),
//                             child: Container(
//                               width: MediaQuery.of(context).size.width * 0.8,
//                               height: _screenHeight * 0.2,
//                               decoration: BoxDecoration(
//                                 gradient: LinearGradient(
//                                   begin: Alignment.topCenter,
//                                   end: Alignment.bottomCenter,
//                                   colors: [
//                                     Colors.transparent,
//                                     Colors.greenAccent.withOpacity(0.3),
//                                     Colors.greenAccent.withOpacity(0.6),
//                                     Colors.greenAccent.withOpacity(0.3),
//                                     Colors.transparent,
//                                   ],
//                                   stops: [0.0, 0.2, 0.5, 0.8, 1.0],
//                                 ),
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(bottom: 30),
//               child: Column(
//                 children: const [
//                   CircularProgressIndicator(),
//                   SizedBox(height: 20),
//                   Text(
//                     "Processing your prescription...",
//                     style: TextStyle(
//                       fontFamily: 'Bebas',
//                       fontSize: 20,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }


// import 'package:flutter/material.dart';
// import 'dart:io';
//
// class ProcessingScreen extends StatefulWidget {
//   final File imageFile; // Accept the image file
//
//   ProcessingScreen({required this.imageFile}); // Pass image in the constructor
//
//   @override
//   _ProcessingScreenState createState() => _ProcessingScreenState();
// }
//
// class _ProcessingScreenState extends State<ProcessingScreen>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _animation;
//   late double _screenHeight;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(seconds: 3),
//     )..repeat(reverse: true); // Continuous animation, reversing for smoother effect
//   }
//
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     // Now, safely access the screen height here
//     _screenHeight = MediaQuery.of(context).size.height;
//
//     // Initialize the animation range based on screen height
//     _animation = Tween<double>(
//       begin: -_screenHeight * 0.4,
//       end: _screenHeight * 0.4,
//     ).animate(CurvedAnimation(
//       parent: _controller,
//       curve: Curves.easeInOut, // Smooth continuous scanning
//     ));
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[900],
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(top: 50),
//               child: Text(
//                 "Processing...",
//                 style: TextStyle(
//                     fontFamily: 'Bebas',
//                     fontSize: 30,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white),
//               ),
//             ),
//             Expanded(
//               child: Container(
//                 width: MediaQuery.of(context).size.width * 0.8,
//                 height: _screenHeight * 0.4,
//                 child: Stack(
//                   alignment: Alignment.center,
//                   children: [
//                     // Display the image taken from the user
//                     Image.file(
//                       widget.imageFile, // Display the user-selected image
//                       fit: BoxFit.contain,
//                     ),
//                     // Scanning effect
//                     Positioned.fill(
//                       child: AnimatedBuilder(
//                         animation: _animation,
//                         builder: (context, child) {
//                           return Transform.translate(
//                             offset: Offset(0, _animation.value),
//                             child: Container(
//                               width: MediaQuery.of(context).size.width * 0.8,
//                               height: _screenHeight * 0.2,
//                               decoration: BoxDecoration(
//                                 gradient: LinearGradient(
//                                   begin: Alignment.topCenter,
//                                   end: Alignment.bottomCenter,
//                                   colors: [
//                                     Colors.transparent,
//                                     Colors.greenAccent.withOpacity(0.3),
//                                     Colors.greenAccent.withOpacity(0.6),
//                                     Colors.greenAccent.withOpacity(0.3),
//                                     Colors.transparent,
//                                   ],
//                                   stops: [0.0, 0.2, 0.5, 0.8, 1.0],
//                                 ),
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(bottom: 30),
//               child: Column(
//                 children: [
//                   CircularProgressIndicator(),
//                   SizedBox(height: 20),
//                   Text(
//                     "Processing your prescription...",
//                     style: TextStyle(
//                       fontFamily: 'Bebas',
//                       fontSize: 20,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
