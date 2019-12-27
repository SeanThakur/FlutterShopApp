import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Widgets/GridItem.dart';
import '../providers/cart.dart';
import '../providers/products.dart';
import '../Widgets/badge.dart';
import '../Screens/CartScreen.dart';
import '../Screens/AppDrawer.dart';
import '../Screens/CarouselScreen.dart';

enum filterOption {
  Fav,
  all
}

Future<void> fetchData(BuildContext context) async{
  await Provider.of<Products>(context).fetchProduct();
}

class ShopOverview extends StatefulWidget {
  @override
  _ShopOverviewState createState() => _ShopOverviewState();
}

class _ShopOverviewState extends State<ShopOverview> {
  bool isfav = false;
  var isInit = true;
  var isLoading = false;

  @override
  void didChangeDependencies() {
    if(isInit) {
      setState(() {
        isLoading = true;
      });
      Provider.of<Products>(context).fetchProduct().then((_) {
        setState(() {
          isLoading = false;
        });
      });
    }
    isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shop'),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (filterOption selectedValue) {
              setState(() {
                if(selectedValue == filterOption.Fav) {
                  isfav = true;
                }else {
                  isfav = false;
                }
              });
            },
            icon: Icon(Icons.more_vert),
              itemBuilder: (_) => [
                PopupMenuItem(
                  child: Text('My Favroute'),
                  value: filterOption.Fav,
                ),
                PopupMenuItem(
                  child: Text('All Products'),
                  value: filterOption.all,
                )
              ]
          ),
          Consumer<Cart>(
            builder: (_,cart,child) =>Badge(
                value: cart.items.length.toString(),
                child: IconButton(
                  icon: Icon(
                      Icons.shopping_cart
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed(CartScreen.routName);
                  },
                ),
              ),
          )
        ],
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => fetchData(context),
        child: isLoading ?
            Center(
              child: CircularProgressIndicator(),
            )
                :
        ListView(
              children: <Widget>[
                CarouselImage(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Recent Product', style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17.0
                  ),),
                ),
                Container(
                  height: 5000,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GridItem(isfav),
                  ),
                )
              ],
            ),
      ),
    );
  }
}
