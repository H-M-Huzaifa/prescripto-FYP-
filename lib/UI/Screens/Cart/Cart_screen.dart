// import 'package:bake_now/UI/Screens/Cart/cart_provider.dart';
// import 'package:bake_now/UI/Screens/Checkout_Screen/Checkout.dart';
// import 'package:bake_now/Utilities/colors.dart';
// import 'package:bake_now/Utilities/screen_size_config.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// class cart extends StatefulWidget {
//   const cart({super.key});
//
//   @override
//   State<cart> createState() => _cartState();
// }
//
// class _cartState extends State<cart> {
//   @override
//   Widget build(BuildContext context) {
//     screen_config size = screen_config(context);
//     return Scaffold(
//       backgroundColor: myColors.tertiary_color,
//       body: Center(
//         child: Column(
//           children: [
//             //app bar
//             Padding(
//               padding: const EdgeInsets.only(top: 50),
//               child: Text(
//                 "Cart",
//                 style: TextStyle(
//                     fontFamily: 'Bebas',
//                     fontSize: size.text * 1.2,
//                     fontWeight: FontWeight.bold,
//                     color: myColors.secondary_color),
//               ),
//             ),
//             Consumer<class_cart_provider>(
//               builder: (context, vm, child) {
//                 if (vm.cart_items.isEmpty) {
//                   return Expanded(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         Image.asset(
//                           'assets/images/shoppingbag.png', // Replace with your image path
//                         ),
//                         SizedBox(height: 20),
//                         Text(
//                           textAlign: TextAlign.center,
//                           "Hungry for some delicious treats?\nYour bag is empty, but our bakery is full of goodies!",
//                           style: TextStyle(
//                             fontFamily: 'Bebas',
//                             fontSize: size.text * 1.2,
//                             color: myColors.secondary_color,
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 } else {
//                   return Expanded(
//                     child: Column(
//                       children: [
//                         // Cart Items
//                         Expanded(
//                           child: ListView.builder(
//                             itemCount: vm.cart_items.length,
//                             itemBuilder: (context, index) {
//                               return Padding(
//                                 padding: const EdgeInsets.all(12),
//                                 child: Container(
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(20),
//                                     color: Colors.white,
//                                     boxShadow: [
//                                       BoxShadow(
//                                         color: myColors.textSecondary,
//                                         spreadRadius: 2,
//                                         blurRadius: 2,
//                                         offset: Offset(0, 5),
//                                       ),
//                                     ],
//                                   ),
//                                   width: double.infinity,
//                                   height: size.h * 0.14,
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.spaceAround,
//                                     children: [
//                                       Image(
//                                         height: size.h * 0.09,
//                                         image: NetworkImage(vm.cart_items[index]['image']),
//                                         errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
//                                       ),
//                                       Column(
//                                         children: [
//                                           Padding(
//                                             padding: const EdgeInsets.symmetric(vertical: 5.0),
//                                             child: Text(
//                                               vm.cart_items[index]['name'],
//                                               style: TextStyle(
//                                                   color: myColors.secondary_color,
//                                                   fontSize: size.text * 1.2,
//                                                   fontFamily: 'Bebas'),
//                                             ),
//                                           ),
//                                           Padding(
//                                             padding: const EdgeInsets.symmetric(vertical: 5.0),
//                                             child: Text(
//                                               vm.cart_items[index]['size'] + "  x" + vm.cart_items[index]['quantity'].toString(),
//                                               style: TextStyle(
//                                                   color: myColors.textSecondary,
//                                                   fontSize: size.text * 1,
//                                                   fontFamily: 'Bebas'),
//                                             ),
//                                           ),
//                                           Padding(
//                                             padding: const EdgeInsets.symmetric(vertical: 5.0),
//                                             child: Text(
//                                               "Rs " + vm.cart_items[index]['finalprice'].toString() + "/-",
//                                               style: TextStyle(
//                                                   fontWeight: FontWeight.bold,
//                                                   fontSize: size.text * 1,
//                                                   fontFamily: 'Bebas'),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       Padding(
//                                         padding: const EdgeInsets.only(left: 50),
//                                         child: InkWell(
//                                           onTap: () {
//                                             vm.remove_cart_item(vm.cart_items[index]);
//                                           },
//                                           child: Icon(
//                                             Icons.delete,
//                                             size: size.h * 0.027,
//                                             color: myColors.secondary_color,
//                                           ),
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                         // Bottom Section (Total and Checkout Button)
//                         Padding(
//                           padding: const EdgeInsets.only(bottom: 20.0),
//                           child: Column(
//                             children: [
//                               Divider(),
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Padding(
//                                     padding: const EdgeInsets.only(left: 20),
//                                     child: Text(
//                                       "Total",
//                                       style: TextStyle(
//                                           color: myColors.secondary_color,
//                                           fontFamily: "Bebas",
//                                           fontSize: size.text * 1),
//                                     ),
//                                   ),
//                                   Padding(
//                                     padding: const EdgeInsets.only(right: 20),
//                                     child: Text(
//                                       "Rs " + vm.totalprice.toStringAsFixed(0) + "/-",
//                                       style: TextStyle(
//                                           color: myColors.secondary_color,
//                                           fontFamily: "Bebas",
//                                           fontSize: size.text * 1),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               // Checkout Button
//                               GestureDetector(
//                                 onTap: () {
//                                   Navigator.push(context, MaterialPageRoute(builder: (context) => checkout()));
//                                 },
//                                 child: Padding(
//                                   padding: const EdgeInsets.only(top: 10),
//                                   child: Container(
//                                     height: size.h * 0.055,
//                                     width: size.w * 0.7,
//                                     decoration: BoxDecoration(
//                                       boxShadow: [
//                                         BoxShadow(
//                                           color: Color(0xff7D7D7D),
//                                           spreadRadius: -1,
//                                           blurRadius: 7,
//                                           offset: Offset(0, 10),
//                                         )
//                                       ],
//                                       borderRadius: BorderRadius.circular(30),
//                                       color: myColors.primary_color,
//                                     ),
//                                     child: Center(
//                                       child: Text(
//                                         "Checkout",
//                                         style: TextStyle(
//                                             fontFamily: "Bebas",
//                                             fontSize: size.text * 1.2,
//                                             color: myColors.secondary_color),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 }
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
