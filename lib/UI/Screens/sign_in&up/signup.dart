import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:prescripto/UI/Screens/sign_in&up/signin.dart';
import 'package:prescripto/UI/Screens/sign_in&up/signup_provider.dart';
import 'package:provider/provider.dart';

import '../../../Utilities/colors.dart';
import '../../../Utilities/screen_size_config.dart';

class signup extends StatefulWidget {
  const signup({super.key});

  @override
  State<signup> createState() => _signupState();
}

class _signupState extends State<signup> {

  //Image Picker
  //String imageURL='';

  //Form validation
  final _formkey = GlobalKey<FormState>();

  //for authentication module
  FirebaseAuth auth = FirebaseAuth.instance;

  //for database module
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  //for accessing currect user
  User? currentuser=FirebaseAuth.instance.currentUser;

  //for showing indicator in create accountbutton while loading
  bool _isloading =false;


  //Text Field Controllers
  TextEditingController name_controller = TextEditingController();
  TextEditingController email_controller = TextEditingController();
  TextEditingController address_controller = TextEditingController();
  TextEditingController contact_controller = TextEditingController();
  TextEditingController Password_controller = TextEditingController();
  TextEditingController confirmPass_controller = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    name_controller.dispose();
    email_controller.dispose();
    address_controller.dispose();
    contact_controller.dispose();
    Password_controller.dispose();
    confirmPass_controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screen_config size=screen_config(context);
    return Scaffold(
      backgroundColor: myColors.secondary_color,
      body: SingleChildScrollView(
        child: Consumer<class_sign_up_provider>(
          builder: (context, vm, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // App bar
                Padding(
                  padding: const EdgeInsets.only(top: 40,bottom: 20),
                  child: Text(
                    "Signup",
                    style: TextStyle(
                      fontFamily: 'Bebas',
                      fontSize: size.text*1.2,
                      fontWeight: FontWeight.bold,
                      color: myColors.primary_color,
                    ),
                  ),
                ),


                //Profile Image
                Consumer<class_sign_up_provider>(builder: (context, vm, child) {
                  return Stack(
                      children:[
                        CircleAvatar(
                          maxRadius: size.h*0.08,
                          backgroundImage: vm.pickedImage != null
                              ? FileImage(File(vm.pickedImage!.path)) // Show the picked image for preview
                              : (vm.imageUrl != null
                              ? NetworkImage(vm.imageUrl!) // Network image if available
                              : AssetImage('assets/images/avatar.png')) as ImageProvider, // Default avatar
                        ),
                        Positioned(right: -10,bottom: 0,child: IconButton(onPressed: (){
                          vm.pickImage();
                        },icon: Icon(Icons.edit),)),
                      ]
                  );

                },
                ),



              //Text Fields
              Container(
                child: Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      //name
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 25),
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Enter Email";
                            } else {
                              return null;
                            }
                          },
                          controller: name_controller,
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
                                BorderSide(width: 1, color: myColors.primary_color),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(11),
                              ),
                              prefixIcon: Icon(
                                Icons.drive_file_rename_outline,
                                color: myColors.primary_color,
                              ),
                              hintText: 'Daniel Ritchie',
                              hintStyle: TextStyle(fontSize: size.text*0.7,color: myColors.textSecondary),
                              labelText: 'Name',
                              labelStyle: TextStyle(fontSize: size.text*0.7,fontWeight: FontWeight.bold)),
                        ),
                      ),

                      //Email
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 25),
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Enter Email";
                            } else {
                              return null;
                            }
                          },
                          controller: email_controller,
                          keyboardType: TextInputType.emailAddress,
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
                                BorderSide(width: 2, color: myColors.primary_color),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(11),
                              ),
                              prefixIcon: Icon(
                                Icons.alternate_email,
                                color: myColors.primary_color,
                              ),
                              hintText: 'abc123@xyz.com',
                              hintStyle: TextStyle(fontSize: size.text*0.7,color: myColors.textSecondary),
                              labelText: 'Email',
                              labelStyle: TextStyle(fontSize: size.text*0.7,fontWeight: FontWeight.bold)),
                        ),
                      ),

                      //Address
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 25),
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Enter Address";
                            } else {
                              return null;
                            }
                          },
                          controller: address_controller,
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
                                BorderSide(width: 2, color: myColors.primary_color),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(11),
                              ),
                              prefixIcon: Icon(
                                Icons.location_on,
                                color: myColors.primary_color,
                              ),
                              hintText: 'Anywhere North St 123',
                              hintStyle: TextStyle(fontSize: size.text*0.7,color: myColors.textSecondary),
                              labelText: 'Address',
                              labelStyle: TextStyle(fontSize: size.text*0.7,fontWeight: FontWeight.bold)),
                        ),
                      ),

                      //Phone
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 25),
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Enter Contact Number";
                            } else {
                              return null;
                            }
                          },
                          controller: contact_controller,
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
                                BorderSide(width: 2, color: myColors.primary_color),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(11),
                              ),
                              prefixIcon: Icon(
                                Icons.phone_android,
                                color: myColors.primary_color,
                              ),
                              hintText: '0321-1234567',
                              hintStyle: TextStyle(fontSize: size.text*0.7,color: myColors.textSecondary),
                              labelText: 'Contact Number',
                              labelStyle: TextStyle(fontSize: size.text*0.7,fontWeight: FontWeight.bold)),
                        ),
                      ),

                      //Password
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 25),
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Enter Password";
                            } else {
                              return null;
                            }
                          },
                          controller: Password_controller,
                          obscureText: !vm.isPasswordVisible,
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
                                BorderSide(width: 2, color: myColors.primary_color),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(11),
                              ),
                              prefixIcon: Icon(
                                Icons.lock,
                                color: myColors.primary_color,
                              ),
                              suffixIconColor: myColors.primary_color,
                              suffixIcon: IconButton(
                                icon: Icon(vm.isPasswordVisible ? Icons.visibility:
                                Icons.visibility_off),
                                onPressed: (){
                                  vm.togglePasswordVisibility();
                                },),
                              hintText: '(0-9)(A-Z)(a-z)(alphanumeric)',
                              hintStyle: TextStyle(fontSize: size.text*0.7,color: myColors.textSecondary),
                              labelText: 'Password',
                              labelStyle: TextStyle(fontSize: size.text*0.7,fontWeight: FontWeight.bold)),
                        ),
                      ),

                      //Confirm Password
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 25),
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Confirm Password";
                            } else {
                              return null;
                            }
                          },
                          controller: confirmPass_controller,
                          obscureText: !vm.isConfirmPasswordVisible,
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
                                BorderSide(width: 2, color: myColors.primary_color),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(11),
                              ),
                              // prefixIcon: Icon(
                              //   Icons.drive_file_rename_outline,
                              //   color: myColors.primary_color,
                              // ),
                              suffixIconColor: myColors.primary_color,
                              suffixIcon:
                              IconButton(
                                icon: Icon(vm.isConfirmPasswordVisible ? Icons.visibility:
                                Icons.visibility_off),
                                onPressed: (){
                                  vm.toggleConfirmPasswordVisibility();
                                },),

                              hintStyle: TextStyle(fontSize: size.text*0.7,color: myColors.textSecondary),
                              labelText: 'Confirm Password',
                              labelStyle: TextStyle(fontSize: size.text*0.7,fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              //or signup with
              // Padding(
              //   padding: const EdgeInsets.all(20),
              //   child: Center(
              //       child: Text(
              //         "or Signup with",
              //         style: TextStyle(fontSize: size.text*0.6,color: myColors.textSecondary),
              //       )),
              // ),
              //
              // //Services Buttons
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   crossAxisAlignment: CrossAxisAlignment.center,
              //   children: [
              //     //google
              //     Padding(
              //       padding: const EdgeInsets.all(10),
              //       child: Container(
              //         height: size.h*0.062,
              //         width: size.w*0.22,
              //         decoration: BoxDecoration(
              //             border: Border.all(color: myColors.textSecondary),
              //             borderRadius: BorderRadius.circular(20),
              //             color: Colors.white),
              //         child: Center(
              //             child: Image(
              //                 width: 25,
              //                 height: 25,
              //                 image: AssetImage('assets/icons/google.png'))),
              //       ),
              //     ),
              //
              //     //facebook
              //     Padding(
              //       padding: const EdgeInsets.all(10),
              //       child: Container(
              //         height: size.h*0.062,
              //         width: size.w*0.22,
              //         decoration: BoxDecoration(
              //             border: Border.all(color: myColors.textSecondary),
              //             borderRadius: BorderRadius.circular(20),
              //             color: Colors.white),
              //         child: Center(
              //             child: Image(
              //                 width: 25,
              //                 height: 25,
              //                 image:
              //                 AssetImage('assets/icons/facebook.png'))),
              //       ),
              //     ),
              //   ],
              // ),

              //Create Account
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: GestureDetector(
                      onTap: () async {
                        // First, validate the form
                        if (_formkey.currentState!.validate()) {
                          // Now, check if passwords match
                          if (confirmPass_controller.text.trim() == Password_controller.text.trim()) {
                            setState(() {
                              _isloading = true; // Show loading indicator
                            });
                            try {
                              // Create the user
                              await auth.createUserWithEmailAndPassword(
                                email: email_controller.text.trim(),
                                password: Password_controller.text.trim(),
                              ).then((value) async {
                                // Fetch the current user (after sign-up)
                                User? currentUser = auth.currentUser;

                                if (currentUser != null) {
                                  // First, upload the image (if selected)
                                  if (vm.pickedImage != null) {
                                    await vm.uploadImageAndSaveToFirestore();
                                  }

                                  // Save user data to Firestore
                                  await firestore.collection('users').doc(currentUser.uid).set({
                                    'name': name_controller.text.trim(),
                                    'email': email_controller.text.trim(),
                                    'address': address_controller.text.trim(),
                                    'contact': contact_controller.text.trim(),
                                    'created at': DateTime.now(),
                                    'user ID': currentUser.uid,
                                    'image': vm.imageUrl,
                                    'role':"user",
                                  });

                                  setState(() {
                                    _isloading = false; // Hide loading indicator
                                  });

                                  // Navigate to the sign-in screen
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => signin(),
                                    ),
                                  );

                                  // Show success message
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    duration: Duration(seconds: 2),
                                    backgroundColor: myColors.snackbar,
                                    content: Center(
                                      child: Text(
                                        "Account Created Successfully!",
                                        style: TextStyle(fontSize: size.text*0.8, fontFamily: 'Bebas'),
                                      ),
                                    ),
                                  ));
                                } else {
                                  // Handle error if user is not available after sign-up
                                  setState(() {
                                    _isloading = false; // Hide loading indicator
                                  });

                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    duration: Duration(seconds: 2),
                                    backgroundColor: myColors.snackbar,
                                    content: Center(
                                      child: Text(
                                        "User creation failed!",
                                        style: TextStyle(fontSize: size.text*0.8, fontFamily: 'Bebas'),
                                      ),
                                    ),
                                  ));
                                }
                              }).onError((error, stackTrace) {
                                setState(() {
                                  _isloading = false; // Hide loading indicator
                                });

                                // Show error message
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  duration: Duration(seconds: 2),
                                  backgroundColor: myColors.snackbar,
                                  content: Center(
                                    child: Text(
                                      error.toString(),
                                      style: TextStyle(fontSize: size.text*0.8, fontFamily: 'Bebas'),
                                    ),
                                  ),
                                ));
                              });
                            } catch (e) {
                              setState(() {
                                _isloading = false; // Hide loading indicator
                              });

                              // Show error message
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                duration: Duration(seconds: 2),
                                backgroundColor: myColors.snackbar,
                                content: Center(
                                  child: Text(
                                    e.toString(),
                                    style: TextStyle(fontSize: size.text*0.8, fontFamily: 'Bebas'),
                                  ),
                                ),
                              ));
                            }
                          } else {
                            // Passwords don't match
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              duration: Duration(seconds: 2),
                              backgroundColor: myColors.snackbar,
                              content: Center(
                                child: Text(
                                  "Password Didn't Matched!",
                                  style: TextStyle(fontSize: size.text*0.8, fontFamily: 'Bebas'),
                                ),
                              ),
                            ));
                          }
                        } else {
                          // Form validation failed
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            duration: Duration(seconds: 2),
                            backgroundColor: myColors.snackbar,
                            content: Center(
                              child: Text(
                                "Please Fill in the Required Fields",
                                style: TextStyle(fontSize: size.text*0.8, fontFamily: 'Bebas'),
                              ),
                            ),
                          ));
                        }
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
                            ),
                          ],
                          borderRadius: BorderRadius.circular(30),
                          color: myColors.primary_color,
                        ),
                        child: Center(
                          child: _isloading
                              ? CircularProgressIndicator()
                              : Text(
                            "Create Account",
                            style: TextStyle(
                              fontFamily: "Bebas",
                              fontSize: size.text*1,
                              color: myColors.tertiary_color,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),



                //Already have an account
              Padding(
                padding: const EdgeInsets.all(20),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => signin(),
                        ));
                  },
                  child: RichText(
                      text: TextSpan(children: [
                        TextSpan(
                            text: "Already have an account? ",
                            style: TextStyle(fontSize: size.text*0.6, color: myColors.textSecondary)),
                        TextSpan(
                            text: "Login",
                            style: TextStyle(
                                fontSize: size.text*0.8,
                                color: myColors.primary_color,
                                fontWeight: FontWeight.bold))
                      ])),
                ),
              )
            ],
          );
        },
        ),
      ),
    );
  }
}
