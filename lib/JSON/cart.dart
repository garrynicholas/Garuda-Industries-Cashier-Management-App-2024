import 'package:garuda_industries/JSON/product.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, required this.quantity});

  void incrementQuantity() {
    quantity++;
  }
}
