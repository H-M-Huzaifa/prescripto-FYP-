import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../Utilities/colors.dart';
import '../../../Utilities/screen_size_config.dart';
import '../Bottom_nav_bar/nav_bar.dart';
import '../Cart/Cart_screen.dart';
import '../Cart/cart_provider.dart';
import '../user_profile_screen/user_profile_provider.dart';
import 'checkout_provider.dart';

class checkout extends StatefulWidget {
  const checkout({super.key});

  @override
  State<checkout> createState() => _checkoutState();
}

class _checkoutState extends State<checkout> {
  bool isLoading = false; // State to track loading
  bool? isSelectedCheckbox = false; //To show Progress indicator at button
  @override
  void initState() {
    super.initState();
    final checkoutProvider = Provider.of<class_checkout_provider>(
        context, listen: false);
    final userProfileProvider = Provider.of<class_user_profile_provider>(
        context, listen: false);

    // Fetch user profile info and set it in the checkout form
    checkoutProvider.fetchDeliveryInfo(
      name: userProfileProvider.nameController.text,
      address: userProfileProvider.addressController.text,
      contact: userProfileProvider.contactController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    screen_config size = screen_config(context);

    final checkoutProvider = Provider.of<class_checkout_provider>(context);
    final cartProvider = Provider.of<class_cart_provider>(context);

    return Scaffold(
      backgroundColor: myColors.secondary_color,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space between content and bottom
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  //app bar
                  Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                            onTap: () {},
                            child: GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => cart(),
                                      ));
                                },
                                child: Icon(
                                    size: size.h * 0.027,
                                    color: myColors.primary_color,
                                    Icons.arrow_back_ios_new))),
                        Text(
                          "Checkout",
                          style: TextStyle(
                              fontFamily: 'Bebas',
                              fontSize: size.text * 1.2,
                              fontWeight: FontWeight.bold,
                              color: myColors.primary_color),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => bottom_nav_bar(),
                                ));
                          },
                          child: Icon(
                            Icons.home,
                            color: myColors.primary_color,
                            size: size.h * 0.027,
                          ),
                        ),
                      ],
                    ),
                  ),
                  //Checkout Image
                  Image(
                    width: size.w * 0.5,
                    image: AssetImage('assets/images/checkout.png'),
                  ),
                  //Name, Contact number, Phone, and Checkbox
                  Container(
                    child: Column(
                      children: [
                        // Name, Address, Contact, etc.
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: TextField(
                            controller: checkoutProvider.nameController,
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(11),
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: myColors.primary_color,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(11),
                                  borderSide:
                                  BorderSide(width: 2, color: Colors.blueAccent),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(11),
                                ),
                                prefixIcon: Icon(
                                  Icons.drive_file_rename_outline,
                                  color: myColors.primary_color,
                                ),
                                hintText: 'Daniel Ritchie',
                                hintStyle: TextStyle(color: myColors.textSecondary),
                                labelText: 'Name',
                                labelStyle:
                                TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: TextField(
                            controller: checkoutProvider.addressController,
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(11),
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: myColors.primary_color,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(11),
                                  borderSide:
                                  BorderSide(width: 2, color: Colors.blueAccent),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(11),
                                ),
                                prefixIcon: Icon(
                                  Icons.location_on,
                                  color: myColors.primary_color,
                                ),
                                hintText: 'Anywhere North St 123',
                                hintStyle: TextStyle(color: myColors.textSecondary),
                                labelText: 'Address',
                                labelStyle:
                                TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: TextField(
                            controller: checkoutProvider.contactController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(11),
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: myColors.primary_color,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(11),
                                  borderSide:
                                  BorderSide(width: 2, color: Colors.blueAccent),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(11),
                                ),
                                prefixIcon: Icon(
                                  Icons.phone_android,
                                  color: myColors.primary_color,
                                ),
                                hintText: '0321-1234567',
                                hintStyle: TextStyle(color: myColors.textSecondary),
                                labelText: 'Contact Number',
                                labelStyle:
                                TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ),

                        Row(
                          children: [
                            Checkbox(
                              value: isSelectedCheckbox,
                              onChanged: (value) async {
                                setState(() {
                                  isSelectedCheckbox = value;
                                });

                                if (value == true) {
                                  User? currentUser =
                                      FirebaseAuth.instance.currentUser;
                                  if (currentUser != null) {
                                    String userId = currentUser.uid;
                                    await FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(userId)
                                        .update({
                                      'name': checkoutProvider
                                          .nameController.text,
                                      'address': checkoutProvider
                                          .addressController.text,
                                      'contact': checkoutProvider
                                          .contactController.text,
                                    });
                                  }
                                }
                              },
                            ),
                            Text(
                              "Save this information for future",
                              style: TextStyle(
                                  color: myColors.primary_color,
                                  fontSize: size.text * 0.7,fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          //Total and Order Now button
          Consumer<class_cart_provider>(builder: (context, vm, child) {
            int Delivery_Charges = 200;
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text("Total"),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Text(vm.totalprice.toStringAsFixed(0) + "/-"),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Text("Standard Delivery Charges"),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Text(
                          "200/-",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(
                        "Subtotal",
                        style: TextStyle(
                            color: myColors.primary_color,
                            fontFamily: "Bebas",
                            fontSize: size.text * 1),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Text(
                        "Rs " +
                            (vm.totalprice + Delivery_Charges)
                                .toStringAsFixed(0) +
                            "/-",
                        style: TextStyle(
                            color: myColors.primary_color,
                            fontFamily: "Bebas",
                            fontSize: size.text * 1),
                      ),
                    )
                  ],
                ),
              ],
            );
          }),

          //Order Now Button
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: InkWell(
                onTap: () async {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: myColors.primary_color,
                        ),
                      );
                    },
                  );
                  await checkoutProvider.placeOrder(
                    cartItems: cartProvider.cart_items,
                    totalPrice: cartProvider.totalprice,
                  );
                  Navigator.pop(context);
                  cartProvider.clearCart();

                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor: myColors.secondary_color,
                        icon: Lottie.asset(
                            "assets/animations/checkout_animation.json"),
                        title: Text(
                          "Order Confirmed!",
                          style: TextStyle(fontFamily: 'Bebas', fontSize: size.text*1.2),
                        ),
                        content: Text(textAlign: TextAlign.center,
                          "Your order has been placed successfully.",
                          style: TextStyle(
                              color: myColors.textSecondary,
                              fontFamily: 'Bebas',
                              fontSize: size.text*1),
                        ),
                        actions: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => bottom_nav_bar()));
                            },
                            child: Center(
                              child: Container(
                                height: size.h*0.055,
                                width: size.w*0.7,
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
                                    "ok",
                                    style: TextStyle(
                                      fontFamily: "Bebas",
                                      fontSize: size.text*1,
                                      color: myColors.secondary_color,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Container(
                  height: size.h*0.055,
                  width: size.w*0.7,
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
                      "order now",
                      style: TextStyle(
                        fontFamily: "Bebas",
                        fontSize: size.text*1.2,
                        color: myColors.secondary_color,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}
