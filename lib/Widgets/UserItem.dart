import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Screens/EditProduct_Screen.dart';
import '../providers/products.dart';

class UserItem extends StatelessWidget {

  final String id;
  final String imageUrl;
  final String title;

  UserItem(this.id,this.imageUrl, this.title);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      title: Text(title),
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(
                Icons.edit
              ),
              color: Colors.yellow,
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.routName, arguments: id);
              },
            ),
            IconButton(
              icon: Icon(
                  Icons.delete
              ),
              color: Colors.red,
              onPressed: () {
                Provider.of<Products>(context,listen: false).deleteProduct(id);
              },
            )
          ],
        ),
      ),
    );
  }
}
