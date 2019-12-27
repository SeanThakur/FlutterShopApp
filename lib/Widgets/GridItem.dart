import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './ShopItem.dart';
import '../providers/products.dart';

class GridItem extends StatelessWidget {
  final isfav;
  GridItem(this.isfav);
  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);
    final products = isfav ? productData.Favroute : productData.items;
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          childAspectRatio: 3/2,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20
      ),
      itemBuilder: (context, index) => ChangeNotifierProvider.value(
        value: products[index],
        child: ShopItem(),
      ),
      itemCount: products.length,
    );
  }
}
