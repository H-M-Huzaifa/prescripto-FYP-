import 'package:awesome_bottom_bar/widgets/inspired/inspired.dart';
import 'package:flutter/material.dart';
import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:prescripto/UI/Screens/all_products/all_products.dart';

import '../../../Utilities/colors.dart';
import '../favourites_screen/fav_screen.dart';
import '../home_screen/home_screen.dart';
import '../order_history_screen/order_history.dart';
import '../user_profile_screen/user_profile.dart';

class bottom_nav_bar extends StatefulWidget {
  const bottom_nav_bar({super.key});

  @override
  State<bottom_nav_bar> createState() => _bottom_nav_barState();
}

class _bottom_nav_barState extends State<bottom_nav_bar> {
  List<Widget> Screens = [
    favourite_screen(),
    all_products(),
    home_screen(),
    OrderHistory(),
    user_profile(),
  ];

  int selectedstate = 2;

  List<TabItem> items = [
    TabItem(
      icon: Icons.favorite_border,
      title: 'Favourite',
    ),
    TabItem(
      icon: Icons.list,
      title: 'All Products',
    ),
    TabItem(
      icon: Icons.home,
      title: 'Home',
    ),
    TabItem(
      icon: Icons.history,
      title: 'History',
    ),
    TabItem(
      icon: Icons.account_box,
      title: 'Profile',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: selectedstate, children: Screens),
      bottomNavigationBar: BottomBarInspiredOutside(
        items: items,
        backgroundColor: myColors.primary_color,
        color: Colors.white,
        colorSelected: Colors.white,
        indexSelected: selectedstate,
        onTap: (index) => setState(() {
          selectedstate = index;
        }),
        chipStyle: const ChipStyle(
          color: Colors.red,
          background: myColors.primary_color,
          convexBridge: false,
          notchSmoothness: NotchSmoothness.sharpEdge,
        ),
        itemStyle: ItemStyle.circle,
        isAnimated: true,
        animated: true,
      ),
    );
  }
}
