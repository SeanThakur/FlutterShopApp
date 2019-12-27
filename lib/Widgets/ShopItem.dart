import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Screens/ProductDetail_Screen.dart';
import '../providers/product_model.dart';
import '../providers/cart.dart';
import '../providers/auth.dart';

class ShopItem extends StatelessWidget {
//  final String id;
//  final String title;
//  final String imgUrl;
//
//  ShopItem(this.id,this.title,this.imgUrl);

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);
    final cart = Provider.of<Cart>(context);
    final authToken = Provider.of<Auth>(context).token;
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: GridTile(
        child: InkWell(
          onTap: () =>  Navigator.of(context).pushNamed(ProductDetailScreen.routName, arguments: product.id),
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: Container(
          color: Colors.black54,
          child: GridTileBar(
            title: Text(product.title),
            leading: IconButton(
              icon: Icon(
                product.isFavroute ? Icons.favorite: Icons.favorite_border ,
                color: Theme.of(context).accentColor,
              ),
              onPressed: () {
                product.favrouteToggle(authToken);
              },
            ),
            trailing: IconButton(
              icon: Icon(
                  Icons.shopping_cart,
                  color: Theme.of(context).accentColor
              ),
              onPressed: () {
                cart.addItem(product.id, product.title, product.price,);
                Scaffold.of(context).hideCurrentSnackBar();
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text('Item is added to cart'),
                  duration: Duration(
                    seconds: 2
                  ),
                  action: SnackBarAction(
                    label: 'UNDO',
                    onPressed: () {
                      cart.RemoveSingle(product.id);
                    },
                  ),
                ));
              },
            ),
          ),
        ),
      ),
    );
  }
}
