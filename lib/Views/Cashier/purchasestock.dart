import 'dart:io';

import 'package:flutter/material.dart';
import 'package:garuda_industries/Components/colors.dart';
import 'package:garuda_industries/JSON/product.dart';
import 'package:garuda_industries/SQLite/database_helper.dart';
import 'package:intl/intl.dart';

class PurchaseStock extends StatefulWidget {
  @override
  _PurchaseStockState createState() => _PurchaseStockState();
}

class _PurchaseStockState extends State<PurchaseStock> {
  /* When a variable is declared as late, you promise the Dart compiler that you will initialize it before it's used, but you don't have to provide an initial value immediately */
  late List<Product> _products = [];
  late List<Product> _searchedProducts = [];
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    // Fetch products from the database
    List<Product> products = await DatabaseHelper().getAllProducts();
    setState(() {
      _products = products;
      _searchedProducts =
          products; // Initialize searchedProducts with all products
    });
  }

  void _searchProducts(String query) {
    // convert product name into lowercase, check if product name contains lowercase and then store back to list
    List<Product> searchedList = _products
        .where((product) =>
            product.NamaProduk.toLowerCase().contains(query.toLowerCase()))
        .toList();
    setState(() {
      _searchedProducts = searchedList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Text(
          'Purchase Stock',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              //  is a callback that gets invoked every time the text within the TextField changes
              onChanged: (query) {
                _searchProducts(query);
              },
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Search',
                labelStyle: TextStyle(
                  color: Colors.white,
                ),
                hintText: 'Search by product name...',
                hintStyle: TextStyle(color: Colors.white),
                prefixIcon: Icon(Icons.search, color: Colors.white),
                filled: true,
                fillColor: Colors.transparent,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide(
                    color: Colors.white,
                    width: 2.0,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide(
                    color: Colors.white,
                    width: 2.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide(
                    color: Colors.white,
                    width: 2.0,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 4.0,
                crossAxisSpacing: 2.0,
                childAspectRatio: 0.5668,
              ),
              itemCount: _searchedProducts.length,
              itemBuilder: (context, index) {
                // retrieves the product data for the current index from the _searchedProducts list.
                final product = _searchedProducts[index];
                return Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 5,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                          ),
                          child: Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: product.Gambar.isNotEmpty
                                  ? Image.file(
                                      File(product.Gambar),
                                      fit: BoxFit.cover,
                                    )
                                  : Icon(Icons.image),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.NamaProduk,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16.0,
                                ),
                              ),
                              SizedBox(height: 8.0),
                              Row(
                                children: [
                                  Icon(Icons.inventory_2_outlined, size: 16.0),
                                  SizedBox(width: 4.0),
                                  Text(
                                    '${product.Stok}',
                                    style: TextStyle(
                                      fontSize: 14.0,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                'Rp${NumberFormat('#,###').format(int.parse(product.Harga))}',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: 8.0),
                              Container(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    _buystock(product);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    primary: primaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: Text(
                                    'Buy Stock',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _buystock(Product product) {
    TextEditingController quantityController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: backgroundColor,
          title: Text(
            'Buy Stock',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                controller: quantityController,
                keyboardType: TextInputType.number,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Quantity',
                  labelStyle: TextStyle(
                    color: Colors.white,
                  ),
                  filled: true,
                  fillColor: Colors.transparent,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide(
                      color: Colors.white,
                      width: 2.0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide(
                      color: Colors.white,
                      width: 2.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide(
                      color: Colors.white,
                      width: 2.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.blue,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                int quantity = int.tryParse(quantityController.text) ?? 0;
                /* If the quantity is valid (greater than 0), it updates the product's stock by 
                adding the entered quantity to the current stock using product.copyWith */
                if (quantity > 0) {
                  // Update the product's stock
                  Product updatedProduct = product.copyWith(
                    stock: product.Stok + quantity,
                  );
                  await DatabaseHelper().updateProduct(updatedProduct);
                  // Reload products
                  _loadProducts();
                  Navigator.of(context).pop(); // Close the dialog
                } else {
                  // Show an error if quantity is not valid
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Invalid quantity'),
                    ),
                  );
                }
              },
              child: Text(
                'Buy',
                style: TextStyle(
                  color: const Color.fromARGB(255, 60, 202, 65),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
