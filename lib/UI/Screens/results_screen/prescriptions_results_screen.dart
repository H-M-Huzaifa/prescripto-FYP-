import 'package:flutter/material.dart';
import 'dart:io';

class PrescriptionResultScreen extends StatelessWidget {
  final File imageFile;
  final List<String> extractedMedicines;

  const PrescriptionResultScreen({
    required this.imageFile,
    required this.extractedMedicines,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Prescription Result"),
        backgroundColor: Colors.green[700],
      ),
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Image.file(
              imageFile,
              height: 200,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 20),
            const Text(
              "Extracted Medicines:",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            ...extractedMedicines.map(
                  (medicine) => Card(
                child: ListTile(
                  title: Text(medicine),
                  leading: const Icon(Icons.medical_services),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
