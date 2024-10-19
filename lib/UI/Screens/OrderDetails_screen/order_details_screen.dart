import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../Utilities/colors.dart';
import '../../../Utilities/screen_size_config.dart';

class OrderDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> order;

  const OrderDetailsScreen({required this.order});

  @override
  Widget build(BuildContext context) {
    screen_config size=screen_config(context);
    return Scaffold(
      backgroundColor: myColors.secondary_color,
      body: Column(
        children: [
          // Appbar-like header
          Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Text(
              "Order #${order['orderNumber']}",
              style: TextStyle(
                  fontFamily: 'Bebas',
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: myColors.primary_color),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: order['cartItems'].length,
              itemBuilder: (context, index) {
                final item = order['cartItems'][index];
                return ListTile(
                  title: Text(item['name']),
                  trailing: Image.network(item['image']),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Price: Rs. ${item['price']}"),
                      Text("Quantity: ${item['quantity']}"),
                      // Add code to display item image here (if available)
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
