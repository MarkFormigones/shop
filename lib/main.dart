import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/localization/demo_localization.dart';
//import './screens/auth_screen.dart';

import 'models/auth.dart';
import 'models/language.dart';
import 'screens/auth_screen.dart';
import 'screens/edit_product_screen.dart';
import 'screens/home_screen.dart';
import 'screens/order_screen.dart';
import 'screens/product_detail_screen.dart';
import 'models/product.dart';
import 'models/cart.dart';
import './screens/cart_screen.dart';
import 'models/order.dart';
import 'screens/profile_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/user_product_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();

  static void setLocale(BuildContext context, Locale locale){
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>();
    state.setLocale(locale);
  }
}

class _MyAppState extends State<MyApp> {
Locale locale;

void setLocale(Locale locale){
  setState(() {
    this.locale = locale;
  });
}

  @override
  void initState() {
    super.initState();
    this._fetchLocale().then((locale) {
      setState(() {
        this.locale = locale;
      });
    });
  }

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
        ChangeNotifierProvider(create: (context) => Language()),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
            locale: locale,
            localizationsDelegates: [
              // ... app-specific localization delegate[s] here
              DemoLocalizationsDelegate(),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: [
              const Locale('en', 'US'), // English
              const Locale('ar', 'AE'), // Arabic UAE
            ],
            localeResolutionCallback: (deviceLocale, supportedLocale) {
              for (var locale in supportedLocale) {
                if (locale.languageCode == deviceLocale.languageCode &&
                    locale.countryCode == deviceLocale.countryCode) {
                  return deviceLocale;
                }
              }
              return supportedLocale.first;
            },
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              accentColor: Colors.grey,
              fontFamily: 'Lato',
            ),
            home: auth.isAuth
                ? HomeScreen()
                : FutureBuilder(
                    future: auth.tryAutoLogin(),
                    builder: (ctx, authResultSnapshot) =>
                        authResultSnapshot.connectionState ==
                                ConnectionState.waiting
                            ? SplashScreen()
                            : AuthScreen(),
                  ),
            routes: {
              AuthScreen.routeName: (ctx) => AuthScreen(),
              ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
              CartScreen.routeName: (ctx) => CartScreen(),
              OrderScreen.routeName: (ctx) => OrderScreen(),
              UserProductScreen.routeName: (ctx) => UserProductScreen(),
              EditProductScreen.routeName: (ctx) => EditProductScreen(),
              ProfileScreen.routeName: (ctx) => ProfileScreen(),
            }),
      ),
    );
  }

 _fetchLocale() async {
    Locale _locale;
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('localeData')) {
      _locale = Locale('en', 'US');
    } else {
      final extractedUserData =
          json.decode(prefs.getString('localeData')) as Map<String, Object>;

      _locale = Locale(extractedUserData['languageCode'], extractedUserData['countryCode']);
    }
    return _locale;
  }
   
}
