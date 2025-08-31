import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../Utilities/colors.dart';
import '../../../Utilities/screen_size_config.dart';
import 'fav_provider.dart';
import '../Product_Description_Screen/product_description.dart'; // Add this import

class favourite_screen extends StatefulWidget {
  const favourite_screen({super.key});

  @override
  State<favourite_screen> createState() => _favourite_screenState();
}

class _favourite_screenState extends State<favourite_screen> {
  String? userId;
  @override
  void initState() {
    super.initState();
    userId = FirebaseAuth.instance.currentUser?.uid; // Get current user's ID
    if (userId != null) {
      // Fetch user favorites from Firestore
      Provider.of<class_fav_provider>(context, listen: false).fetchUserFavorites(userId!);
    }
  }
  @override
  Widget build(BuildContext context) {
    screen_config size=screen_config(context);
    return Scaffold(
      backgroundColor: myColors.secondary_color,
      body: Center(
        child: Column(
          children: [
            // App bar
            Padding(
              padding: const EdgeInsets.only(top: 50),
              child: Text(
                "Favourites",
                style: TextStyle(
                  fontFamily: 'Bebas',
                  fontSize: size.text*1.2,
                  fontWeight: FontWeight.bold,
                  color: myColors.primary_color,
                ),
              ),
            ),

            // Favorite List
            // Favorite List from Firestore
            Consumer<class_fav_provider>(
              builder: (context, vm, child) {
                if (vm.favourites.isEmpty) {
                  return
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/brokenheart.png',
                          ),
                          SizedBox(height: size.h*0.02),
                          Text(
                            "Oops! It seems you haven't liked anything yet.",
                            style: TextStyle(
                              fontFamily: 'Bebas',
                              fontSize: size.text*1,
                              color: myColors.primary_color,
                            ),
                          ),
                        ],
                      ),
                    );
                }

                return Expanded(
                  child: ListView.builder(
                    itemCount: vm.favourites.length,
                    itemBuilder: (context, index) {
                      final favoriteItem = vm.favourites[index];

                      // Adding null safety checks with default values
                      final image = favoriteItem['image'] ?? '';
                      final name = favoriteItem['name'] ?? 'Unknown Item';
                      final price = favoriteItem['price'] ?? 'Price Unavailable';
                      final description = favoriteItem['description'] ?? 'No description available';
                      final size_value = favoriteItem['size'] ?? 'Size not specified';
                      final generic = favoriteItem['generic'] ?? '';

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            // Navigate to product description screen
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => product_description(
                                  name: name,
                                  image: image,
                                  description: description,
                                  size: size_value,
                                  price: price.toString(),
                                  generic: generic,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: myColors.textSecondary,
                                  spreadRadius: 2,
                                  blurRadius: 2,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Image.network(
                                      image,
                                      width: size.w*0.2,
                                      height: size.h*0.09,
                                      errorBuilder: (context, error, stackTrace) =>
                                          Icon(Icons.error),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              name,
                                              style: TextStyle(
                                                  fontFamily: 'Bebas',
                                                  fontSize: size.text*0.9
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              "Rs "+price.toString()+"/-",
                                              style: TextStyle(
                                                color: myColors.primary_color,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete),
                                      onPressed: () {
                                        if (userId != null) {
                                          vm.remove_fav_item(userId!, favoriteItem);
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}