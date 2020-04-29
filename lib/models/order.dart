import 'package:flutter/foundation.dart';
import '../networking/network_helper.dart';

import './cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class Order with ChangeNotifier {
  final String authToken;
  final String authUser;


  Order({this.authToken, this.authUser, this.orders});

  List<OrderItem> orders = [];

  List<OrderItem> get orderList {
    return [...orders];
  }

int get getCount {
    if(orders == null){
      return 0;
    }
    return orders.length;
  }


  Future<void> getOrders() async {
    NetworkHelper networkHelper = NetworkHelper(authToken: authToken);
    final extractedData = await networkHelper.getOrders(authUser);
    final List<OrderItem> loadedOrders = [];

    if (extractedData == null) {
      return;
    }
    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(
        OrderItem(
          id: orderId,
          amount: orderData['amount'],
          dateTime: DateTime.parse(orderData['dateTime']),
          products: (orderData['products'] as List<dynamic>)
              .map(
                (item) => CartItem(
                  id: item['id'],
                  price: item['price'],
                  quantity: item['quantity'],
                  title: item['title'],
                ),
              )
              .toList(),
        ),
      );
    });
    orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final timestamp = DateTime.now();
    try {
      NetworkHelper networkHelper =  NetworkHelper(authToken: authToken);
      var response =
          await networkHelper.addOrder(cartProducts, authUser, total, timestamp, );

      orders.insert(
        0,
        OrderItem(
          id: response.toString(),
          amount: total,
          dateTime: timestamp,
          products: cartProducts,
        ),
      );
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }
}
