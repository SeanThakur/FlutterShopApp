import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../Widgets/UserItem.dart';
import '../Screens/AppDrawer.dart';
import '../Screens/EditProduct_Screen.dart';

class UserManager extends StatelessWidget {
  static const routName = '/user_manager';

  Future<void> fetchRefresh(BuildContext context) async{
    await Provider.of<Products>(context).fetchProduct();
  }

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Manage'),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routName);
            },
            icon: Icon(
                Icons.add
            ),
          )
        ],
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => fetchRefresh(context),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView.builder(
            itemBuilder: (context, index) =>  Column(
              children: <Widget>[
                UserItem(
                  productData.items[index].id,
                  productData.items[index].imageUrl,
                  productData.items[index].title,
                ),
                Divider()
              ],
            ),
            itemCount: productData.items.length,
          ),
        ),
      ),
    );
  }
}
