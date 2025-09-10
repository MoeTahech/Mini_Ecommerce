import '../../home/data/product_model.dart';

class CartItem {
  final Product product;
  final int quantity;
  final double priceAtPurchase; // optional

  CartItem({
    required this.product,
    required this.quantity,
    this.priceAtPurchase = 0.0,
  });

  double get totalPrice => priceAtPurchase > 0 ? priceAtPurchase * quantity : product.price * quantity;

  factory CartItem.fromJson(Map<String, dynamic> json) {
    final productJson = json['product'] as Map<String, dynamic>;
    final product = Product.fromJson(productJson);
    final quantity = json['quantity'] as int;
    final priceAtPurchase = (json['priceAtPurchase'] as num?)?.toDouble() ?? 0.0;

    return CartItem(
      product: product,
      quantity: quantity,
      priceAtPurchase: priceAtPurchase,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "productId": product.id,
      "quantity": quantity,
    };
  }
}
