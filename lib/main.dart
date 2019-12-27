
import 'package:dataprovider/providers/order.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'providers/auth.dart';
import 'providers/products.dart';
import 'providers/cart.dart';
import 'providers/order.dart';
import 'Screens/ShopOverview_Screen.dart';
import 'Screens/ProductDetail_Screen.dart';
import 'Screens/CartScreen.dart';
import 'Screens/OrderScreen.dart';
import 'Screens/UserManager_Screen.dart';
import 'Screens/EditProduct_Screen.dart';
import 'Screens/authentication_Screen.dart';

void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
            value: Auth()
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          update:(context,auth,products) => Products(auth.token, products == null ? [] : products.items),
        ),
//        ChangeNotifierProvider.value(
//          value: Products(),
//        ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
         ChangeNotifierProxyProvider<Auth, Orders>(
           update: (context,auth,orders) => Orders(auth.token, orders == null ? [] : orders.item),
         )
//        ChangeNotifierProvider.value(
//            value: Orders()
//        ),
      ],
      child: Consumer<Auth>(
        builder: (context,auth,_) => MaterialApp(
          theme: ThemeData(
              primarySwatch: Colors.purple,
              accentColor: Colors.yellow
          ),
          debugShowCheckedModeBanner: false,
          home: auth.isAuth ? ShopOverview() : AuthScreen(),
          routes: {
            ProductDetailScreen.routName: (context) => ProductDetailScreen(),
            CartScreen.routName : (context) => CartScreen(),
            OrderScreen.routName : (context) => OrderScreen(),
            UserManager.routName : (context) => UserManager(),
            EditProductScreen.routName : (context) => EditProductScreen(),
          },
        ),
      ),
    );
  }
}
