class QuotationItem {
  final int productId;
  final String productName;
  int quantity;
  String rate;

  QuotationItem({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.rate,
  });

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'quantity': quantity,
      'rate': rate,
    };
  }
}
