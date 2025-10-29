class OrderModel {
  final int? id;
  final int productId;
  final String productName;
  final double price;
  final String customerName;
  final String customerPhone;
  final double latitude;
  final double longitude;
  final String timestamp;

  OrderModel({
    this.id,
    required this.productId,
    required this.productName,
    required this.price,
    required this.customerName,
    required this.customerPhone,
    required this.latitude,
    required this.longitude,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'product_id': productId,
      'product_name': productName,
      'price': price,
      'customer_name': customerName,
      'customer_phone': customerPhone,
      'latitude': latitude,
      'longitude': longitude,
      'timestamp': timestamp,
    };
    if (id != null) map['id'] = id;
    return map;
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) => OrderModel(
    id: map['id'] as int?,
    productId: map['product_id'] as int,
    productName: map['product_name'] as String,
    price: (map['price'] as num).toDouble(),
    customerName: map['customer_name'] as String,
    customerPhone: map['customer_phone'] as String,
    latitude: (map['latitude'] as num).toDouble(),
    longitude: (map['longitude'] as num).toDouble(),
    timestamp: map['timestamp'] as String,
  );
}
