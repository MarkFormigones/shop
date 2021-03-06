import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cart.dart';
import '../models/product.dart';
import '../screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  final String id;
  // final String title;
  // final String imageUrl;

  //ProductItem(this.id, this.title, this.imageUrl);
  ProductItem(this.id);

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context).findbyId(id);
    final cart = Provider.of<Cart>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailScreen.routeName,
              arguments: product.id,
            );
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: IconButton(
            icon: Icon(
              product.isFavorite ? Icons.favorite : Icons.favorite_border,
            ),
            color: Theme.of(context).accentColor,
            onPressed: () async {
              try {
                await Provider.of<Product>(context, listen: false)
                    .toggleFavoriteStatus(product);
              } catch (error) {               
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Set Favorite failed!',
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }
            },
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.shopping_cart,
            ),
            onPressed: () {
              cart.addItem(product.id, product.price, product.title);
            },
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
    );
  }
}
