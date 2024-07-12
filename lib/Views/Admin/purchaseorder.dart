import 'dart:io';
import 'package:flutter/material.dart';
import 'package:garuda_industries/Components/colors.dart';
import 'package:garuda_industries/JSON/product.dart';
import 'package:garuda_industries/JSON/users.dart';
import 'package:garuda_industries/Provider/cartprovider.dart';
import 'package:garuda_industries/SQLite/database_helper.dart';
import 'package:garuda_industries/Views/Admin/cartpage.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PurchaseOrder extends StatefulWidget {
  final Users? profile;
  const PurchaseOrder({Key? key, this.profile}) : super(key: key);

  @override
  _PurchaseOrderState createState() => _PurchaseOrderState();
}

class _PurchaseOrderState extends State<PurchaseOrder> {
  late List<Product> _products = [];
  late List<Product> _searchedProducts = [];
  bool hasProductsInCart = false; // Track if there are products in the cart
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
      _searchedProducts = products;
      hasProductsInCart = _products.isNotEmpty;
    });
  }

  void _deleteProduct(Product product) async {
    await DatabaseHelper().deleteProduct(product.ProdukID!);
    // Refresh product list after deleting the product
    _loadProducts();
  }

  void _goToCartPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => CartPage(profile: widget.profile)),
    );
  }

  void _searchProducts(String query) {
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
    var cartProvider = Provider.of<CartProvider>(context);
    bool hasProductsInCart = cartProvider.items.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Text(
          'Beli Produk',
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
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              _loadProducts(); // Reload products on refresh button press
            },
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: (query) {
                _searchProducts(query);
              },
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Cari',
                labelStyle: TextStyle(
                  color: Colors.white,
                ),
                hintText: 'Cari berdasarkan nama produk...',
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
                crossAxisCount: 2, // 2 items in each row
                mainAxisSpacing: 4.0,
                crossAxisSpacing: 2.0,
                childAspectRatio: 0.57,
              ),
              itemCount: _searchedProducts.length,
              itemBuilder: (context, index) {
                final product = _searchedProducts[index];
                return GestureDetector(
                  onTap: () {},
                  child: Padding(
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
                            height: 8,
                          ),
                          Expanded(
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
                                    Icon(Icons.inventory_2_outlined,
                                        size: 16.0),
                                    SizedBox(width: 4.0),
                                    Text(
                                      '${product.Stok}',
                                      style: TextStyle(
                                        fontSize: 14.0,
                                      ),
                                    ),
                                  ],
                                ),
                                // parse string into int
                                Text(
                                  'Rp${NumberFormat('#,###').format(int.parse(product.Harga))}',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(
                                  height: 16,
                                ),
                                SizedBox(
                                  height: 42,
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: product.Stok > 0
                                        ? () {
                                            if (product.Stok > 0) {
                                              // Access the CartProvider instance
                                              var cartProvider =
                                                  Provider.of<CartProvider>(
                                                      context,
                                                      listen: false);
                                              // Call the addToCart method of CartProvider to add the product to the cart
                                              cartProvider.addToCart(product);
                                              // Show Snackbar notification
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                      '${product.NamaProduk} ditambahkan ke Cart'),
                                                  duration:
                                                      Duration(seconds: 2),
                                                ),
                                              );
                                            }
                                          }
                                        : null,
                                    style: ElevatedButton.styleFrom(
                                      primary: primaryColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: Text(
                                      'Tambah ke Cart',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(16),
        child: ElevatedButton(
          onPressed: hasProductsInCart ? _goToCartPage : null,
          child: Text(
            'Go to Cart',
            style: TextStyle(fontSize: 16),
          ),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.disabled)) {
                  return Colors.grey;
                }
                return Colors.blue;
              },
            ),
            foregroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.disabled)) {
                  return Color.fromARGB(255, 236, 236, 236);
                }
                return Colors.white;
              },
            ),
            shape: MaterialStateProperty.resolveWith<OutlinedBorder>(
              (Set<MaterialState> states) {
                return RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
