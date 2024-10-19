import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:prescripto/UI/Screens/user_profile_screen/user_profile_provider.dart';
import 'package:provider/provider.dart';

import '../../../Utilities/colors.dart';
import '../../../Utilities/screen_size_config.dart';
import '../Cart/cart_provider.dart';
import '../sign_in&up/signin.dart';
import '../sign_in&up/signup_provider.dart';

class user_profile extends StatefulWidget {
  const user_profile({super.key});

  @override
  State<user_profile> createState() => _user_profileState();
}

class _user_profileState extends State<user_profile> {
  @override
  void initState() {
    super.initState();

    // Fetch user data via provider
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<class_user_profile_provider>(context, listen: false)
          .fetchUserData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screen_config size = screen_config(context);
    final cartProvider = Provider.of<class_cart_provider>(context);

    return Scaffold(
      backgroundColor: myColors.secondary_color,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                // App bar
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        color: myColors.primary_color,
                        Icons.arrow_back_ios_new,
                        size: size.w * 0.06,
                      ),
                      Text(
                        "My Profile",
                        style: TextStyle(
                          fontFamily: 'Bebas',
                          fontSize: size.text * 1.2,
                          fontWeight: FontWeight.bold,
                          color: myColors.primary_color,
                        ),
                      ),
                      Consumer<class_sign_up_provider>(
                        builder: (context, vm, child) {
                          return GestureDetector(
                            onTap: () async {
                              vm.clearImageData();
                              await FirebaseAuth.instance.signOut().then((value) {
                                cartProvider.clearCart();
                              });
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => signin(),
                                ),
                              );
                            },
                            child: Icon(
                              Icons.logout,
                              color: myColors.primary_color,
                              size: size.w * 0.06,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
            
                // Profile Image
                Consumer<class_sign_up_provider>(builder: (context, vm, child) {
                  return Stack(
                    children: [
                      CircleAvatar(
                        maxRadius: size.w * 0.2,
                        backgroundImage: vm.imageUrl != null
                            ? NetworkImage(vm.imageUrl!)
                            : AssetImage('assets/images/avatar.png')
                        as ImageProvider,
                      ),
                      Positioned(
                        right: -10,
                        bottom: 0,
                        child: IconButton(
                          onPressed: () async {
                            // Let the user pick a new image
                            await vm.pickImage();
            
                            // After picking the image, upload and save it to Firestore
                            if (vm.pickedImage != null) {
                              await vm.uploadImageAndSaveToFirestore();
                            }
                          },
                          icon: Icon(Icons.edit),
                        ),
                      ),
                    ],
                  );
                }),
            
                // Text Fields
                Consumer<class_user_profile_provider>(
                  builder: (context, vm, child) {
                    return Container(
                      child: Column(
                        children: [
                          // Name
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 10),
                            child: TextField(
                              controller: vm.nameController,
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(11),
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: myColors.secondary_color,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(11),
                                  borderSide:
                                  BorderSide(width: 2, color: Colors.green),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(11),
                                ),
                                suffixIcon: Icon(Icons.edit),
                                prefixIcon: Icon(
                                  Icons.drive_file_rename_outline,
                                  color: myColors.primary_color,
                                ),
                                hintText: 'Daniel Ritchie',
                                hintStyle:
                                TextStyle(color: myColors.textSecondary),
                                labelText: 'Name',
                                labelStyle: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),

                          // Email
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 10),
                            child: TextField(
                              controller: vm.emailController,
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(11),
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: myColors.secondary_color,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(11),
                                  borderSide:
                                  BorderSide(width: 2, color: Colors.green),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(11),
                                ),
                                suffixIcon: Icon(Icons.edit),
                                prefixIcon: Icon(
                                  Icons.alternate_email,
                                  color: myColors.primary_color,
                                ),
                                hintText: 'abc123@xyz.com',
                                hintStyle:
                                TextStyle(color: myColors.textSecondary),
                                labelText: 'Email',
                                labelStyle: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),

                          // Address
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 10),
                            child: TextField(
                              controller: vm.addressController,
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(11),
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: myColors.secondary_color,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(11),
                                  borderSide:
                                  BorderSide(width: 2, color: Colors.green),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(11),
                                ),
                                suffixIcon: Icon(Icons.edit),
                                prefixIcon: Icon(
                                  Icons.location_on,
                                  color: myColors.primary_color,
                                ),
                                hintText: 'Anywhere North St 123',
                                hintStyle:
                                TextStyle(color: myColors.textSecondary),
                                labelText: 'Address',
                                labelStyle: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),

                          // Phone
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 10),
                            child: TextField(
                              controller: vm.contactController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(11),
                                  borderSide: BorderSide(
                                    width: 1,
                                    color: myColors.secondary_color,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(11),
                                  borderSide:
                                  BorderSide(width: 2, color: Colors.green),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(11),
                                ),
                                suffixIcon: Icon(Icons.edit),
                                prefixIcon: Icon(
                                  Icons.phone_android,
                                  color: myColors.primary_color,
                                ),
                                hintText: '0321-1234567',
                                hintStyle:
                                TextStyle(color: myColors.textSecondary),
                                labelText: 'Contact Number',
                                labelStyle: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
            // Save Button
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: GestureDetector(
                  onTap: () async {
                    await Provider.of<class_user_profile_provider>(context,
                        listen: false)
                        .updateUserData()
                        .then(
                          (value) => ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          duration: Duration(seconds: 2),
                          backgroundColor: myColors.primary_color,
                          content: Center(
                            child: Text(
                              "Profile Updated!",
                              style: TextStyle(
                                  fontSize: size.text * 0.8,
                                  fontFamily: 'Bebas'),
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
                        "Save",
                        style: TextStyle(
                          fontFamily: "Bebas",
                          fontSize: size.text * 1,
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
      ),
    );
  }
}
