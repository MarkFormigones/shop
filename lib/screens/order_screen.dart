import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/order.dart';
import '../widgets/order_item.dart' as widgetOrderItem;
import '../widgets/app_drawer.dart';

class OrderScreen extends StatelessWidget {
  static const routeName = '/orders';

Future<void> _refreshOrders(BuildContext context) async {
    await Provider.of<Order>(context, listen: false).getOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshOrders(context),
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (dataSnapshot.error != null) {
              return Center(
                child: Text('An error occured.'),
              );
            } else {
              return Consumer<Order>(
                builder: (ctx, orderData, child) => orderData.getCount == 0
                    ? Center(child: Text('Empty order'))
                    : ListView.builder(
                        itemCount: orderData.orders.length,
                        itemBuilder: (ctx, i) =>
                            widgetOrderItem.OrderItem(orderData.orders[i]),
                      ),
              );
            }
          }
        },
      ),
    );
  }
}
