import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MedicineMatcherProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Map<String, dynamic>> _availableMedicines = [];
  List<Map<String, dynamic>> _unavailableMedicines = [];
  bool _isLoading = false;

  List<Map<String, dynamic>> get availableMedicines => _availableMedicines;
  List<Map<String, dynamic>> get unavailableMedicines => _unavailableMedicines;
  bool get isLoading => _isLoading;

  // Function to match extracted text with Firebase medicines
  Future<void> matchMedicinesWithInventory(List<String> extractedText) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Fetch all medicines from Firebase
      QuerySnapshot snapshot = await _firestore.collection('medicines').get();
      List<Map<String, dynamic>> allMedicines = snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['docId'] = doc.id; // Add document ID for reference
        return data;
      }).toList();

      // Clean and process extracted text
      List<String> cleanedExtractedText = _cleanExtractedText(extractedText);

      _availableMedicines.clear();
      _unavailableMedicines.clear();

      // Match each extracted medicine with inventory
      for (String extractedMedicine in cleanedExtractedText) {
        if (extractedMedicine.trim().isEmpty) continue;

        Map<String, dynamic>? matchedMedicine = _findBestMatch(extractedMedicine, allMedicines);

        if (matchedMedicine != null) {
          // Add matching confidence score
          matchedMedicine['extractedName'] = extractedMedicine;
          matchedMedicine['matchType'] = _getMatchType(extractedMedicine, matchedMedicine);
          _availableMedicines.add(matchedMedicine);
        } else {
          // Medicine not found in inventory
          _unavailableMedicines.add({
            'name': extractedMedicine,
            'extractedName': extractedMedicine,
            'isAvailable': false,
            'matchType': 'Not Found',
          });
        }
      }

      // Remove duplicates
      _availableMedicines = _removeDuplicates(_availableMedicines);
      _unavailableMedicines = _removeDuplicates(_unavailableMedicines);

    } catch (e) {
      print('Error matching medicines: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Clean extracted text to get better medicine names
  List<String> _cleanExtractedText(List<String> extractedText) {
    List<String> cleanedText = [];

    for (String text in extractedText) {
      // Remove common prescription words and symbols
      String cleaned = text
          .replaceAll(RegExp(r'\b(tab|tablet|tablets|cap|capsule|capsules|mg|ml|gm|syrup|injection|inj)\b', caseSensitive: false), '')
          .replaceAll(RegExp(r'[0-9]+'), '') // Remove numbers
          .replaceAll(RegExp(r'[^\w\s]'), '') // Remove special characters
          .trim();

      // Split by common separators and process each part
      List<String> parts = cleaned.split(RegExp(r'[\s,.-]+'));

      for (String part in parts) {
        String trimmedPart = part.trim();
        if (trimmedPart.length >= 3) { // Only consider words with 3+ characters
          cleanedText.add(trimmedPart);
        }
      }
    }

    return cleanedText;
  }

  // Find best match using multiple matching strategies
  Map<String, dynamic>? _findBestMatch(String extractedMedicine, List<Map<String, dynamic>> allMedicines) {
    String searchTerm = extractedMedicine.toLowerCase().trim();

    // Strategy 1: Exact match
    for (var medicine in allMedicines) {
      String medicineName = medicine['name'].toString().toLowerCase();
      if (medicineName == searchTerm) {
        return medicine;
      }
    }

    // Strategy 2: Contains match (medicine name contains extracted text)
    for (var medicine in allMedicines) {
      String medicineName = medicine['name'].toString().toLowerCase();
      if (medicineName.contains(searchTerm) || searchTerm.contains(medicineName)) {
        return medicine;
      }
    }

    // Strategy 3: Check generic name
    for (var medicine in allMedicines) {
      String genericName = medicine['generic']?.toString().toLowerCase() ?? '';
      if (genericName.isNotEmpty && (genericName.contains(searchTerm) || searchTerm.contains(genericName))) {
        return medicine;
      }
    }

    // Strategy 4: Fuzzy matching (starts with)
    for (var medicine in allMedicines) {
      String medicineName = medicine['name'].toString().toLowerCase();
      if (medicineName.startsWith(searchTerm) || searchTerm.startsWith(medicineName)) {
        return medicine;
      }
    }

    // Strategy 5: Similar character matching (70% similarity)
    for (var medicine in allMedicines) {
      String medicineName = medicine['name'].toString().toLowerCase();
      if (_calculateSimilarity(searchTerm, medicineName) >= 0.7) {
        return medicine;
      }
    }

    return null;
  }

  // Calculate similarity between two strings
  double _calculateSimilarity(String str1, String str2) {
    if (str1.isEmpty || str2.isEmpty) return 0.0;

    int maxLength = str1.length > str2.length ? str1.length : str2.length;
    int distance = _levenshteinDistance(str1, str2);

    return (maxLength - distance) / maxLength;
  }

  // Calculate Levenshtein distance
  int _levenshteinDistance(String str1, String str2) {
    List<List<int>> matrix = List.generate(
      str1.length + 1,
          (i) => List.generate(str2.length + 1, (j) => 0),
    );

    for (int i = 0; i <= str1.length; i++) {
      matrix[i][0] = i;
    }

    for (int j = 0; j <= str2.length; j++) {
      matrix[0][j] = j;
    }

    for (int i = 1; i <= str1.length; i++) {
      for (int j = 1; j <= str2.length; j++) {
        int cost = str1[i - 1] == str2[j - 1] ? 0 : 1;

        matrix[i][j] = [
          matrix[i - 1][j] + 1,
          matrix[i][j - 1] + 1,
          matrix[i - 1][j - 1] + cost,
        ].reduce((a, b) => a < b ? a : b);
      }
    }

    return matrix[str1.length][str2.length];
  }

  // Get match type description
  String _getMatchType(String extracted, Map<String, dynamic> matched) {
    String extractedLower = extracted.toLowerCase();
    String matchedLower = matched['name'].toString().toLowerCase();
    String genericLower = matched['generic']?.toString().toLowerCase() ?? '';

    if (matchedLower == extractedLower) return 'Exact Match';
    if (matchedLower.contains(extractedLower)) return 'Name Contains';
    if (genericLower.contains(extractedLower)) return 'Generic Match';
    if (matchedLower.startsWith(extractedLower)) return 'Name Starts With';
    return 'Similar Name';
  }

  // Remove duplicate medicines
  List<Map<String, dynamic>> _removeDuplicates(List<Map<String, dynamic>> medicines) {
    Map<String, Map<String, dynamic>> uniqueMedicines = {};

    for (var medicine in medicines) {
      String key = medicine['name']?.toString() ?? medicine['extractedName'];
      if (!uniqueMedicines.containsKey(key)) {
        uniqueMedicines[key] = medicine;
      }
    }

    return uniqueMedicines.values.toList();
  }

  // Clear results
  void clearResults() {
    _availableMedicines.clear();
    _unavailableMedicines.clear();
    notifyListeners();
  }
}