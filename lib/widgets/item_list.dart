import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//import '../models/cart.dart';
import '../models/product.dart';

/// Class for card product in "Top Rated Products"
class ItemList extends StatelessWidget {
  final String id;

  ItemList({this.id});

  @override
  Widget build(BuildContext context) {
    final loadedProduct = Provider.of<Product>(
      context,
      listen: false,
    ).findbyId(id);
    //final cart = Provider.of<Cart>(context, listen: false);

    //MediaQueryData mediaQueryData = MediaQuery.of(context);
    return Padding(
      padding: const EdgeInsets.only(left: 15.0),
      
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            boxShadow: [
              BoxShadow(
                color: Color(0xFF656565).withOpacity(0.15),
                blurRadius: 4.0,
                spreadRadius: 1.0,
//           offset: Offset(4.0, 10.0)
              )
            ]),
        child: Wrap(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  height: 150.0,
                  width: 150.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(7.0),
                          topRight: Radius.circular(7.0)),
                      image: DecorationImage(
                          image: NetworkImage(loadedProduct.imageUrl), fit: BoxFit.cover)),
                ),
                Padding(padding: EdgeInsets.only(top: 15.0)),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Text(
                    loadedProduct.title,
                    style: TextStyle(
                        letterSpacing: 0.5,
                        color: Colors.black54,
                        fontFamily: "Sans",
                        fontWeight: FontWeight.w500,
                        fontSize: 13.0),
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 1.0)),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Text(
                    loadedProduct.price.toString(),
                    style: TextStyle(
                        fontFamily: "Sans",
                        fontWeight: FontWeight.w500,
                        fontSize: 14.0),
                  ),
                ),
                // Padding(
                //   padding:
                //       const EdgeInsets.only(left: 15.0, right: 15.0, top: 5.0),
                //   child: Row(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: <Widget>[
                //      IconButton(
                //         icon: Icon(
                //           loadedProduct.isFavorite
                //               ? Icons.favorite
                //               : Icons.favorite_border,
                //         ),
                //         color: Theme.of(context).accentColor,
                //         onPressed: () async {
                //           try {
                //             await Provider.of<Product>(context, listen: false)
                //                 .toggleFavoriteStatus(loadedProduct);
                //           } catch (error) {
                //             Scaffold.of(context).showSnackBar(
                //               SnackBar(
                //                 content: Text(
                //                   'Set Favorite failed!',
                //                   textAlign: TextAlign.center,
                //                 ),
                //               ),
                //             );
                //           }
                //         },
                //       ),
                //       IconButton(
                //         icon: Icon(
                //           Icons.shopping_cart,
                //         ),
                //         onPressed: () {
                //           cart.addItem(
                //               loadedProduct.id, loadedProduct.price, loadedProduct.title);
                //         },
                //         color: Theme.of(context).accentColor,
                //       ),
                //     ],
                //   ),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
