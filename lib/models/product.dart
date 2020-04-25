import 'package:flutter/material.dart';

class ProductItem {
  final int id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  ProductItem({
      @required this.id,
      @required this.title,
      @required this.description,
      @required this.price,
      @required this.imageUrl,
      this.isFavorite = false});
}

class Product with ChangeNotifier{
 List<ProductItem> _items = [ProductItem(
      id: 1,
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',  
    ),
    ProductItem(
      id: 2,
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    ProductItem(
      id: 3,
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    ProductItem(
      id: 4,
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
      ProductItem(
      id: 5,
      title: 'Shirt',
      description: 'Good looking shirt',
      price: 12.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2017/05/26/07/37/shirt-2345417_960_720.jpg',
    ),
    ];


 List<ProductItem> get items{
   return [..._items];
 }

 int get getCount {
   return items.length;
 }

 ProductItem findbyId(int id){
   return items.firstWhere((prod) => prod.id == id);
 }

List<ProductItem> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

 void toggleFavoriteStatus(ProductItem product) {
    //ProductModel product = items.singleWhere((prod) => prod.id == id);
    product.isFavorite = !product.isFavorite;
    notifyListeners();
  }

   void updateProduct(int id, ProductItem newProduct) {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print('...');
    }
  }

   void addProduct(ProductItem product) {
    final newProduct = ProductItem(
      title: product.title,
      description: product.description,
      price: product.price,
      imageUrl: product.imageUrl,
      id: getCount + 1,
    );
    _items.add(newProduct);
    // _items.insert(0, newProduct); // at the start of the list
    notifyListeners();
  }

 void deleteProduct(int id) {
    _items.removeWhere((prod) => prod.id == id);
    notifyListeners();
  }

}