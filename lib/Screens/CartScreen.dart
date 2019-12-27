import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../Widgets/cartList.dart';
import '../providers/order.dart';
import '../Screens/OrderScreen.dart';

class CartScreen extends StatelessWidget {
  static const routName = '/cart';
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Card(
                margin: EdgeInsets.all(10),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: <Widget>[
                      Text('Total :', style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),),
                      Spacer(),
                      Chip(
                        label: Text('\$${cart.totalAmount.toStringAsFixed(2)}', style: TextStyle(
                          fontSize: 20,
                        ),),
                        backgroundColor: Colors.purple,
                      ),
                    SizedBox(
                      width: 20.0,
                    ),
                      RaisedButton(
                        onPressed: cart.totalAmount <=0 ? null : () {
                          Provider.of<Orders>(context).addOrder(cart.items.values.toList(), cart.totalAmount);
                          cart.Clear();
                          Navigator.of(context).pushNamed(OrderScreen.routName);
                          },
                        child: Text('Order now'),
                        textColor: Colors.purple,
                      )
                    ],
                  ),
                ),
              ),
            SizedBox(
              height: 5,
            ),
            Container(
              height: 500,
              child: ListView.builder(
                itemBuilder: (context, index) => CartList(
                  cart.items.values.toList()[index].id,
                  cart.items.keys.toList()[index],
                  cart.items.values.toList()[index].title,
                  cart.items.values.toList()[index].price,
                  cart.items.values.toList()[index].quantity,
                ),
                itemCount: cart.items.length,
              ),
            )
          ],
        ),
      ),
    );
  }
}
