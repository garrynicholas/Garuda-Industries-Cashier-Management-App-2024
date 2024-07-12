import 'dart:io';
import 'package:flutter/material.dart';
import 'package:garuda_industries/Components/colors.dart';
import 'package:garuda_industries/JSON/cart.dart';
import 'package:garuda_industries/JSON/detail_penjualan.dart';
import 'package:garuda_industries/JSON/penjualan.dart';
import 'package:garuda_industries/JSON/product.dart';
import 'package:garuda_industries/JSON/users.dart';
import 'package:garuda_industries/Provider/cartprovider.dart';
import 'package:garuda_industries/SQLite/database_helper.dart';
import 'package:garuda_industries/Views/refresh.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CartPage extends StatefulWidget {
  final Users? profile;
  const CartPage({Key? key, this.profile}) : super(key: key);

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  double taxPercentage = 0.02;

  @override
  Widget build(BuildContext context) {
    var cartProvider = Provider.of<CartProvider>(context);
    var cartItems = cartProvider.items;

    // Calculate subtotal
    int subtotal = 0;
    cartItems.forEach((item) {
      subtotal += int.parse(item.product.Harga) * item.quantity;
    });

    // Calculate total tax based on the price of each product
    double totalTax = 0;
    cartItems.forEach((item) {
      totalTax +=
          (int.parse(item.product.Harga) * item.quantity) * taxPercentage;
    });

    // Total amount is equal to the subtotal
    double totalAmount = subtotal.toDouble();

    DateTime currentDate = DateTime.now();

    String formattedDate = DateFormat('yyyy-MM-dd - HH:mm').format(currentDate);

    // Access usrId from profile
    int usrId = widget.profile!.usrId!;

    // cartpage.dart

    void checkout1() async {
      // Calculate subtotal
      int subtotal = cartItems.fold(0,
          (sum, item) => sum + int.parse(item.product.Harga) * item.quantity);

      // Since we're removing tax calculation, totalAmount will be equal to subtotal
      double totalAmount = subtotal.toDouble();

      // Create a Penjualan instance with the exact total amount
      Penjualan penjualan = Penjualan(
        TanggalPenjualan: DateTime.now(),
        TotalHarga: totalAmount.toInt(),
        usrId: widget.profile!.usrId!,
      );

      // Insert Penjualan into the database
      final DatabaseHelper dbHelper = DatabaseHelper();
      int penjualanId = await dbHelper.insertPenjualan(penjualan);

      // Insert detail penjualan for each item in the cart
      for (var item in cartItems) {
        int subtotalItem = int.parse(item.product.Harga) * item.quantity;
        DetailPenjualan detailPenjualan = DetailPenjualan(
          PenjualanID: penjualanId,
          ProdukID: item.product.ProdukID!,
          JumlahProduk: item.quantity,
          Subtotal: subtotalItem,
        );
        await dbHelper.insertDetailPenjualan(detailPenjualan);

        // Reduce the stock quantity of the product
        int updatedStock = item.product.Stok - item.quantity;
        Product updatedProduct = item.product.copyWith(stock: updatedStock);
        await dbHelper.updateProduct(updatedProduct);
      }

      // Clear the cart
      cartProvider.clearCart();

      // Replace the current route with PurchaseOrder
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => RefreshPage()),
      );
    }

    void checkout() async {
      // Calculate subtotal
      int subtotal = cartItems.fold(0,
          (sum, item) => sum + int.parse(item.product.Harga) * item.quantity);

      // Calculate total tax based on the subtotal
      double totalTax = subtotal * taxPercentage;

      // Calculate total amount including tax
      double totalAmount = subtotal + totalTax;

      // Create a Penjualan instance with the exact total amount
      Penjualan penjualan = Penjualan(
        TanggalPenjualan: DateTime.now(),
        TotalHarga: totalAmount
            .toInt(), // Store the exact total amount including tax in totalHarga
        usrId: widget.profile!.usrId!,
      );

      // Insert Penjualan into the database
      final DatabaseHelper dbHelper = DatabaseHelper();
      int penjualanId = await dbHelper.insertPenjualan(penjualan);

      // Insert detail penjualan for each item in the cart
      for (var item in cartItems) {
        int subtotalItem = int.parse(item.product.Harga) * item.quantity;
        DetailPenjualan detailPenjualan = DetailPenjualan(
          PenjualanID: penjualanId,
          ProdukID: item.product.ProdukID!,
          JumlahProduk: item.quantity,
          Subtotal: subtotalItem,
        );
        await dbHelper.insertDetailPenjualan(detailPenjualan);

        // Reduce the stock quantity of the product
        int updatedStock = item.product.Stok - item.quantity;
        Product updatedProduct = item.product.copyWith(stock: updatedStock);
        await dbHelper.updateProduct(updatedProduct);
      }

      // Clear the cart
      cartProvider.clearCart();

      // Replace the current route with PurchaseOrder
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => RefreshPage()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Text(
          'Product List',
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
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                var item = cartItems[index];
                return GestureDetector(
                  onLongPress: () {
                    _showDeleteProductBottomSheet(context, item, cartProvider);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 4,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0.0),
                        child: ListTile(
                          leading: AspectRatio(
                            aspectRatio: 1,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                  image: FileImage(File(item.product.Gambar)),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          title: Text(
                            item.product.NamaProduk,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 4),
                              Text(
                                'Rp${NumberFormat('#,###').format(int.parse(item.product.Harga))}',
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 25,
                                height: 25,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey[300],
                                ),
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  icon: Icon(Icons.remove),
                                  onPressed: () {
                                    cartProvider.decreaseQuantity(item);
                                  },
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                item.quantity.toString(),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 8),
                              Container(
                                width: 25,
                                height: 25,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey[300],
                                ),
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  icon: Icon(Icons.add),
                                  onPressed: () {
                                    // Check if increasing the quantity exceeds available stock
                                    if (item.quantity < item.product.Stok) {
                                      cartProvider.increaseQuantity(item);
                                    } else {
                                      // You can show a message or handle the situation as needed
                                      print(
                                          "Cannot increase quantity. Exceeds available stock.");
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                          onTap: () {},
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            color: const Color.fromARGB(255, 29, 29, 29),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Subtotal:',
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      'Rp${NumberFormat('#,###').format(subtotal)}',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Text(
                //       'Tax:',
                //       style: TextStyle(color: Colors.white),
                //     ),
                //     Text(
                //       'Rp${NumberFormat('#,###').format(totalTax)}',
                //       style: TextStyle(color: Colors.white),
                //     ),
                //   ],
                // ),
                Divider(height: 20, color: Colors.grey[400]),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Amount:',
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      'Rp${NumberFormat('#,###').format(totalAmount)}',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Tanggal:',
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      formattedDate,
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    // Expanded(
                    //   child: TextButton(
                    //     onPressed: () {},
                    //     child: Text(
                    //       'Settings',
                    //       style: TextStyle(color: Colors.white),
                    //     ),
                    //     style: TextButton.styleFrom(
                    //       backgroundColor: Colors.blue,
                    //     ),
                    //   ),
                    // ),
                    // SizedBox(width: 16),
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          checkout1();
                        },
                        child: Text(
                          'Checkout',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: TextButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 68, 180, 72),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteProductBottomSheet(
      BuildContext context, CartItem item, CartProvider cartProvider) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          color: backgroundColor,
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Anda yakin ingin menghapus ${item.product.NamaProduk} dari cart?',
                style: TextStyle(fontSize: 18, color: Colors.white),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      // Cancel product from cart

                      Navigator.pop(context);
                    },
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Remove product from cart
                      cartProvider.removeCartItem(item);
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Delete',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
