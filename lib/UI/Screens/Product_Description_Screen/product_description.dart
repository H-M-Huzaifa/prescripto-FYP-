import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:badges/badges.dart' as badges;
import 'package:prescripto/UI/Screens/Product_Description_Screen/product_description_provider.dart';
import 'package:provider/provider.dart';

import '../../../Utilities/colors.dart';
import '../../../Utilities/screen_size_config.dart';
import '../Bottom_nav_bar/nav_bar.dart';
import '../Cart/Cart_screen.dart';
import '../Cart/cart_provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class product_description extends StatefulWidget {
  String name;
  String image;
  String description;
  String size;
  String price;
  String generic;
  int? initialQuantity; // Add optional initial quantity parameter

  product_description({
    super.key,
    required this.name,
    required this.image,
    required this.generic,
    required this.description,
    required this.size,
    required this.price,
    this.initialQuantity, // Optional parameter
  });

  @override
  State<product_description> createState() => _product_descriptionState();
}

class _product_descriptionState extends State<product_description> {
  // Check internet connection
  // This method checks the internet connection status
  Future<bool> hasInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final prodDescProvider = Provider.of<class_prod_desc>(context, listen: false);

      // If initialQuantity is provided, set it, otherwise reset to default
      if (widget.initialQuantity != null && widget.initialQuantity! > 0) {
        prodDescProvider.set_quantity(widget.initialQuantity!);
      } else {
        prodDescProvider.reset_quantity();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    screen_config size = screen_config(context);
    final instance_cart_provider = Provider.of<class_cart_provider>(context);
    final instance_prod_desc_provider = Provider.of<class_prod_desc>(context);
    return Scaffold(
      backgroundColor: myColors.secondary_color,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //product_container
            Container(
              width: double.infinity,
              height: size.h * 0.52,
              decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.scaleDown, image: NetworkImage(widget.image)
                ),
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
                        GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(
                                color: myColors.secondary_color,
                                size: size.h * 0.027,
                                Icons.arrow_back_ios_new)),
                        Text(
                          widget.name,
                          style: TextStyle(
                              fontFamily: 'Bebas',
                              fontSize: size.text * 1.2,
                              fontWeight: FontWeight.bold,
                              color: myColors.secondary_color),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => cart(),
                                ));
                          },
                          child: badges.Badge(
                            position:
                            badges.BadgePosition.topEnd(end: -10, top: -10),
                            badgeAnimation: badges.BadgeAnimation.slide(),
                            badgeContent: Text(
                              instance_cart_provider.cart_items.length >= 1
                                  ? instance_cart_provider.cart_items.length
                                  .toString()
                                  : "",
                              style:
                              TextStyle(color: Colors.white, fontSize: 18),
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
                  ],
                ),
              ),
            ),

            Center(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  textAlign: TextAlign.center,
                  widget.generic.toString(),
                  style: TextStyle(
                      fontSize: size.text * 0.8,
                      color: Colors.grey),
                ),
              ),
            ),

            //Text Description
            Center(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  textAlign: TextAlign.center,
                  widget.description.toString(),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: size.text * 0.8,
                      color: myColors.primary_color),
                ),
              ),
            ),

            //Size
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Center(
                child: Container(
                  width: size.w * 0.8,
                  height: size.h * 0.06,
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xff7D7D7D),
                          spreadRadius: -1,
                          blurRadius: 7,
                          offset: Offset(0, 10),
                        )
                      ],
                      borderRadius: BorderRadius.circular(30),
                      color: myColors.tertiary_color),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text(
                          "Size",
                          style: TextStyle(
                              fontFamily: "Bebas", fontSize: size.text * 1.2),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Text(
                          widget.size,
                          style: TextStyle(
                              fontFamily: "Bebas",
                              fontSize: size.text * 1.2,
                              color: myColors.primary_color),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),

            //Price
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Center(
                child: Container(
                  width: size.w * 0.8,
                  height: size.h * 0.06,
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xff7D7D7D),
                          spreadRadius: -1,
                          blurRadius: 7,
                          offset: Offset(0, 10),
                        )
                      ],
                      borderRadius: BorderRadius.circular(30),
                      color: myColors.tertiary_color),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text(
                          "Price",
                          style: TextStyle(
                              fontFamily: "Bebas", fontSize: size.text * 1.2),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Text(
                          "Rs " + widget.price + "/-",
                          style: TextStyle(
                              fontFamily: "Bebas",
                              fontSize: size.text * 1.2,
                              color: myColors.primary_color),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),

            //Quantity
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Center(
                child: Container(
                  width: size.w * 0.8,
                  height: size.h * 0.06,
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xff7D7D7D),
                          spreadRadius: -1,
                          blurRadius: 7,
                          offset: Offset(0, 10),
                        )
                      ],
                      borderRadius: BorderRadius.circular(30),
                      color: myColors.tertiary_color),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text(
                          "Quantity",
                          style: TextStyle(
                              fontFamily: "Bebas", fontSize: size.text * 1.2),
                        ),
                      ),
                      Consumer<class_prod_desc>(
                        builder: (context, vm, child) {
                          return Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: Container(
                                child: Row(children: [
                                  //remove
                                  GestureDetector(
                                    onTap: () {
                                      vm.quantity_decrement();
                                    },
                                    child: Container(
                                      width: 35,
                                      height: 35,
                                      child: Icon(
                                          color: Colors.white, Icons.remove),
                                      decoration: BoxDecoration(
                                          color: myColors.primary_color,
                                          shape: BoxShape.circle),
                                    ),
                                  ),

                                  //number
                                  Padding(
                                    padding:
                                    EdgeInsets.symmetric(horizontal: 15),
                                    child: Text(
                                      vm.quantity.toString(),
                                      style: TextStyle(
                                          fontFamily: "Bebas",
                                          fontSize: size.text * 1.2),
                                    ),
                                  ),

                                  //add
                                  GestureDetector(
                                    onTap: () {
                                      vm.quantity_increment();
                                    },
                                    child: Container(
                                      width: 35,
                                      height: 35,
                                      child:
                                      Icon(color: Colors.white, Icons.add),
                                      decoration: BoxDecoration(
                                          color: myColors.primary_color,
                                          shape: BoxShape.circle),
                                    ),
                                  ),
                                ]),
                              ));
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),

            //Add to Cart
            Consumer<class_cart_provider>(
              builder: (context, vm, child) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: GestureDetector(
                      onTap: () async {
                        // Ensure the connectivity check completes before proceeding
                        bool connected = await hasInternetConnection();
                        print('Internet connection status: $connected');

                        if (!connected) {
                          // If no internet, show the no internet message and exit
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              duration: Duration(seconds: 2),
                              backgroundColor: Colors.red,
                              content: Center(
                                child: Text(
                                  "No internet connection",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Bebas',
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          );
                          return; // Exit function if no connection
                        }

                        // Only proceed if connected
                        int? price = int.tryParse(widget.price);
                        int finalprice = (price ?? 0) * (instance_prod_desc_provider.quantity ?? 0);
                        final item = {
                          'name': widget.name,
                          'generic': widget.generic,
                          'description': widget.description,
                          'image': widget.image,
                          'price': widget.price,
                          'size': widget.size,
                          'quantity': instance_prod_desc_provider.quantity,
                          'finalprice': finalprice,
                        };

                        vm.add_cart_item(item);

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            duration: Duration(seconds: 2),
                            backgroundColor: myColors.snackbar,
                            content: Center(
                              child: Text(
                                "Added to cart",
                                style: TextStyle(
                                  fontSize: size.text * 0.8,
                                  fontFamily: 'Bebas',
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      child: Container(
                        height: size.h * 0.055,
                        width: size.w * 0.7,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xff7D7D7D),
                              spreadRadius: -1,
                              blurRadius: 7,
                              offset: Offset(0, 10),
                            )
                          ],
                          borderRadius: BorderRadius.circular(30),
                          color: myColors.primary_color,
                        ),
                        child: Center(
                          child: Text(
                            "Add to cart",
                            style: TextStyle(
                              fontFamily: "Bebas",
                              fontSize: size.text * 1.2,
                              color: myColors.secondary_color,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}