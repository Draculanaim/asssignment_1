import 'dart:convert';
import 'package:first_project/ui/screens/add_new_product_screen.dart';
import 'package:flutter/material.dart';
import '../../models/product.dart';
import '../widgets/product_item.dart';
import 'package:http/http.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {

  List<Product> productList = [];
  bool _getProductListInProgress = false;

  @override
  void initState() {
    super.initState();
    _getProductList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: Text('Product List'),
        bottomOpacity: 6,
      ),
      body: Visibility(
        visible: _getProductListInProgress == false,
        replacement: Center(
          child: CircularProgressIndicator(

          ) ,
        ),
        child: ListView.builder(
          itemCount: productList.length,
            itemBuilder: (context, index){
          return ProductItem(
            product: productList[index],
          );
        },),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.pushNamed(context, AddNewProductScreen.name);
        },
        child: Icon(Icons.add),
      ),
    );
  }
  Future<void> _getProductList() async {
    _getProductListInProgress =true;
    setState(() {});

    Uri uri =Uri.parse('https://crud.teamrabbil.com/api/v1/ReadProduct');
    Response response = await get(uri);
    print(response.statusCode);
    print(response.body);
    if(response.statusCode == 200){
      final decodeData =jsonDecode(response.body);
      print(decodeData['status']);
      for(Map<String, dynamic> p in decodeData['data']){
        Product product = Product(
          id: p['_id'],
          productName: p['ProductName'],
          productCode: p['ProductCode'],
          quantity: p['Qty'],
          unitPrice: p['UnitPrice'],
          img: p['Img'],
          totalPrice: p['TotalPrice'],
          createdDate: p['CreatedDate'],
        );

        productList.add(product);
      }
      setState(() {});
    }
    _getProductListInProgress =false;
    setState(() {});
  }
}

