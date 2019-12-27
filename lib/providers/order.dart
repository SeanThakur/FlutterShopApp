import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import './cart.dart';

class OrderItem {
  final String id;
  final double amount;
  List<CartItem> product;
  final DateTime date;

  OrderItem({
    this.id,
    this.amount,
    this.product,
    this.date,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _items = [];

  List<OrderItem> get item {
    return [..._items];
  }

  final String authToken;
  Orders(this.authToken, this._items);

  Future<void> fetchData() {

    final url = 'https://shop-921dc.firebaseio.com/Order.json?auth=$authToken';

    return http.get(url)

        .then((response) {

        final extractedData = json.decode(response.body) as Map<String, dynamic>;
        final List<OrderItem> loadedProduct = [];
        if(extractedData == null)
          {
            return;
          }
        extractedData.forEach((orderId, orderData) {
          loadedProduct.add(
            OrderItem(
              id: orderId,
              amount: orderData['amount'],
              date: DateTime.parse(orderData['date']),
              product: (orderData['product'] as List<dynamic>).map((op) => CartItem(
                id: op['id'],
                price: op['price'],
                quantity: op['quantity'],
                title: op['title']
              )).toList(),
            )
          );
        });
        _items = loadedProduct;
        notifyListeners();
    });
  }

  Future<void> addOrder(List<CartItem> cartProduct, double total) {
    final timeStamp = DateTime.now();
    final url = 'https://shop-921dc.firebaseio.com/Order.json';
    return http.post(url,body: json.encode({

      'amount': total,
      'date': timeStamp.toIso8601String(),
      'product': cartProduct.map((cp) => {
        'id' : cp.id,
        'title' : cp.title,
        'price' : cp.price,
        'quantity' : cp.quantity
    }).toList()

    })).then((response) {

      _items.insert(0, OrderItem(
        id: json.decode(response.body)['name'],
        date: timeStamp,
        amount: total,
        product: cartProduct,
      ));

      notifyListeners();
    });
  }
}