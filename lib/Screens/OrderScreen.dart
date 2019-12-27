import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/order.dart';
import '../Widgets/orderList.dart';
import '../Screens/AppDrawer.dart';

class OrderScreen extends StatefulWidget {
  static const routName = '/order';

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) {
      Provider.of<Orders>(context).fetchData();
    });
    super.initState();
  }

  Future<void> fetchRefresh(BuildContext context) async{
     await Provider.of<Orders>(context).fetchData();
  }

  @override
  Widget build(BuildContext context) {
    final order = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Order'),
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => fetchRefresh(context),
        child: Container(
          child: ListView.builder(
            itemBuilder: (context, index) => OrderList(order.item[index]),
            itemCount: order.item.length,),
        ),
      ),
    );
  }
}
