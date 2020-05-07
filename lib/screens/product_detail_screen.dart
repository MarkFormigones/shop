import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/library/carousel_pro/carousel_pro.dart';
import 'package:shop_app/widgets/products_list.dart';
import '../models/product.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product-detail';

  @override
  Widget build(BuildContext context) {
    final productId =
        ModalRoute.of(context).settings.arguments as String; // is the id!
    final loadedProduct = Provider.of<Product>(
      context,
      listen: false,
    ) //listen used to not rebuild if new product added.
        .findbyId(productId);

    /// Custom Text black
    var _customTextStyle = TextStyle(
      color: Colors.black,
      fontFamily: "Gotik",
      fontSize: 17.0,
      fontWeight: FontWeight.w800,
    );

    var _subHeaderCustomStyle = TextStyle(
        color: Colors.black54,
        fontWeight: FontWeight.w700,
        fontFamily: "Gotik",
        fontSize: 16.0);

    var _detailText = TextStyle(
        fontFamily: "Gotik",
        color: Colors.black54,
        letterSpacing: 0.3,
        wordSpacing: 0.5);

    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        //automaticallyImplyLeading: true,
        title: Text(
          "Product Detail",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.white,
            fontSize: 17.0,
            fontFamily: "Gotik",
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  /// Header image slider
                  Container(
                    height: 300.0,
                    child: Hero(
                      tag: "hero-grid-${loadedProduct.id}",
                      child: Material(
                        child: new Carousel(
                          dotColor: Colors.black26,
                          dotIncreaseSize: 1.7,
                          dotBgColor: Colors.transparent,
                          autoplay: false,
                          boxFit: BoxFit.cover,
                          images: [
                            NetworkImage(loadedProduct.imageUrl),
                            NetworkImage(loadedProduct.imageUrl),
                            NetworkImage(loadedProduct.imageUrl),
                          ],
                        ),
                      ),
                    ),
                  ),

                  /// Background white title,price and ratting
                  Container(
                    decoration: BoxDecoration(color: Colors.white, boxShadow: [
                      BoxShadow(
                        color: Color(0xFF656565).withOpacity(0.15),
                        blurRadius: 1.0,
                        spreadRadius: 0.2,
                      )
                    ]),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0, top: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            loadedProduct.title,
                            style: _customTextStyle,
                          ),
                          Padding(padding: EdgeInsets.only(top: 10.0)),
                          Padding(padding: EdgeInsets.only(top: 5.0)),
                          Text(
                            loadedProduct.price.toString(),
                            style: _customTextStyle,
                          ),
                          Padding(padding: EdgeInsets.only(top: 10.0)),
                          Divider(
                            color: Colors.black12,
                            height: 1.0,
                          ),
                        ],
                      ),
                    ),
                  ),

                  /// Background white for description
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Container(
                      height: 205.0,
                      width: 600.0,
                      decoration:
                          BoxDecoration(color: Colors.white, boxShadow: [
                        BoxShadow(
                          color: Color(0xFF656565).withOpacity(0.15),
                          blurRadius: 1.0,
                          spreadRadius: 0.2,
                        )
                      ]),
                      child: Padding(
                        padding: EdgeInsets.only(top: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Text(
                                "Description",
                                style: _subHeaderCustomStyle,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 15.0,
                                  right: 20.0,
                                  bottom: 10.0,
                                  left: 20.0),
                              child: Text(loadedProduct.description,
                                  style: _detailText),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  ProductsList(isFavorites: false),
                ],
              ),
            ),
          ),

          /// If user click icon chart SnackBar show
          /// this code to show a SnackBar
          /// and Increase a valueItemChart + 1
          InkWell(
            onTap: () {
              // var snackbar = SnackBar(
              //   content: Text("Item Added"),
              // );
              // setState(() {
              //   valueItemChart++;
              // });
              // _key.currentState.showSnackBar(snackbar);
            },
            child: Padding(
              padding: const EdgeInsets.only(bottom: 5.0),
              child: Container(
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                      height: 40.0,
                      width: 60.0,
                      decoration: BoxDecoration(
                          color: Colors.white12.withOpacity(0.1),
                          border: Border.all(color: Colors.black12)),
                      child: Center(
                        child: Image.asset(
                          "assets/icon/shopping-cart.png",
                          height: 23.0,
                        ),
                      ),
                    ),

                    /// Button Pay
                    InkWell(
                      onTap: () {
                        // Navigator.of(context).push(PageRouteBuilder(
                        //     pageBuilder: (_, __, ___) => new delivery()));
                      },
                      child: Container(
                        height: 45.0,
                        width: 200.0,
                        decoration: BoxDecoration(
                          color: Colors.indigoAccent,
                        ),
                        child: Center(
                          child: Text(
                            "Pay",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
