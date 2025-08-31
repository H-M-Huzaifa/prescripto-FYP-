import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:prescripto/UI/Screens/home_screen/home_screen_provider.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badges;

import '../../../Utilities/colors.dart';
import '../../../Utilities/screen_size_config.dart';
import '../../../upload_products.dart';
import '../Cart/Cart_screen.dart';
import '../Cart/cart_provider.dart';
import '../Product_Description_Screen/product_description.dart';
import '../all_products/all_products_provider.dart';
import '../chatbot.dart';
import '../favourites_screen/fav_provider.dart';
import '../sign_in&up/signup_provider.dart';

class home_screen extends StatefulWidget {
  final VoidCallback? onAvatarTap;
  const home_screen({super.key, this.onAvatarTap,});

  @override
  State<home_screen> createState() => _home_screenState();
}

class _home_screenState extends State<home_screen> {
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey _searchKey = GlobalKey();
  List<Map<String, dynamic>> _searchResults = [];
  bool _isSearching = false;
  FocusNode _searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged() async {
    if (_searchController.text.isEmpty) {
      setState(() {
        _isSearching = false;
        _searchResults = [];
      });
      return;
    }

    setState(() {
      _isSearching = true;
    });

    final instance_all_products_provider = Provider.of<class_all_products_provider>(context, listen: false);
    List<Map<String, dynamic>> allProducts = await instance_all_products_provider.fetchAllItemsFromFirebase();

    setState(() {
      _searchResults = allProducts.where((product) {
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
    UploadProducts myproducts = UploadProducts();
    screen_config size = screen_config(context);
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final instance_cart_provider = Provider.of<class_cart_provider>(context);
    final instance_all_products_provider = Provider.of<class_all_products_provider>(context, listen: false);

    return Scaffold(
      backgroundColor: myColors.secondary_color,
      // Setting this to false is best practice for this layout
      resizeToAvoidBottomInset: false,

      //Floating Button
      floatingActionButton: FloatingActionButton(
          tooltip: "Chat with AI",
          child: Image(
              height: size.h * 0.04,
              image: AssetImage('assets/icons/chat.png')
          ),
          backgroundColor: myColors.primary_color,
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => Chatbot()));
          }
      ),

      body: Stack(
        children: [
          // Main UI Layer (Header + Scrollable Content)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Non-scrolling header
              Container(
                width: double.infinity,
                height: size.h * 0.37,
                decoration: const BoxDecoration(
                  color: myColors.primary_color,
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(150),
                    bottomLeft: Radius.circular(150),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Consumer<class_sign_up_provider>(
                            builder: (context, vm, child) {
                              vm.fetchUserImage();
                              return GestureDetector(
                                onTap: widget.onAvatarTap, // This will call the callback
                                child: CircleAvatar(
                                  maxRadius: size.h * 0.016,
                                  backgroundColor: myColors.textSecondary,
                                  backgroundImage: vm.imageUrl != null
                                      ? NetworkImage(vm.imageUrl!)
                                      : AssetImage('assets/images/avatar.png') as ImageProvider,
                                ),
                              );
                            },
                          ),
                          Text(
                            "Home",
                            style: TextStyle(
                                fontFamily: 'Bebas',
                                fontSize: size.text * 1.2,
                                fontWeight: FontWeight.bold,
                                color: myColors.secondary_color
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => cart())
                              );
                            },
                            child: badges.Badge(
                              position: badges.BadgePosition.topEnd(end: -10, top: -10),
                              badgeAnimation: badges.BadgeAnimation.slide(),
                              badgeContent: Text(
                                instance_cart_provider.cart_items.length >= 1
                                    ? instance_cart_provider.cart_items.length.toString()
                                    : "",
                                style: TextStyle(color: Colors.white, fontSize: 18),
                              ),
                              child: Icon(
                                Icons.shopping_bag,
                                color: myColors.secondary_color,
                                size: size.h * 0.027,
                              ),
                            ),
                          ),
                        ],
                      ),

                      //Logo
                      Container(
                          decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: []),
                          child: Image(
                            width: size.w * 0.4,
                            image: AssetImage('assets/images/logo.png'),
                          )
                      ),

                      //Search Bar
                      Padding(
                        key: _searchKey,
                        padding: const EdgeInsets.fromLTRB(25, 0, 25, 10),
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
                                color: Colors.grey[600]
                            ),
                            fillColor: Colors.white,
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(color: myColors.primary_color),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(color: myColors.primary_color, width: 2),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),

              // Scrollable content area
              if (!_isSearching || _searchController.text.isEmpty)
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //Prescription
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20, top: 10),
                            child: Container(
                              height: size.h * 0.17,
                              width: size.w * 0.9,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(0xff7D7D7D),
                                    spreadRadius: 2,
                                    blurRadius: 7,
                                    offset: Offset(0, 10),
                                  )
                                ],
                                color: myColors.tertiary_color,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 20),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(top: 2),
                                          child: Text(
                                            "Prescription",
                                            style: TextStyle(
                                                fontFamily: 'Bebas',
                                                fontWeight: FontWeight.bold,
                                                fontSize: size.text * 1.3
                                            ),
                                          ),
                                        ),
                                        Text(
                                          "\nUpload your prescription\nand we will do the rest!",
                                          style: TextStyle(fontSize: size.text * 0.7),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(bottom: 10, top: 5, left: 10),
                                          child: Center(
                                            child: GestureDetector(
                                              onTap: () {
                                                final provider = Provider.of<class_homescreen_provider>(context, listen: false);
                                                provider.pickImage(context);
                                              },
                                              child: Container(
                                                height: size.h * 0.04,
                                                width: size.w * 0.4,
                                                decoration: BoxDecoration(
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Color(0xff7D7D7D),
                                                        spreadRadius: -5,
                                                        blurRadius: 7,
                                                        offset: Offset(0, 10),
                                                      )
                                                    ],
                                                    color: myColors.primary_color,
                                                    borderRadius: BorderRadius.circular(50)
                                                ),
                                                child: Center(
                                                    child: Text(
                                                      "Upload",
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: size.text * 1,
                                                          fontFamily: 'Bebas'
                                                      ),
                                                    )
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Image(
                                      width: size.w * 0.28,
                                      image: AssetImage('assets/images/Upload_Prescription.png')
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        //Best Selling
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: Text(
                            "Best Selling:",
                            style: TextStyle(
                                fontSize: size.text * 1.2,
                                fontFamily: 'Bebas',
                                color: myColors.primary_color,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ),

                        //items
                        Container(
                          height: size.h * 0.28, // Give horizontal list a fixed height
                          child: FutureBuilder<List<Map<String, dynamic>>>(
                            future: instance_all_products_provider.fetchPopularItemsFromFirebase(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return Center(child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return Center(child: Text("Error: ${snapshot.error}"));
                              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                return Center(child: Text("No popular items found."));
                              }

                              List<Map<String, dynamic>> list = snapshot.data!;

                              return ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: list.length,
                                itemBuilder: (context, index) {
                                  return Center(
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => product_description(
                                              name: list[index]['name'].toString(),
                                              image: list[index]['image'].toString(),
                                              generic: list[index]['generic'].toString(),
                                              description: list[index]['description'].toString(),
                                              size: list[index]['size'].toString(),
                                              price: list[index]['price'].toString(),
                                            ),
                                          ),
                                        );
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 5),
                                        child: Container(
                                          width: size.w * 0.4,
                                          height: size.h * 0.25,
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
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                                              // Image
                                              Image.network(
                                                list[index]['image'],
                                                width: size.w * 0.5,
                                                height: size.h * 0.12,
                                                errorBuilder: (context, error, stackTrace) =>
                                                    Icon(Icons.error),
                                              ),
                                              // Name
                                              Text(
                                                list[index]['name'],
                                                style: TextStyle(
                                                  fontFamily: "Bebas",
                                                  fontSize: size.text * 1,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        list[index]['size'],
                                                        style: TextStyle(
                                                            fontFamily: "Bebas",
                                                            color: myColors.textSecondary,
                                                            fontSize: size.text * 0.8
                                                        ),
                                                      ),
                                                      Text(
                                                        "Rs ${list[index]['price'] + "/-"}",
                                                        style: TextStyle(
                                                            fontSize: size.text * 0.8,
                                                            fontFamily: "Bebas"
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Consumer<class_fav_provider>(
                                                    builder: (context, vm, child) {
                                                      return InkWell(
                                                        onTap: () {
                                                          String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
                                                          if (userId.isNotEmpty) {
                                                            vm.favourites.contains(list[index])
                                                                ? vm.remove_fav_item(userId, list[index])
                                                                : vm.add_fav_item(userId, list[index]);
                                                          }
                                                        },
                                                        child: vm.favourites.contains(list[index])
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
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),

          // Search Results Dropdown Layer (will appear on top of everything else)
          if (_isSearching && _searchController.text.isNotEmpty)
            Positioned(
              top: size.h * 0.36,
              left: 20,
              right: 20,
              child: Material(
                elevation: 8,
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: myColors.primary_color.withOpacity(0.2)),
                  ),
                  child: _searchResults.isEmpty
                      ? Container(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 48,
                          color: Colors.grey[400],
                        ),
                        SizedBox(height: 12),
                        Text(
                          "No medicines found",
                          style: TextStyle(
                            fontFamily: "Bebas",
                            fontSize: size.text * 1.1,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          "Try different keywords",
                          style: TextStyle(
                            fontSize: size.text * 0.8,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  )
                      : Column(
                    children: [
                      // Header
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: myColors.primary_color.withOpacity(0.05),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.search, color: myColors.primary_color, size: 20),
                            SizedBox(width: 8),
                            Text(
                              "${_searchResults.length} results found",
                              style: TextStyle(
                                fontFamily: "Bebas",
                                fontSize: size.text * 0.9,
                                color: myColors.primary_color,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Results List
                      Expanded(
                        child: ListView.separated(
                          padding: EdgeInsets.zero,
                          itemCount: _searchResults.length,
                          separatorBuilder: (context, index) => Divider(
                            height: 1,
                            color: Colors.grey[200],
                          ),
                          itemBuilder: (context, index) {
                            final product = _searchResults[index];
                            return InkWell(
                              onTap: () {
                                _navigateToProduct(product);
                                _clearSearch();
                              },
                              child: Container(
                                padding: EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    // Product Image
                                    Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        color: Colors.grey[100],
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: Image.network(
                                          product['image'],
                                          width: 60,
                                          height: 60,
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) =>
                                              Icon(
                                                Icons.medication,
                                                color: myColors.primary_color,
                                                size: 30,
                                              ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 16),
                                    // Product Details
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            product['name'],
                                            style: TextStyle(
                                              fontFamily: "Bebas",
                                              fontSize: size.text * 1.1,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            product['generic'] ?? '',
                                            style: TextStyle(
                                              fontSize: size.text * 0.85,
                                              color: Colors.grey[600],
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          SizedBox(height: 8),
                                          Row(
                                            children: [
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 8,
                                                  vertical: 4,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: myColors.primary_color.withOpacity(0.1),
                                                  borderRadius: BorderRadius.circular(6),
                                                ),
                                                child: Text(
                                                  product['size'] ?? '',
                                                  style: TextStyle(
                                                    fontSize: size.text * 0.75,
                                                    color: myColors.primary_color,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                              Spacer(),
                                              Text(
                                                "Rs ${product['price']}/-",
                                                style: TextStyle(
                                                    fontSize: size.text,
                                                    fontFamily: "Bebas",
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black87
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
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
            ),
        ],
      ),
    );
  }
}