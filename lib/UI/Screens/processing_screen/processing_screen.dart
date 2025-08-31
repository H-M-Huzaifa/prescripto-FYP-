import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:prescripto/UI/Screens/results_screen/medicine_matcher_provider.dart';
import 'dart:convert';
import 'package:provider/provider.dart';

import '../results_screen/prescriptions_results_screen.dart';

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
  String _statusMessage = "Reading prescription...";

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _analyzeImageWithAzure();
  }

  Future<void> _analyzeImageWithAzure() async {
    final String endpoint = 'https://cvprescripto.cognitiveservices.azure.com/';
    final String subscriptionKey = '8mkpFORyMRYHuRdMyVi5XolYU2E4yz8qpcTmcOlK3Z48JIzVDGmDJQQJ99BHACqBBLyXJ3w3AAAFACOGqve1';
    final String url = '$endpoint/vision/v3.2/read/analyze';

    try {
      setState(() {
        _statusMessage = "Uploading image...";
      });

      final imageBytes = await widget.imageFile.readAsBytes();
      print('Image size: ${imageBytes.length} bytes');

      // Step 1: Send Image
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Ocp-Apim-Subscription-Key': subscriptionKey,
          'Content-Type': 'application/octet-stream',
        },
        body: imageBytes,
      );

      print('Initial response status: ${response.statusCode}');

      if (response.statusCode != 202) {
        _handleError('Failed to initiate OCR. Status: ${response.statusCode}\nResponse: ${response.body}');
        return;
      }

      final operationLocation = response.headers['operation-location'];
      if (operationLocation == null) {
        _handleError('Operation location not found in response headers');
        return;
      }

      setState(() {
        _statusMessage = "Processing image...";
      });

      // Step 2: Poll for result with timeout
      int maxAttempts = 30;
      int attempts = 0;

      while (attempts < maxAttempts) {
        await Future.delayed(Duration(seconds: 1));
        attempts++;

        final pollResponse = await http.get(
          Uri.parse(operationLocation),
          headers: {
            'Ocp-Apim-Subscription-Key': subscriptionKey,
          },
        );

        if (pollResponse.statusCode != 200) {
          _handleError('Failed to poll results. Status: ${pollResponse.statusCode}');
          return;
        }

        final Map<String, dynamic> pollResult = json.decode(pollResponse.body);
        final status = pollResult['status'];

        if (status == 'succeeded') {
          setState(() {
            _statusMessage = "Extracting text...";
          });

          try {
            final analyzeResult = pollResult['analyzeResult'];
            if (analyzeResult == null) {
              _handleError('No analyze result found');
              return;
            }

            final readResults = analyzeResult['readResults'];
            if (readResults == null || readResults.isEmpty) {
              _handleError('No read results found');
              return;
            }

            final lines = readResults[0]['lines'];
            if (lines == null) {
              _handleError('No lines found in results');
              return;
            }

            List<String> extractedText = [];
            for (var line in lines) {
              if (line['text'] != null) {
                extractedText.add(line['text'].toString());
              }
            }

            print('Extracted text: $extractedText');

            // Navigate to enhanced result screen with provider
            if (mounted) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => ChangeNotifierProvider(
                    create: (context) => MedicineMatcherProvider(),
                    child: ResultScreen(textLines: extractedText),
                  ),
                ),
              );
            }
          } catch (parseError) {
            _handleError('Error parsing results: $parseError');
          }
          break;
        } else if (status == 'failed') {
          _handleError('OCR processing failed');
          break;
        } else if (status == 'running') {
          setState(() {
            _statusMessage = "Processing... ($attempts/30)";
          });
        }
      }

      if (attempts >= maxAttempts) {
        _handleError('OCR processing timed out');
      }

    } catch (e) {
      print('Error during OCR: $e');
      _handleError('Error during OCR: $e');
    }
  }

  void _handleError(String errorMessage) {
    print('OCR Error: $errorMessage');
    if (mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Processing Error'),
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pop(); // Go back to previous screen
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
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
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text(
                    _statusMessage,
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
