
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:prescripto/UI/Screens/sign_in&up/signin_provider.dart';
import 'package:prescripto/UI/Screens/sign_in&up/signup.dart';
import 'package:prescripto/UI/Screens/sign_in&up/signup_provider.dart';
import 'package:provider/provider.dart';

import '../../../Utilities/colors.dart';
import '../../../Utilities/screen_size_config.dart';
import '../Bottom_nav_bar/nav_bar.dart';

class signin extends StatefulWidget {
  const signin({super.key});

  @override
  State<signin> createState() => _signinState();
}

class _signinState extends State<signin> {
  final _formkey = GlobalKey<FormState>();
  FirebaseAuth auth = FirebaseAuth.instance;
  //for showing indicator in login button while loading
  bool _isloading =false;

  TextEditingController email_controller = TextEditingController();
  TextEditingController password_controller = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    email_controller.dispose();
    password_controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screen_config size=screen_config(context);
    return Scaffold(
      backgroundColor: myColors.secondary_color,
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formkey,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //logo
                  Padding(
                    padding: const EdgeInsets.only(bottom: 40),
                    child: Center(
                      child: Container(
                          decoration:
                              BoxDecoration(shape: BoxShape.circle, boxShadow: [
                            BoxShadow(
                                color: Color(0xff7D7D7D),
                                spreadRadius: -20,
                                blurRadius: 0,
                                offset: Offset(-12, 6))
                          ]),
                          child: Image(
                            //height: size.h*0.6,
                            width: size.w*0.5,
                            image: AssetImage('assets/images/logo.png'),
                          )),
                    ),
                  ),

                  //Login
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 25),
                    child: Text(
                      "Login",
                      style: TextStyle(
                          fontFamily: 'Bebas',
                          fontSize: size.text*1.2,
                          fontWeight: FontWeight.bold,
                          color: myColors.secondary_color),
                    ),
                  ),

                  //email
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 35),
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
                        prefixIconColor: myColors.primary_color,
                        prefixIcon: Icon(Icons.alternate_email_outlined),
                        hintText: "Email ID",
                        hintStyle: TextStyle(fontSize: size.text*0.6)
                      ),
                    ),
                  ),

                  //password
                  Consumer<class_sign_in_provider>(
                    builder: (context, vm, child) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 35),
                        child: TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Enter Password";
                            } else {
                              return null;
                            }
                          },
                          controller: password_controller,
                          obscureText: !vm.isPasswordVisible,
                          decoration: InputDecoration(
                            suffixIconColor: myColors.primary_color,
                            suffixIcon: IconButton(
                              icon: Icon(vm.isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                              onPressed: () {
                                vm.togglePasswordVisibility();
                              },
                            ),
                            prefixIconColor: myColors.primary_color,
                            prefixIcon: Icon(Icons.lock),
                            hintText: "Password",
                              hintStyle: TextStyle(fontSize: size.text*0.6)
                          ),
                        ),
                      );
                    },
                  ),

                  SizedBox(
                    height: size.h*0.05,
                  ),

                  //Login Button
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Center(
                      child: GestureDetector(
                        onTap: ()async {
                          if(_formkey.currentState!.validate()){
                            try{
                              await auth.signInWithEmailAndPassword(
                                  email: email_controller.text.trim(),
                                  password: password_controller.text.trim()).then((value) {
                                setState(() {
                                  _isloading = true; // Show loading indicator
                                });
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => bottom_nav_bar(),
                                    ));
                              });
                            }catch(e){
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(duration: Duration(seconds: 2),
                                  backgroundColor: myColors.primary_color,
                                  content: Center(
                                      child: Text(
                                        e.toString(),
                                        style:
                                        TextStyle(fontSize: size.text*0.8, fontFamily: 'Bebas'),
                                      ))));
                            }

                          }else{
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(duration: Duration(seconds: 2),
                                backgroundColor: myColors.primary_color,
                                content: Center(
                                    child: Text(
                                      "Please Fill in the Required Fields",
                                      style:
                                      TextStyle(fontSize: size.text*0.8, fontFamily: 'Bebas'),
                                    ))));
                          }
                        },
                        child: Container(
                          height: size.h*0.055,
                          width: size.w*0.7,
                          decoration: BoxDecoration(boxShadow: [
                            BoxShadow(
                              color: Color(0xff7D7D7D),
                              spreadRadius: -1,
                              blurRadius: 3,
                              offset: Offset(0, 10),
                            )
                          ],
                              color: myColors.primary_color,
                              borderRadius: BorderRadius.circular(50)),

                          child: Center(
                              child:_isloading? CircularProgressIndicator(): Text(
                            "Login",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: size.text*0.9 ,
                                fontFamily: 'Bebas'),
                          )),
                        ),
                      ),
                    ),
                  ),

                  //or login with
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Center(
                        child: Text(
                      "or login with",
                      style: TextStyle(fontSize: size.text*0.6,color: myColors.textSecondary),
                    )),
                  ),

                  //Services Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      //google
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Container(
                          height: size.h*0.062,
                          width: size.w*0.22,
                          decoration: BoxDecoration(
                              border: Border.all(color: myColors.textSecondary),
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white),
                          child: Center(
                              child: Image(
                                  width: size.w*0.07,
                                  height: size.h*0.05,
                                  image: AssetImage('assets/icons/google.png'))),
                        ),
                      ),

                      //facebook
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Container(
                          height: size.h*0.062,
                          width: size.w*0.22,
                          decoration: BoxDecoration(
                              border: Border.all(color: myColors.textSecondary),
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white),
                          child: Center(
                              child: Image(
                                  width: size.w*0.07,
                                  height: size.h*0.05,
                                  image:
                                      AssetImage('assets/icons/facebook.png'))),
                        ),
                      ),
                    ],
                  ),

                  //New to this platform
                  Consumer<class_sign_up_provider>(builder: (context, vm, child) {
                  return Padding(
                      padding: const EdgeInsets.all(20),
                      child: InkWell(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                // Clear the provider's image data before navigating to the sign-up screen
                                vm.clearImageData();
                                return signup(); // Your sign-up screen widget
                              },
                            ),
                          );
                        },
                        child: RichText(
                            text: TextSpan(children: [
                          TextSpan(
                              text: "New to this platform? ",
                              style: TextStyle(fontSize: size.text*0.6, color: myColors.textSecondary)),
                          TextSpan(
                              text: "Signup",
                              style: TextStyle(
                                  fontSize: size.text*0.8,
                                  color: myColors.primary_color,
                                  fontWeight: FontWeight.bold))
                        ])),
                      ),
                    );
                  }
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
