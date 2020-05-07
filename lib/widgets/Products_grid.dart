import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import 'item_grid.dart';

class ProductsGrid extends StatelessWidget {
  final bool isFavorites;

  ProductsGrid({this.isFavorites});

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Product>(context);
    final products =
        isFavorites ? productsData.favoriteItems : productsData.items;

    return products == null
        ? Center(child: Text('Empty products'))
        : GridView.builder(
            physics: ScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            shrinkWrap: true,
            itemCount: products.length,
            itemBuilder: (ctx, i) => ItemGrid(
              id: products[i].id,
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 17.0, //
              childAspectRatio: 0.545,
              crossAxisCount: 2,
            ),
          );
  }
}
