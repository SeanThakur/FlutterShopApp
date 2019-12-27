import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String title;
  final double price;
  final double quantity;

  CartItem({
    this.id,
    this.title,
    this.price,
    this.quantity
});
}

class Cart with ChangeNotifier{

  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((prodId, CartItem) {
      total += CartItem.price * CartItem.quantity;
    });
    return total;
  }

  void Clear() {
    _items = {};
    notifyListeners();
  }

  void RemoveSingle(String proId) {
    if(!_items.containsKey(proId))
      {
        return;
      }
    if(_items[proId].quantity >= 1)
      {
        _items.update(proId, (value) => CartItem(
          id: value.id,
          title: value.title,
          price: value.price,
          quantity: value.quantity - 1
        ));
      } else {
      _items.remove(proId);
    }
    notifyListeners();
  }

  void CartRemove(String prodId) {
    _items.remove(prodId);
    notifyListeners();
  }

  void addItem(String prodId, String title, double price)
  {
    if(_items.containsKey(prodId))
      {
        _items.update(prodId, (value) => CartItem(
          id : value.id,
          title: value.title,
          price: value.price,
          quantity: value.quantity + 1,
        ));

      }else {
      _items.putIfAbsent(prodId, () => CartItem(
        id: DateTime.now().toString(),
        title: title,
        price: price,
        quantity: 1,
      ));
    }

    notifyListeners();
  }
}