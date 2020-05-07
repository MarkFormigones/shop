
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../widgets/item_list.dart';

class ProductsList extends StatelessWidget{
   final bool isFavorites;

  ProductsList({this.isFavorites});

  @override
  Widget build(BuildContext context) {
     final productsData = Provider.of<Product>(context);
    final products =
        isFavorites ? productsData.favoriteItems : productsData.items.take(5).toList();

    var textData = isFavorites ? "Favorites" : "New Products";   

    return products == null
        ? Center(child: Text('Empty $textData'))
        :Padding(
      padding: const EdgeInsets.only(
          left: 15.0, right: 20.0, top: 30.0, bottom: 20.0),
      child: Container(
        height: 280.0,
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "$textData",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontFamily: "Gotik",
                      fontSize: 15.0),
                ),
                // InkWell(
                //   onTap: () {},
                //   child: Text(
                //     "See All",
                //     style: TextStyle(
                //         color: Colors.indigoAccent.withOpacity(0.8),
                //         fontFamily: "Gotik",
                //         fontWeight: FontWeight.w700),
                //   ),
                // )
              ],
            ),
            Expanded(
              child: 
              
              ListView.builder(
                itemCount: products.length,
                padding: EdgeInsets.only(top: 20.0, bottom: 2.0),
                 scrollDirection: Axis.horizontal,
                itemBuilder: (ctx, i) => ItemList(id: products[i].id,
                ),
              )
              
              // ListView(
              //   padding: EdgeInsets.only(top: 20.0, bottom: 2.0),
              //   scrollDirection: Axis.horizontal,
              //   children: ItemList(id: )
              //   <Widget>[
              //     FavoriteItem(
              //       image: "assets/imgItem/shoes1.jpg",
              //       title: "Firrona Skirt!",
              //       salary: "\$ 10",
              //       rating: "4.8",
              //       sale: "923 Sale",
              //     ),
              //     Padding(padding: EdgeInsets.only(left: 10.0)),
              //     FavoriteItem(
              //       image: "assets/imgItem/acesoris1.jpg",
              //       title: "Arpenaz 4",
              //       salary: "\$ 200",
              //       rating: "4.2",
              //       sale: "892 Sale",
              //     ),
              //     Padding(padding: EdgeInsets.only(left: 10.0)),
              //     FavoriteItem(
              //       image: "assets/imgItem/kids1.jpg",
              //       title: "Mon Cheri Pingun",
              //       salary: "\$ 3",
              //       rating: "4.8",
              //       sale: "110 Sale",
              //     ),
              //     Padding(padding: EdgeInsets.only(left: 10.0)),
              //     FavoriteItem(
              //       image: "assets/imgItem/man1.jpg",
              //       title: "Polo T Shirt",
              //       salary: "\$ 8",
              //       rating: "4.4",
              //       sale: "210 Sale",
              //     ),
              //     Padding(padding: EdgeInsets.only(right: 10.0)),
              //   ],
              // ),
            ),
          ],
        ),
      ),
    );
  }

}