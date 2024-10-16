import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:prescripto/Utilities/colors.dart';
import 'package:provider/provider.dart';

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
                //GestureDetector(onTap: (){Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => bottom_nav_bar(),));},child: Icon(color: myColors.primary_color, Icons.arrow_back_ios_new)),
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
            return Expanded(
              child: Container(
                child: GridView.builder(
                  itemCount: vm.allItems.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 30, crossAxisSpacing: 5, crossAxisCount: 2),
                  itemBuilder: (context, index) {
                    list=vm.allItems;
                    return Center(
                      child: GestureDetector(
                        // onTap: () {
                        //   Navigator.push(
                        //       context,
                        //       MaterialPageRoute(
                        //         builder: (context) => product_description(
                        //           name : list[index]['name'],
                        //           image : list[index]['image'],
                        //           description: list[index]['description'],
                        //           size: list[index]['size'],
                        //           price: list[index]['price'],
                        //         ),
                        //       ));

                        //},
                        child: Container(
                          width: 170,
                          height: 250,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(22),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey,
                                  spreadRadius: 2,
                                  blurRadius: 2,
                                  offset: Offset(0, 5),
                                ),
                              ]),
                          child: Column(
                            children: [
                              //Image
                              Image(
                                image: AssetImage(list[index]['image']),
                                width: 150,
                                height: 100,
                              ),

                              //Name
                              Text(
                                list[index]['name'],
                                style: TextStyle(
                                  fontFamily: "Bebas",
                                  fontSize: 22,
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
                                            color: Colors.grey,
                                            fontSize: 18),
                                      ),
                                      Text(
                                        "Rs " + list[index]['price']+"/-",
                                        style: TextStyle(
                                            fontSize: 18, fontFamily: "Bebas"),
                                      ),
                                    ],
                                  ),
                                  Consumer<class_fav_provider>(
                                    builder: (context, vm, child) {
                                      return InkWell(
                                        onTap: () {
                                          // instance_favourites.toggleFavourite(list_items[index]);
                                          vm.favourites.contains(list[index])
                                              ? vm.remove_fav_item(list[index])
                                              : vm.add_fav_item(list[index]);
                                        },
                                        child:
                                        vm.favourites.contains(list[index])
                                            ? Icon(
                                          Icons.favorite,
                                          color: Colors.red,
                                        )
                                            : Icon(Icons.favorite_outline),
                                      );
                                      // IconButton(
                                      //   icon:
                                      //   vm.favourites.contains(list_items[index])
                                      //       ? Icon(
                                      //     Icons.favorite,
                                      //     color: Colors.red,
                                      //   )
                                      //       : Icon(Icons.favorite_border),
                                      //   onPressed: () {
                                      //     instance_favourites
                                      //         .toggleFavourite(product);
                                      //   },
                                      // );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
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
