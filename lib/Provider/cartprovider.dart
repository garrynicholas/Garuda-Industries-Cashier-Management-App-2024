// cartprovider.dart

import 'package:flutter/material.dart';
import 'package:garuda_industries/JSON/cart.dart';
import 'package:garuda_industries/JSON/product.dart';

class CartProvider with ChangeNotifier {
  List<CartItem> _items = [];

  List<CartItem> get items => _items;

  int get itemCount => _items.length;

  void addToCart(Product product) {
    // Check if the product is already in the cart
    bool found = false;
    for (var item in _items) {
      if (item.product.ProdukID == product.ProdukID) {
        // Check if adding the quantity exceeds the available stock
        if (item.quantity + 1 > product.Stok) {
          print("Cannot add more items. Exceeds available stock.");
          // returns, without adding the item to the cart
          return;
        }
        item.quantity++;
        found = true;
        break;
      }
    }
    // f the product is not found in the cart, it adds a new CartItem object to the cart with a quantity of 1
    if (!found) {
      _items.add(CartItem(product: product, quantity: 1));
    }
    notifyListeners();
  }

  void decreaseQuantity(CartItem item) {
    /* If the quantity is greater than 1, it means there are multiple items of this type in the cart, and it's safe to decrease the quantity by one */
    if (item.quantity > 1) {
      item.quantity--;
      notifyListeners();
    }
  }

  void increaseQuantity(CartItem item) {
    item.quantity++;
    notifyListeners();
  }

  void removeCartItem(CartItem item) {
    _items.remove(item);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
