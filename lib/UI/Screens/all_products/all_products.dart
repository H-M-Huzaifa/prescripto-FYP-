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
  // int index;
  // String name;
  // List<Map<String, List<Map<String, dynamic>>>> allItems;

  all_products({
    super.key,
  //   required this.index,
  // required this.name,
  //   required this.allItems,
  });

  @override
  State<all_products> createState() => _all_productsState();
}

class _all_productsState extends State<all_products> {
  late List<Map<String, dynamic>> list;

  // @override
  // void initState() {
  //   super.initState();
  //   //list = widget.allItems[widget.index][widget.name]!;  // Access the specific map
  // }

  @override
  Widget build(BuildContext context) {
    screen_config size=screen_config(context);
    return Scaffold(
      backgroundColor: myColors.secondary_color,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          //appbar
          Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(onTap: (){Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => bottom_nav_bar(),));},child: Icon(color: myColors.primary_color, Icons.arrow_back_ios_new)),
                Text(
                  "All Products",
                  style: TextStyle(
                      fontFamily: 'Bebas',
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: myColors.primary_color),
                ),
                GestureDetector(onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context) => favourite_screen(),));},
                  child: Icon(
                    Icons.favorite_outline,
                    color: myColors.primary_color,
                    size: 25,
                  ),
                ),
              ],
            ),
          ),

          Consumer<class_all_products_provider>(builder: (context, vm, child) {
            return
              Expanded(
                child: Container(
                  child: FutureBuilder<List<Map<String, dynamic>>>(
                    // Change the method to fetch all medicines from Firestore
                    future: vm.fetchAllItemsFromFirebase(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(child: Text("Error: ${snapshot.error}"));
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(child: Text("No medicines found."));
                      }

                      List<Map<String, dynamic>> list = snapshot.data!;

                      return GridView.builder(
                        itemCount: list.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 5,
                          crossAxisCount: 2,
                        ),
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
                                      description: list[index]['description'].toString(),
                                      size: list[index]['size'].toString(),
                                      price: list[index]['price'].toString(),
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
                                                fontSize: size.text * 0.8,
                                              ),
                                            ),
                                            Text(
                                              "Rs ${list[index]['price']}/-",
                                              style: TextStyle(
                                                fontSize: size.text * 0.8,
                                                fontFamily: "Bebas",
                                              ),
                                            ),
                                          ],
                                        ),
                                        // Consumer<class_fav_provider>(
                                        //   builder: (context, vm, child) {
                                        //     return InkWell(
                                        //       onTap: () {
                                        //         String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
                                        //         if (userId.isNotEmpty) {
                                        //           vm.favourites.contains(list[index])
                                        //               ? vm.remove_fav_item(userId, list[index])
                                        //               : vm.add_fav_item(userId, list[index]);
                                        //         }
                                        //       },
                                        //       child: vm.favourites.contains(list[index])
                                        //           ? Icon(Icons.favorite, color: Colors.red)
                                        //           : Icon(Icons.favorite_outline),
                                        //     );
                                        //   },
                                        // ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
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
}
