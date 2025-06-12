import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prescripto/UI/Screens/Bottom_nav_bar/nav_bar.dart';
import 'package:prescripto/UI/Screens/all_products/all_products_provider.dart';
import 'package:prescripto/UI/Screens/home_screen/home_screen.dart';
import 'package:prescripto/UI/Screens/results_screen/medicine_matcher_provider.dart';
import 'package:prescripto/UI/Screens/splash_screen/splash_screen.dart';
import 'package:provider/provider.dart';

import 'UI/Screens/Cart/cart_provider.dart';
import 'UI/Screens/Checkout_Screen/checkout_provider.dart';
import 'UI/Screens/Product_Description_Screen/product_description_provider.dart';
import 'UI/Screens/favourites_screen/fav_provider.dart';
import 'UI/Screens/home_screen/home_screen_provider.dart';
import 'UI/Screens/order_history_screen/order_history_provider.dart';
import 'UI/Screens/sign_in&up/signin_provider.dart';
import 'UI/Screens/sign_in&up/signup_provider.dart';
import 'UI/Screens/user_profile_screen/user_profile_provider.dart';
import 'Utilities/colors.dart';

void main()async{

  //lock screen oreintation
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => class_fav_provider()),
          ChangeNotifierProvider(create: (_) => class_homescreen_provider()),
          ChangeNotifierProvider(create: (_) => class_cart_provider()),
          ChangeNotifierProvider(create: (_) => class_prod_desc()),
          ChangeNotifierProvider(create: (_) => class_sign_up_provider()),
          ChangeNotifierProvider(create: (_) => class_sign_in_provider()),
          ChangeNotifierProvider(create: (_) => class_user_profile_provider()),
          ChangeNotifierProvider(create: (_) => class_checkout_provider()),
          ChangeNotifierProvider(create: (_) => OrderHistoryProvider()),
          ChangeNotifierProvider(create: (_) => class_all_products_provider()),
          ChangeNotifierProvider(create: (_) => MedicineMatcherProvider()),

        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Prescripto',
          theme: ThemeData(
            // This is the theme of your application.
            //
            // TRY THIS: Try running your application with "flutter run". You'll see
            // the application has a purple toolbar. Then, without quitting the app,
            // try changing the seedColor in the colorScheme below to Colors.green
            // and then invoke "hot reload" (save your changes or press the "hot
            // reload" button in a Flutter-supported IDE, or press "r" if you used
            // the command line to start the app).
            //
            // Notice that the counter didn't reset back to zero; the application
            // state is not lost during the reload. To reset the state, use hot
            // restart instead.
            //
            // This works for code too, not just values: Most code changes can be
            // tested with just a hot reload.
            colorScheme: ColorScheme.fromSeed(seedColor: myColors.primary_color),
            useMaterial3: true,
          ),
          home: splash_screen(),
        ));
  }
}

