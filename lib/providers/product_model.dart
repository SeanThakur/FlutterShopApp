import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

// ignore: camel_case_types
class Product with ChangeNotifier{
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavroute;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.imageUrl,
    this.isFavroute = false,
    @required this.price
});

  Future<void> favrouteToggle(String token) {
    // ignore: unnecessary_statements
    //First Three line of code for the optimal favroute which shown in the frontend
    var oldcatch = isFavroute;
    isFavroute = !isFavroute;
    notifyListeners();
    //Last three line of code for the change in the data server
    final url = 'https://shop-921dc.firebaseio.com/Product/$id.json?auth=$token';
    return http.patch(url,body: json.encode({
      'isFavroute': isFavroute,
    })).catchError((error) {
      isFavroute = oldcatch;
    });
  }
}