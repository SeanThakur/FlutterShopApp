import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../providers/order.dart';

class OrderList extends StatefulWidget {
  final OrderItem order;
  OrderList(this.order);

  @override
  _OrderListState createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  var _expand = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Card(
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text('\$${widget.order.amount.toStringAsFixed(2)}'),
              subtitle: Text(DateFormat('dd/MM/yyyy').format(widget.order.date)),
              trailing: IconButton(
                icon: Icon(
                    _expand ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down
                ),
                onPressed: () {
                  setState(() {
                    _expand = !_expand;
                  });
                },
              ),
            ),
            if(_expand) Container(
              height: min(widget.order.product.length * 100.0, 100.0),
              child: ListView(
                children: widget.order.product.map((item) => Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(item.title, style: TextStyle(
                          fontSize: 17,
                        ),),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text('${item.quantity} X \$${item.price}', style: TextStyle(
                          fontSize: 17,
                        ),),
                      )
                    ],
                  ),
                )).toList(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
