import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

class AddNewProductScreen extends StatefulWidget {
  const AddNewProductScreen({super.key});

  static const String name = '/add_new_product';

  @override
  State<AddNewProductScreen> createState() => _AddNewProductScreenState();
}

class _AddNewProductScreenState extends State<AddNewProductScreen> {
  final TextEditingController _nameTEController = TextEditingController();
  final TextEditingController _priceTEController = TextEditingController();
  final TextEditingController _totalPriceTEController = TextEditingController();
  final TextEditingController _quantityTEController = TextEditingController();
  final TextEditingController _imageTEController = TextEditingController();
  final TextEditingController _codeTEController = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  bool _addNewProductInProgress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add New Product',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
        backgroundColor: Colors.blueGrey[50], // Subtle background color
        elevation: 4.0, // Slight shadow effect
        centerTitle: true, // Center the title
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(16.0),
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _buildProductForm(),
        ),
      ),
    );
  }

  Widget _buildProductForm() {
    return Form(
      key: _formkey,
      child: Column(
        children: [
          TextFormField(
            controller: _nameTEController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: InputDecoration(
              hintText: 'Name',
              labelText: 'Product Name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            validator: (String? value) {
              if (value?.trim().isEmpty ?? true) {
                return 'Enter Product Name';
              }
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _priceTEController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'Price',
              labelText: 'Product Price',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            validator: (String? value) {
              if (value?.trim().isEmpty ?? true) {
                return 'Enter Product Price';
              }
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _totalPriceTEController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'Total Price',
              labelText: 'Product Total Price',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            validator: (String? value) {
              if (value?.trim().isEmpty ?? true) {
                return 'Enter Product total Price';
              }
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _quantityTEController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'Quantity',
              labelText: 'Product Quantity',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            validator: (String? value) {
              if (value?.trim().isEmpty ?? true) {
                return 'Enter Product Quantity';
              }
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _codeTEController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: InputDecoration(
              hintText: 'Code',
              labelText: 'Product Code',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            validator: (String? value) {
              if (value?.trim().isEmpty ?? true) {
                return 'Enter Product Code';
              }
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _imageTEController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: InputDecoration(
              hintText: 'Image url',
              labelText: 'Product Image',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            validator: (String? value) {
              if (value?.trim().isEmpty ?? true) {
                return 'Enter Product Image url';
              }
            },
          ),
          const SizedBox(
            height: 16,
          ),
          Visibility(
            visible: _addNewProductInProgress == false,
            replacement: const Center(
              child: CircularProgressIndicator(),
            ),
            child: ElevatedButton(
                onPressed: () {
                  if (_formkey.currentState!.validate()) {
                    _addNewProduct();
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blueAccent,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  textStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                child: const Text('Add Product')),
          )
        ],
      ),
    );
  }

  Future<void> _addNewProduct() async {
    _addNewProductInProgress = true;
    setState(() {});
    Uri uri = Uri.parse('https://crud.teamrabbil.com/api/v1/CreateProduct');

    Map<String, dynamic> requestBody = {
      "Img": _imageTEController.text.trim(),
      "ProductCode": _codeTEController.text.trim(),
      "ProductName": _nameTEController.text.trim(),
      "Qty": _quantityTEController.text.trim(),
      "TotalPrice": _totalPriceTEController.text.trim(),
      "UnitPrice": _priceTEController.text.trim(),
    };
    Response response = await post(
      uri,
      headers: {'content-type': 'application/json'},
      body: jsonEncode(requestBody),
    );
    print(response.statusCode);
    print(response.body);
    _addNewProductInProgress = false;
    setState(() {});
    if (response.statusCode == 200) {
      _clearTextFields();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('New Product Added!'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('New Product Add failed'),
        ),
      );
    }
  }

  void _clearTextFields() {
    _nameTEController.clear();
    _priceTEController.clear();
    _totalPriceTEController.clear();
    _codeTEController.clear();
    _quantityTEController.clear();
    _imageTEController.clear();
  }

  @override
  void dispose() {
    _nameTEController.dispose();
    _priceTEController.dispose();
    _totalPriceTEController.dispose();
    _codeTEController.dispose();
    _quantityTEController.dispose();
    _imageTEController.dispose();
    super.dispose();
  }
}
