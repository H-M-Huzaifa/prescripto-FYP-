import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../Utilities/colors.dart';
import '../../../Utilities/screen_size_config.dart';
import '../Bottom_nav_bar/nav_bar.dart';
import '../sign_in&up/signin.dart';

class splash_screen extends StatefulWidget {
  const splash_screen({super.key});

  @override
  State<splash_screen> createState() => _splash_screenState();
}

class _splash_screenState extends State<splash_screen> {
  User? user;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user=FirebaseAuth.instance.currentUser;
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(

          context, MaterialPageRoute(builder: (context) =>  user!=null  ? bottom_nav_bar() : signin()));
    });
  }
  @override
  Widget build(BuildContext context) {
    screen_config size= screen_config(context);
    return Scaffold(
      body: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            colors: [myColors.primary_color, Colors.white],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            //Logo
            Expanded(
              child: Container(
                  decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [
                    // BoxShadow(
                    //     color: Color(0xff7D7D7D),
                    //     spreadRadius: -20,
                    //     blurRadius: 0,
                    //     offset: Offset(-10, 5))
                  ]),
                  child: Image(
                    width: size.w*0.6,
                    image: AssetImage('assets/images/logo.png'),
                  )),
            ),

            //Bottom Text and Image
            Container(
                child: Column(children: [
              Text("powered by",
                  style: TextStyle(fontSize: size.text,color: myColors.tertiary_color,fontFamily: 'Londrina')
                  //GoogleFonts.londrinaSolid(
                    //  color: myColors.text_se, fontSize: 20)
              ),
                  // Image(
                  //   width: size.w*0.5,
                  //   image:AssetImage('assets/images/EB.png'),
                  // ),
            ]
                )
            ),
            
          ],
        ),
      ),
    );
  }
}
