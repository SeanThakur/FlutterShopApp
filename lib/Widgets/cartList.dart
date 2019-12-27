import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';

class CartList extends StatelessWidget {

  final String id;
  final String prodId;
  final String title;
  final double price;
  final double quantity;

  CartList(this.id, this.prodId, this.title, this.price, this.quantity);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      direction: DismissDirection.startToEnd,
      confirmDismiss: (direction) {
        return showDialog(context: context, builder: (context) => AlertDialog(
          content: Text('Do you want to remove from this cart?'),
          title: Text('Are you Sure'),
          actions: <Widget>[
            FlatButton(
              child: Text('Okay', style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold
              ),),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
            FlatButton(
              child: Text('Cancel', style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold
              ),),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            )
          ],
        ));
      },
      onDismissed: (direction) {
        Provider.of<Cart>(context).CartRemove(prodId);
      },
      background: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(10),
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 30.0,
        ),
        alignment: Alignment.centerLeft,
        color: Colors.red,
      ),
      child: Card(
        margin: EdgeInsets.all(10),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text('\$${price.toStringAsFixed(2)}'),
              ),
              radius: 40,
            ),
            title: Text(title),
            subtitle: Text('${price} X ${quantity}'),
            trailing: Text('X ${quantity} '),
          ),
        ),
      ),
    );
  }
}
