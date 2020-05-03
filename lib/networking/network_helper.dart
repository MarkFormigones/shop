import 'package:http/http.dart' as http;
import '../models/cart.dart';
import 'dart:convert';
import '../models/product.dart';
import 'package:firebase_storage/firebase_storage.dart'; // For File Upload To Firestore
import 'package:path/path.dart' as Path;
import 'dart:io';

class NetworkHelper {

  final String base = 'https://flutter-update.firebaseio.com/';

  final String authToken;

  NetworkHelper({this.authToken});

  Future<dynamic> getProducts() async {
    String url = base + 'products.json?auth=$authToken';
    var response = await http.get(url);
    return json.decode(response.body);
  }

  Future<dynamic> getProductsByUser(String userId) async {
    String url = base +
        'products.json?auth=$authToken&orderBy="creatorId"&equalTo="$userId"';
    var response = await http.get(url);
    return json.decode(response.body);
  }

  Future<dynamic> addProduct(ProductItem product, String userId) async {
    String url = base + 'products.json?auth=$authToken';

    final response = await http.post(
      url,
      body: json.encode({
        'title': product.title,
        'description': product.description,
        'imageUrl': product.imageUrl,
        'price': product.price,
        'creatorId': userId,
      }),
    );
    return jsonDecode(response.body)['name'];
  }

  Future<void> updateProduct(String id, ProductItem newProduct) async {
    String url = base + 'products/$id.json?auth=$authToken';
    await http.patch(url,
        body: json.encode({
          'title': newProduct.title,
          'description': newProduct.description,
          'imageUrl': newProduct.imageUrl,
          'price': newProduct.price
        }));
  }

  Future<http.Response> deleteProduct(String id) async {
    String url = base + 'products/$id.json?auth=$authToken';
    return await http.delete(url);
  }

  Future<http.Response> toggleFavoriteStatus(
      ProductItem product, String userId) async {
    // String id = product.id;
    // final bool isfavorite = product.isFavorite;

    var url = base + 'userFavorites/$userId/${product.id}.json?auth=$authToken';
    return await http.put(url, body: json.encode(product.isFavorite));
  }

  Future<dynamic> getUserFavorites(String userId) async {
    String url = base + 'userFavorites/$userId.json?auth=$authToken';
    final favoriteResponse = await http.get(url);
    return json.decode(favoriteResponse.body);
  }

  Future<Map<String, dynamic>> getOrders(String userId) async {
    String url = base + 'orders/$userId.json?auth=$authToken';
    var response = await http.get(url);
    return json.decode(response.body);
  }

  Future<dynamic> addOrder(List<CartItem> cartProducts, String userId,
      double total, DateTime timestamp) async {
    String url = base + 'orders/$userId.json?auth=$authToken';
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

  Future<dynamic> authenticate(
      String email, String password, String urlSegment) async {
    final url =
        'https://www.googleapis.com/identitytoolkit/v3/relyingparty/$urlSegment?key=AIzaSyA7XV9iby-D8UCu6RUZ6vYHLZI5tbD9340';
    var response = await http.post(
      url,
      body: json.encode(
        {
          'email': email,
          'password': password,
          'returnSecureToken': true,
        },
      ),
    );
    return json.decode(response.body);
  }

  Future<String> uploadFile(File _file) async {
      StorageReference storageReference = FirebaseStorage.instance
          .ref()
          .child('store/${Path.basename(_file.path)}');
      StorageUploadTask uploadTask = storageReference.putFile(_file);
      await uploadTask.onComplete;
      var response = await storageReference.getDownloadURL();
       print('File Uploaded');
      return response;
  }
}
