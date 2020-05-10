import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/widgets/Products_grid.dart';
import '../library/carousel_pro/src/carousel_pro.dart';
import '../models/product.dart';
import '../widgets/app_drawer.dart';
import 'cart_screen.dart';
import 'search_screen.dart';

enum FilterOptions {
  Favorites,
  All,
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _isInit = true;
  var _showOnlyFavorites = false;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Product>(context).getProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
      _isInit = false;
      super.didChangeDependencies();
    }
  }

  void _refreshProducts() {
    //await Provider.of<Product>(context, listen: false).getProducts(true);
    setState(() {
      _isLoading = true;
    });
    Provider.of<Product>(context, listen: false).getProducts().then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  Future<void> _clearProductsCache(BuildContext context) async {
    await Provider.of<Product>(context, listen: false).deleteCacheProducts();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Favorites) {
                  _showOnlyFavorites = true;
                } else {
                  _showOnlyFavorites = false;
                }
              });
            },
            icon: Icon(
              Icons.more_vert,
            ),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Only Favorites'),
                value: FilterOptions.Favorites,
              ),
              PopupMenuItem(
                child: Text('Show All'),
                value: FilterOptions.All,
              ),
            ],
          ),
          IconButton(
            icon: Icon(
              Icons.shopping_cart,
            ),
            onPressed: () {
              Navigator.of(context).pushNamed(CartScreen.routeName);
            },
          ),
          IconButton(
            icon: Icon(
              Icons.search,
            ),
            onPressed: () async {

              await _clearProductsCache(context);  
              Navigator.of(context)
                  .push(PageRouteBuilder(
                      pageBuilder: (_, __, ___) => SearchScreen(),

                      /// transtation duration in animation
                      transitionDuration: Duration(milliseconds: 750),

                      /// animation route to search layout
                      transitionsBuilder:
                          (_, Animation<double> animation, __, Widget child) {
                        return Opacity(
                          opacity: animation.value,
                          child: child,
                        );
                      }))
                  .then((_) {
                _refreshProducts();
              });
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Stack(children: <Widget>[
              SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      imageSlider,
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, top: 20.0),
                        child: Text(
                          "Recomended",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 17.0,
                          ),
                        ),
                      ),
                      ProductsGrid(isFavorites: _showOnlyFavorites),
                    ]),
              ),
            ]),
    );
  }
}

/// ImageSlider in header
var imageSlider = Container(
  height: 182.0,
  child: new Carousel(
    boxFit: BoxFit.cover,
    dotColor: Color(0xFFFFF).withOpacity(0.8),
    dotSize: 5.5,
    dotSpacing: 16.0,
    dotBgColor: Colors.transparent,
    showIndicator: true,
    overlayShadow: true,
    overlayShadowColors: Colors.white.withOpacity(0.9),
    overlayShadowSize: 0.9,
    images: [
      AssetImage("assets/img/baner1.png"),
      AssetImage("assets/img/baner12.png"),
      AssetImage("assets/img/baner2.png"),
      AssetImage("assets/img/baner3.png"),
      AssetImage("assets/img/baner4.png"),
    ],
  ),
);
