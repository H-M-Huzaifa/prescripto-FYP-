import 'package:flutter/material.dart';
import 'package:prescripto/UI/Screens/favourites_screen/fav_screen.dart';
import 'package:provider/provider.dart';

import 'medicine_matcher_provider.dart';
import '../Product_Description_Screen/product_description.dart'; // Add this import

class ResultScreen extends StatefulWidget {
  final List<String> textLines;

  ResultScreen({required this.textLines});

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    // Start medicine matching
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MedicineMatcherProvider>(context, listen: false)
          .matchMedicinesWithInventory(widget.textLines);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Add navigation method
  void _navigateToProduct(Map<String, dynamic> medicine) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => product_description(
          name: medicine['name'].toString(),
          image: medicine['image'].toString(),
          generic: medicine['generic'].toString(),
          description: medicine['description'].toString(),
          size: medicine['size'].toString(),
          price: medicine['price'].toString(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffECF9FF),
      body: SafeArea(
        child: Column(
          children: [
            // Custom Appbar
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 16, right: 16, bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).popUntil((route) => route.isFirst),
                    child: const Icon(Icons.arrow_back_ios_new, color: Color(0xff1F509A)),
                  ),
                  const Text(
                    "Prescription Analysis",
                    style: TextStyle(
                      fontFamily: 'Bebas',
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff1F509A),
                    ),
                  ),
                  // This SizedBox now balances the space taken by the Icon,
                  // perfectly centering the title.
                  const SizedBox(width: 24.0),
                ],
              ),
            ),

            // Tab buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(0, (index) { // Changed from 1 to 3
                  final isActive = _tabController.index == index;
                  final titles = ['Available', 'Not Found', 'Raw Text'];
                  final colors = [
                    Icons.medication,
                    Icons.error_outline,
                    Icons.text_snippet,
                  ];
                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _tabController.index = index;
                        });
                      },
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        margin: EdgeInsets.symmetric(horizontal: 4),
                        padding: EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: isActive ? Color(0xff1F509A) : Color(0xffBFD8F3),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(colors[index], color: Colors.white),
                            SizedBox(height: 4),
                            Text(
                              titles[index],
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),

            // Tab Views
            Expanded(
              child: Consumer<MedicineMatcherProvider>(
                builder: (context, matcher, child) {
                  if (matcher.isLoading) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 20),
                          Text(
                            "Matching medicines with inventory...",
                            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    );
                  }

                  return TabBarView(
                    controller: _tabController,
                    physics: NeverScrollableScrollPhysics(), // prevent swipe, only button tap
                    children: [
                      _buildAvailableMedicinesTab(matcher.availableMedicines),
                      _buildUnavailableMedicinesTab(matcher.unavailableMedicines),
                      _buildRawTextTab(widget.textLines),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildAvailableMedicinesTab(List<Map<String, dynamic>> availableMedicines) {
    if (availableMedicines.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.medication_liquid, size: 80, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              "No matching medicines found in inventory",
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16),
          color: Colors.green.shade50,
          child: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 8),
              Text(
                "${availableMedicines.length} medicine(s) available in store",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade700,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: availableMedicines.length,
            itemBuilder: (context, index) {
              final medicine = availableMedicines[index];
              return _buildMedicineCard(medicine, isAvailable: true);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildUnavailableMedicinesTab(List<Map<String, dynamic>> unavailableMedicines) {
    if (unavailableMedicines.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle_outline, size: 80, color: Colors.green),
            SizedBox(height: 16),
            Text(
              "All medicines are available!",
              style: TextStyle(fontSize: 18, color: Colors.green),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16),
          color: Colors.orange.shade50,
          child: Row(
            children: [
              Icon(Icons.warning, color: Colors.orange),
              SizedBox(width: 8),
              Text(
                "${unavailableMedicines.length} medicine(s) not found in store",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange.shade700,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: unavailableMedicines.length,
            itemBuilder: (context, index) {
              final medicine = unavailableMedicines[index];
              return _buildMedicineCard(medicine, isAvailable: false);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRawTextTab(List<String> textLines) {
    if (textLines.isEmpty) {
      return Center(
        child: Text(
          "No text extracted from the prescription.",
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: textLines.length,
      itemBuilder: (context, index) => Card(
        margin: EdgeInsets.symmetric(vertical: 4),
        child: ListTile(
          leading: CircleAvatar(
            child: Text('${index + 1}'),
            backgroundColor: Colors.blue.shade100,
          ),
          title: Text(
            textLines[index],
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }

  Widget _buildMedicineCard(Map<String, dynamic> medicine, {required bool isAvailable}) {
    return GestureDetector( // Wrap the entire card with GestureDetector
      onTap: () {
        // Only navigate if medicine is available and has required data
        if (isAvailable &&
            medicine['name'] != null &&
            medicine['image'] != null &&
            medicine['generic'] != null &&
            medicine['description'] != null &&
            medicine['size'] != null &&
            medicine['price'] != null) {
          _navigateToProduct(medicine);
        }
      },
      child: Card(
        margin: EdgeInsets.only(bottom: 12),
        elevation: 3,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Medicine Image (if available)
                  if (isAvailable && medicine['image'] != null)
                    Container(
                      width: 60,
                      height: 60,
                      margin: EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(7),
                        child: Image.network(
                          medicine['image'],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Icon(Icons.medication, color: Colors.grey),
                        ),
                      ),
                    ),

                  // Medicine Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Medicine Name
                        Text(
                          isAvailable ? medicine['name'] : medicine['extractedName'],
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isAvailable ? Colors.black : Colors.grey[700],
                          ),
                        ),

                        SizedBox(height: 4),

                        // Extracted vs Matched Name
                        if (isAvailable && medicine['extractedName'] != medicine['name'])
                          Text(
                            "From prescription: ${medicine['extractedName']}",
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                              fontStyle: FontStyle.italic,
                            ),
                          ),

                        SizedBox(height: 8),

                        // Match Type Badge
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: isAvailable ? Colors.green.shade100 : Colors.red.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            isAvailable ? medicine['matchType'] : 'Not Available',
                            style: TextStyle(
                              fontSize: 12,
                              color: isAvailable ? Colors.green.shade700 : Colors.red.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Status Icon with tap indication for available medicines
                  Icon(
                    isAvailable ? Icons.check_circle : Icons.cancel,
                    color: isAvailable ? Colors.green : Colors.red,
                    size: 28,
                  ),
                ],
              ),

              // Additional Details for Available Medicines
              if (isAvailable) ...[
                Divider(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (medicine['generic'] != null && medicine['generic'].toString().isNotEmpty)
                            Text(
                              "Generic: ${medicine['generic']}",
                              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                            ),
                          if (medicine['size'] != null)
                            Text(
                              "Size: ${medicine['size']}",
                              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                            ),
                        ],
                      ),
                    ),
                    if (medicine['price'] != null)
                      Text(
                        "Rs ${medicine['price']}/-",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade700,
                        ),
                      ),
                  ],
                ),
                // Add a subtle indication that the card is tappable
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.touch_app, size: 16, color: Colors.grey[400]),
                    SizedBox(width: 4),
                    Text(
                      "Tap for details",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}