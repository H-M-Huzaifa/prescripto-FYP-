import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../Utilities/colors.dart';
import '../../../Utilities/screen_size_config.dart';
import '../OrderDetails_screen/order_details_screen.dart';
import 'order_history_provider.dart';

class OrderHistory extends StatefulWidget {
  const OrderHistory({super.key});

  @override
  State<OrderHistory> createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  @override
  void initState() {
    super.initState();
    // Fetch orders when the widget is first created
    Provider.of<OrderHistoryProvider>(context, listen: false).fetchUserOrders();
  }

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
              "Order History",
              style: TextStyle(
                  fontFamily: 'Bebas',
                  fontSize: size.text*1.2,
                  fontWeight: FontWeight.bold,
                  color: myColors.primary_color),
            ),
          ),

          // Order list
          Expanded(
            child: Consumer<OrderHistoryProvider>(
              builder: (context, orderHistoryProvider, child) {
                if (orderHistoryProvider.isLoading) {
                  return Center(child: CircularProgressIndicator());
                }

                if (orderHistoryProvider.orders.isEmpty) {
                  return Center(child: Text("No orders found."));
                }

                return ListView.builder(
                  itemCount: orderHistoryProvider.orders.length,
                  itemBuilder: (context, index) {
                    final order = orderHistoryProvider.orders[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  OrderDetailsScreen(order: order),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: myColors.textSecondary,
                                spreadRadius: 2,
                                blurRadius: 2,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Order #${order['orderNumber']}",
                                    style: TextStyle(
                                        fontFamily: 'Bebas', fontSize: size.text*0.9),
                                  ),
                                  Text("Total: Rs. ${order['totalPrice']}"),
                                  Text(
                                    order['orderDate'] != null
                                        ? "Date: ${DateFormat.yMMMd().format(order['orderDate'].toDate())}"
                                        : "Date: N/A",
                                    style: TextStyle(color: myColors.textSecondary),
                                  ),
                                  Text("Items: ${order['cartItems'].length}"),
                                ],
                              ),
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
        ],
      ),
    );
  }
}

