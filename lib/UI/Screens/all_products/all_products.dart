import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:prescripto/Utilities/colors.dart';
import 'package:provider/provider.dart';

import '../../../Utilities/screen_size_config.dart';
import '../Bottom_nav_bar/nav_bar.dart';
import '../Product_Description_Screen/product_description.dart';
import '../favourites_screen/fav_provider.dart';
import '../favourites_screen/fav_screen.dart';
import 'all_products_provider.dart';

class all_products extends StatefulWidget {
  all_products({
    super.key,
  });

  @override
  State<all_products> createState() => _all_productsState();
}

class _all_productsState extends State<all_products> {
  late List<Map<String, dynamic>> list;

  @override
  Widget build(BuildContext context) {
    screen_config size = screen_config(context);
    return Scaffold(
      backgroundColor: myColors.secondary_color,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Appbar
          Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => bottom_nav_bar(),
                        ),
                      );
                    },
                    child: Icon(color: myColors.primary_color, Icons.arrow_back_ios_new)),
                Text(
                  "All Products",
                  style: TextStyle(
                      fontFamily: 'Bebas',
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: myColors.primary_color),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => favourite_screen(),
                      ),
                    );
                  },
                  child: Icon(
                    Icons.favorite_outline,
                    color: myColors.primary_color,
                    size: 25,
                  ),
                ),
              ],
            ),
          ),

          Consumer<class_all_products_provider>(
            builder: (context, vm, child) {
              return Expanded(
                child: Container(
                  child: FutureBuilder<List<Map<String, dynamic>>>(
                    future: vm.fetchAllItemsFromFirebase(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text("Error: ${snapshot.error}"));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: Text("No medicines found."));
                      }

                      List<Map<String, dynamic>> productList = snapshot.data!;

                      // Group products by first letter
                      Map<String, List<Map<String, dynamic>>> groupedProducts = {};

                      for (var product in productList) {
                        String name = product['name'].toString();
                        if (name.isNotEmpty) {
                          String firstLetter = name[0].toUpperCase();
                          if (!groupedProducts.containsKey(firstLetter)) {
                            groupedProducts[firstLetter] = [];
                          }
                          groupedProducts[firstLetter]!.add(product);
                        }
                      }

                      // Sort the keys alphabetically
                      List<String> sortedLetters = groupedProducts.keys.toList()..sort();

                      return ListView.builder(
                        itemCount: sortedLetters.length,
                        itemBuilder: (context, sectionIndex) {
                          String letter = sortedLetters[sectionIndex];
                          List<Map<String, dynamic>> sectionProducts = groupedProducts[letter]!;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Alphabet header with divider
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                color: myColors.primary_color.withOpacity(0.1),
                                child: Row(
                                  children: [
                                    Text(
                                      letter,
                                      style: TextStyle(
                                        fontFamily: 'Bebas',
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: myColors.primary_color,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Divider(
                                        color: myColors.primary_color,
                                        thickness: 1.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Grid of products for this section
                              GridView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: sectionProducts.length,
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  mainAxisSpacing: 10,
                                  crossAxisSpacing: 5,
                                  crossAxisCount: 2,
                                  mainAxisExtent: size.h * 0.25, // Control the height of each item
                                ),
                                itemBuilder: (context, index) {
                                  return buildProductCard(context, sectionProducts[index], size);
                                },
                              ),
                              SizedBox(height: 10), // Space between sections
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget buildProductCard(BuildContext context, Map<String, dynamic> product, screen_config size) {
    return Center(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => product_description(
                name: product['name'].toString(),
                image: product['image'].toString(),
                generic: product['generic'].toString(),
                description: product['description'].toString(),
                size: product['size'].toString(),
                price: product['price'].toString(),
              ),
            ),
          );
        },
        child: Container(
          width: size.w * 0.4,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: myColors.textSecondary,
                spreadRadius: 2,
                blurRadius: 2,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              // Image
              Image.network(
                product['image'],
                width: size.w * 0.5,
                height: size.h * 0.12,
                errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
              ),
              // Name
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  product['name'],
                  style: TextStyle(
                    fontFamily: "Bebas",
                    fontSize: size.text * 1,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product['size'],
                        style: TextStyle(
                          fontFamily: "Bebas",
                          color: myColors.textSecondary,
                          fontSize: size.text * 0.8,
                        ),
                      ),
                      Text(
                        "Rs ${product['price']}/-",
                        style: TextStyle(
                          fontSize: size.text * 0.8,
                          fontFamily: "Bebas",
                        ),
                      ),
                    ],
                  ),
                  // Favorite Icon
                  Consumer<class_fav_provider>(
                    builder: (context, vm, child) {
                      return InkWell(
                        onTap: () {
                          String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
                          if (userId.isNotEmpty) {
                            vm.favourites.contains(product)
                                ? vm.remove_fav_item(userId, product)
                                : vm.add_fav_item(userId, product);
                          }
                        },
                        child: vm.favourites.contains(product)
                            ? Icon(Icons.favorite, color: Colors.red)
                            : Icon(Icons.favorite_outline),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

}