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
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];
  List<Map<String, dynamic>> _allProducts = [];
  bool _isSearching = false;
  FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);

    // Initialize favorites provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
      if (userId.isNotEmpty) {
        Provider.of<class_fav_provider>(context, listen: false).initialize(userId);
      }
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_searchController.text.isEmpty) {
      setState(() {
        _isSearching = false;
        _searchResults = [];
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _searchResults = _allProducts.where((product) {
        final name = product['name'].toString().toLowerCase();
        final generic = product['generic'].toString().toLowerCase();
        final searchTerm = _searchController.text.toLowerCase();
        return name.contains(searchTerm) || generic.contains(searchTerm);
      }).toList();
    });
  }

  void _navigateToProduct(Map<String, dynamic> product) {
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
  }

  void _clearSearch() {
    setState(() {
      _isSearching = false;
      _searchController.clear();
      _searchResults = [];
    });
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    screen_config size = screen_config(context);
    return Scaffold(
      backgroundColor: myColors.secondary_color,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Appbar with Search
              Container(
                color: myColors.secondary_color,
                child: Column(
                  children: [
                    // Top Navigation Bar
                    Padding(
                      padding: const EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
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
                            child: SizedBox(
                              width: size.w * 0.06, // Same width as the original icon
                            ),

                          ),
                          Text(
                            "All Products",
                            style: TextStyle(
                              fontFamily: 'Bebas',
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: myColors.primary_color,
                            ),
                          ),
                          SizedBox(height:size.w*0.06 ,)
                        ],
                      ),
                    ),
                    // Search Bar
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 15),
                      child: TextField(
                        controller: _searchController,
                        focusNode: _searchFocusNode,
                        onTapOutside: (event) {
                          FocusScope.of(context).unfocus();
                        },
                        onTap: () {
                          setState(() {
                            _isSearching = true;
                          });
                        },
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search, color: myColors.primary_color),
                          suffixIcon: _isSearching
                              ? IconButton(
                            icon: Icon(Icons.clear, color: myColors.primary_color),
                            onPressed: _clearSearch,
                          )
                              : null,
                          hintText: "Search medicines...",
                          hintStyle: TextStyle(
                            fontFamily: "Bebas",
                            fontSize: size.text * 0.9,
                            color: Colors.grey[600],
                          ),
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(color: myColors.primary_color, width: 2),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Main Content - Show either search results or grouped products
              if (_isSearching && _searchController.text.isNotEmpty)
              // Search Results
                Expanded(
                  child: _searchResults.isEmpty
                      ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        SizedBox(height: 16),
                        Text(
                          "No medicines found",
                          style: TextStyle(
                            fontFamily: "Bebas",
                            fontSize: size.text * 1.3,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          "Try different keywords",
                          style: TextStyle(
                            fontSize: size.text * 0.9,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  )
                      : GridView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: _searchResults.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      crossAxisCount: 2,
                      mainAxisExtent: size.h * 0.25,
                    ),
                    itemBuilder: (context, index) {
                      return buildProductCard(context, _searchResults[index], size);
                    },
                  ),
                )
              else
              // Regular Products Display (Grouped by Letter)
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
                            _allProducts = productList; // Store for search functionality

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
                                        mainAxisExtent: size.h * 0.25,
                                      ),
                                      itemBuilder: (context, index) {
                                        return buildProductCard(context, sectionProducts[index], size);
                                      },
                                    ),
                                    SizedBox(height: 10),
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
        ],
      ),
    );
  }

  Widget buildProductCard(BuildContext context, Map<String, dynamic> product, screen_config size) {
    return Consumer<class_fav_provider>(
      builder: (context, vm, child) {
        // Use a unique identifier to check if product is in favorites
        bool isFavorite = vm.favourites.any((fav) => fav['name'] == product['name']);

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
                      InkWell(
                        onTap: () {
                          String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
                          if (userId.isNotEmpty) {
                            isFavorite
                                ? vm.remove_fav_item(userId, product)
                                : vm.add_fav_item(userId, product);
                          }
                        },
                        child: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_outline,
                          color: isFavorite ? Colors.red : null,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}