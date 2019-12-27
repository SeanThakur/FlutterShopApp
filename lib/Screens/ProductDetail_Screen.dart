import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../providers/cart.dart';
import '../providers/auth.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routName = '/product_Detail';

//  final String id;
//  final String title;
//  ProductDetailScreen(this.id, this.title);

  @override
  Widget build(BuildContext context) {
    final productsId = ModalRoute.of(context).settings.arguments as String;
    final productData = Provider.of<Products>(context).items.firstWhere((pro) => pro.id == productsId);
    final authToken = Provider.of<Auth>(context).token;
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(productData.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height * 0.4,
              alignment: Alignment.center,
              child: Image.network(
                  productData.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(10),
                child: Text('Price :- ${productData.price}', style: TextStyle(
                  fontSize: 25,
                  //fontWeight: FontWeight.bold
                ),)
            ),
            Container(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Expanded(
                      flex: 5,
                      child: RaisedButton(
                        textColor: Colors.white,
                        color: Colors.purple,
                        child: Icon(
                          Icons.shopping_cart,
                          size: 50,
                        ),
                        onPressed: () {
                          cart.addItem(productData.id, productData.title, productData.price);
                        },
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    IconButton(
                      icon: productData.isFavroute ? Icon(
                        Icons.favorite,
                        size: 40,
                        color: Colors.red,
                      ) : Icon(
                        Icons.favorite_border,
                        size: 40,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        productData.favrouteToggle(authToken);
                      },
                    )
                  ],
                ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text('Description :-', style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15
              ),),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(productData.description, style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17
                    ),),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
