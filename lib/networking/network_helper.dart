import 'package:http/http.dart' as http;
import '../models/cart.dart';
import 'dart:convert';
import '../models/product.dart';

class NetworkHelper {
  final base = 'https://flutter-store-a469a.firebaseio.com/';

  Future<dynamic> getProducts() async {
    String url = base + 'products.json';
    var response = await http.get(url);
    return json.decode(response.body);
  }

  Future<dynamic> addProduct(ProductItem product) async {
    String url = base + 'products.json';

    final response = await http.post(
      url,
      body: json.encode({
        'title': product.title,
        'description': product.description,
        'imageUrl': product.imageUrl,
        'price': product.price,
        'isFavorite': product.isFavorite,
      }),
    );
    return jsonDecode(response.body)['name'];
  }

  Future<void> updateProduct(String id, ProductItem newProduct) async {
    String url = base + 'products/$id.json';
    await http.patch(url,
        body: json.encode({
          'title': newProduct.title,
          'description': newProduct.description,
          'imageUrl': newProduct.imageUrl,
          'price': newProduct.price
        }));
  }

  Future<http.Response> deleteProduct(String id) async {
    String url = base + 'products/$id.json';
    return await http.delete(url);
  }

  Future<http.Response> toggleFavoriteStatus(ProductItem product) async {
    String url = base + 'products/${product.id}.json';
    return await http.patch(url,
        body: json.encode({
          'isFavorite': product.isFavorite,
        }));
  }

  Future<Map<String, dynamic>> getOrders() async {
    String url = base + 'orders.json';
    var response = await http.get(url);
    return json.decode(response.body);
  }

  Future<dynamic> addOrder(
      List<CartItem> cartProducts, double total, DateTime timestamp) async {
    String url = base + 'orders.json';
    final response = await http.post(
      url,
      body: json.encode({
        'amount': total,
        'dateTime': timestamp.toIso8601String(),
        'products': cartProducts
            .map((cp) => {
                  'id': cp.id,
                  'title': cp.title,
                  'quantity': cp.quantity,
                  'price': cp.price,
                })
            .toList(),
      }),
    );
    return jsonDecode(response.body)['name'];
  }
}
