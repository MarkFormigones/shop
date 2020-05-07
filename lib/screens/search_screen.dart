import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/product.dart';
//import 'package:shop_app/widgets/Products_grid.dart';
import 'package:shop_app/widgets/products_list.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  /// Sentence Text header "Hello i am Treva.........."
  final _keywordController = TextEditingController();

  Future<void> _refreshProducts(BuildContext context) async {
    if (_keywordController.text == "") {
      return;
    }
    await Provider.of<Product>(context, listen: false)
        .getProductsBykeywords(_keywordController.text);
  }

  var _textHello = Padding(
    padding: const EdgeInsets.only(right: 50.0, left: 20.0),
    child: Text(
      "Hello, i am Marshop. What would you like to search ?",
      style: TextStyle(
          letterSpacing: 0.1,
          fontWeight: FontWeight.w600,
          fontSize: 27.0,
          color: Colors.black54,
          fontFamily: "Gotik"),
    ),
  );

  @override
  void dispose() {
    _keywordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Color(0xFF6991C7),
        ),
        title: Text(
          "Search",
          style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 18.0,
              color: Colors.black54,
              fontFamily: "Gotik"),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.only(top: 15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                /// Caliing a variable
                _textHello,
                _search(context),
                //ProductsGrid(isFavorites: false),
                //_sugestedText,
                ProductsList(isFavorites: true),
                Padding(padding: EdgeInsets.only(bottom: 30.0, top: 2.0))
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Item TextFromField Search
  Widget _search(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 35.0, right: 20.0, left: 20.0),
      child: Container(
        height: 50.0,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 15.0,
                  spreadRadius: 0.0)
            ]),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 10.0),
            child: Theme(
              data: ThemeData(hintColor: Colors.transparent),
              child: TextFormField(
                controller: _keywordController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Find you want",
                  hintStyle: TextStyle(
                      color: Colors.black54,
                      fontFamily: "Gotik",
                      fontWeight: FontWeight.w400),
                  icon: IconButton(
                      icon: Icon(
                        Icons.search,
                        color: Color(0xFF6991C7),
                        size: 28.0,
                      ),
                      onPressed: () => _refreshProducts(context)),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
