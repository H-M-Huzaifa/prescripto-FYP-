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
  const home_screen({super.key});

  @override
  State<home_screen> createState() => _home_screenState();
}

class _home_screenState extends State<home_screen> {
  @override
  Widget build(BuildContext context) {
    UploadProducts myproducts =UploadProducts();
    screen_config size=screen_config(context);
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final instance_cart_provider = Provider.of<class_cart_provider>(context);
    final instance_all_products_provider = Provider.of<class_all_products_provider>(context,listen: false);

    return Scaffold(
      backgroundColor: myColors.secondary_color,

      //Floating Button
      floatingActionButton: FloatingActionButton(tooltip: "Chat with AI",
          child: Image(
              height: size.h*0.04,
              image: AssetImage('assets/icons/chat.png')),
          backgroundColor: myColors.primary_color,
          onPressed: () {
        //myproducts.uploadProducts();

         Navigator.push(context, MaterialPageRoute(builder: (context) => Chatbot(),));
          }),

      body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        //app bar
        Container(
          width: double.infinity,
          height: size.h*0.37,
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
                    Consumer<class_sign_up_provider>(builder: (context, vm, child) {
                      vm.fetchUserImage();
                      return CircleAvatar(
                        maxRadius: size.h*0.016,
                        backgroundColor: myColors.textSecondary,
                        backgroundImage: vm.imageUrl != null
                            ? NetworkImage(vm.imageUrl!) // Network image if available
                            : AssetImage('assets/images/avatar.png') as ImageProvider, // Default avatar image
                      );

                    },
                    ),
                    Text(
                      "Home",
                      style: TextStyle(
                          fontFamily: 'Bebas',
                          fontSize: size.text*1.2,
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
                      child: badges.Badge(position: badges.BadgePosition.topEnd(end: -10,top: -10),
                        badgeAnimation: badges.BadgeAnimation.slide(),
                        badgeContent: Text(
                          instance_cart_provider.cart_items.length>=1 ?
                          instance_cart_provider.cart_items.length.toString() : "",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        child: Icon(
                          Icons.shopping_bag,
                          color: myColors.secondary_color,
                          size: size.h*0.027,
                        ),
                      ),
                    ),
                  ],
                ),

                //Logo
                Container(
                    decoration:
                        BoxDecoration(shape: BoxShape.circle, boxShadow: [
                      // BoxShadow(
                      //   color: Color(0xff7D7D7D),
                      //   spreadRadius: -15,
                      //   blurRadius: 0,
                      //   offset: Offset(-10, 10),
                      // ),
                    ]),
                    child: Image(
                      width: size.w*0.4,
                      image: AssetImage('assets/images/logo.png'),
                    )),

                //Search Bar
                Padding(
                  padding: const EdgeInsets.fromLTRB(25, 0, 25, 10),
                  child: TextField(
                    onTapOutside: (event) => () {},
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: "Search",
                      hintStyle: TextStyle(fontFamily: "Bebas",fontSize: size.text*0.9),
                      fillColor: Colors.white,
                      filled: true,
                      border: UnderlineInputBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),

        //Prescription
        Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 20,right: 20,bottom: 20,top: 10),
            child: Container(
              height: size.h*0.17,
              width: size.w*0.9,
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
                          child: Text("Prescription",style: TextStyle(fontFamily: 'Bebas',fontWeight: FontWeight.bold, fontSize: size.text*1.3 ),),
                        ),
                        Text("\nUpload your prescription\nand we will do the rest!",style: TextStyle(fontSize: size.text*0.7),),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10,top: 5, left: 10),
                          child: Center(
                            child: GestureDetector(
                              onTap: (){
                                final provider = Provider.of<class_homescreen_provider>(context, listen: false);
                                provider.pickImage(context);
                              },
                              child: Container(
                                height:size.h*0.04,
                                width: size.w*0.4,
                                decoration: BoxDecoration(boxShadow: [
                                  BoxShadow(
                                    color: Color(0xff7D7D7D),
                                    spreadRadius: -5,
                                    blurRadius: 7,
                                    offset: Offset(0, 10),
                                  )
                                ],
                                    color: myColors.primary_color,borderRadius: BorderRadius.circular(50)),
                                child: Center(child: Text("Upload",style: TextStyle(color: Colors.white,fontSize: size.text*1,fontFamily: 'Bebas'),)),
                              ),
                            ),
                          ),
                        ),
                      ],

                    ),
                  ),
                  Image(width:size.w*0.28,image: AssetImage('assets/images/Upload_Prescription.png')),
                ],
              ),
            ),
          ),
        ),

        //Best Seling
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Text(
            "Best Selling:",
            style: TextStyle(
                fontSize: size.text*1.2, fontFamily: 'Bebas', color: myColors.primary_color,fontWeight: FontWeight.bold),
          ),
        ),



        //items
        Expanded(
          child: Container(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: instance_all_products_provider
                  .fetchPopularItemsFromFirebase(),
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
                                generic:list[index]['generic'].toString(),
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
                            width: size.w*0.4,
                            height: size.h*0.25,
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
                                  width: size.w*0.5,
                                  height: size.h*0.12,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Icon(Icons.error),
                                ),
                                // Name
                                Text(
                                  list[index]['name'],
                                  style: TextStyle(
                                    fontFamily: "Bebas",
                                    fontSize: size.text*1,
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
                                              fontSize: size.text*0.8),
                                        ),
                                        Text(
                                          "Rs ${list[index]['price']+"/-"}",
                                          style: TextStyle(
                                              fontSize: size.text*0.8, fontFamily: "Bebas"),
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
        ),

      ]),
    );
  }
}
