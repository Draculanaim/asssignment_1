import 'package:first_project/ui/screens/update_product_screen.dart';
import 'package:flutter/material.dart';

import '../../models/product.dart';

class ProductItem extends StatelessWidget {
  ProductItem({super.key, required this.product, required this.onDeleteTab});

  final Product product;
  VoidCallback? onDeleteTab;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      elevation: 4.0,
      // color: Colors.limeAccent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(4.0),
          child: Image.network(
            product.img ?? '',
            width: 50,
          ),
        ),
        title: Text(product.productName ?? ''),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Product Code: ${product.productCode ?? ''}'),
            Text('Product Quantity: ${product.quantity ?? ''}'),
            Text('Price : ${product.unitPrice ?? ''}'),
            Text('Total Price: ${product.totalPrice ?? ''}'),
          ],
        ),
        trailing: Wrap(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: onDeleteTab,
                icon: Icon(Icons.delete),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      UpdateProductScreen.name,
                      arguments: product,
                    );
                  },
                  icon: Icon(Icons.edit, color: Colors.blue)),
            ),
          ],
        ),
      ),
    );
  }
}
