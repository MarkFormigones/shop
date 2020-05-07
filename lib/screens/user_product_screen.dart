import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../widgets/user_product_item.dart';
import '../screens/edit_product_screen.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = '/user-products';

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Product>(context, listen: false).getProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    //final productsData = Provider.of<Product>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              //Navigator.of(context).pushNamed(EditProductScreen.routeName);
              //Navigator.of(context).pushNamed(EditProductScreen.routeName);
              //Navigator.pushNamed(context, EditProductScreen.routeName, arguments: EditProductScreen(id: 0,));
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EditProductScreen(
                          id: null,
                        )),
              );
            },
          ),
        ],
      ),
      //drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (dataSnapshot.error != null) {
              return Center(
                child: Text('An error occured.'),
              );
            } else {
              return RefreshIndicator(
                onRefresh: () => _refreshProducts(context),
                child: Consumer<Product>(
                  builder: (ctx, productsData, _) => productsData.getCount == 0
                      ? Padding(
                        padding: EdgeInsets.all(8),
                        child: Container(),
                      )
                      : Padding(
                          padding: EdgeInsets.all(8),
                          child: ListView.builder(
                            itemCount: productsData.items.length,
                            itemBuilder: (_, i) => Column(
                              children: [
                                UserProductItem(
                                  id: productsData.items[i].id,
                                  title: productsData.items[i].title,
                                  imageUrl: productsData.items[i].imageUrl,
                                ),
                                Divider(),
                              ],
                            ),
                          ),
                        ),
                ),
              );
            }
          }
        },
      ),
    );
  }
}
