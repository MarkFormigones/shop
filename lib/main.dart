import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/auth_screen.dart';

import 'models/auth.dart';
import 'screens/edit_product_screen.dart';
import 'screens/order_screen.dart';
import 'screens/product_detail_screen.dart';
import 'models/product.dart';
import 'models/cart.dart';
import './screens/cart_screen.dart';
import 'models/order.dart';
import 'screens/products_overview_screen.dart';
import 'screens/user_product_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Auth()),
        ChangeNotifierProxyProvider<Auth, Product>(
          create: (context) => Product(),
          update: (_, auth, product) => Product(
            authToken: auth.token,
            authUser: auth.userId,
            items: product == null ? [] : product.items,
          ),
        ),
        ChangeNotifierProvider(create: (context) => Cart()),
        ChangeNotifierProxyProvider<Auth, Order>(
          create: (context) => Order(),
          update: (_, auth, order) => Order(
            authToken: auth.token,
             authUser: auth.userId,
            orders: order == null ? [] : order.orders,
            ),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            accentColor: Colors.grey,
            fontFamily: 'Lato',
          ),
          home: auth.isAuth ? ProductsOverviewScreen() : AuthScreen(),
          routes: {
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrderScreen.routeName: (ctx) => OrderScreen(),
            UserProductScreen.routeName: (ctx) => UserProductScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen(),
          }),
    ),
    );
  }
}
