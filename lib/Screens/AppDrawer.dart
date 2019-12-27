import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './OrderScreen.dart';
import './UserManager_Screen.dart';
import '../providers/auth.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Hello Friends'),
            automaticallyImplyLeading: false,
          ),
          ListTile(
            leading: Icon(
              Icons.shop,
              size: 30.0,
            ),
            title: Text('Shop', style: TextStyle(
              fontSize: 17
            ),),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(
                Icons.folder_special,
              size: 30.0,
            ),
            title: Text('order', style: TextStyle(
                fontSize: 17
            ),),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(OrderScreen.routName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.edit,
              size: 30.0,
            ),
            title: Text('Product Manager', style: TextStyle(
                fontSize: 17
            ),),
            onTap: () {
              Navigator.of(context).pushReplacementNamed(UserManager.routName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.exit_to_app,
              size: 30.0,
            ),
            title: Text('Logout', style: TextStyle(
                fontSize: 17
            ),),
            onTap: () {
              Navigator.of(context).pop();
              Provider.of<Auth>(context).logOut();
            },
          ),
        ],
      ),
    );
  }
}
