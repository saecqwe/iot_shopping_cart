class CartModel {
  List<Product> products;
  String id;
  int cartNumber;
  bool userConnection;
  String createdAt;
  String updatedAt;
  int v;
  String username;
  int? totalBill;

  CartModel({
    required this.products,
    required this.id,
    required this.cartNumber,
    required this.userConnection,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.username,
    required this.totalBill,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    var productList = json['products'] as List<dynamic>;
    List<Product> products = productList.map((i) => Product.fromJson(i)).toList();

    return CartModel(
      products: products,
      id: json['_id'],
      cartNumber: json['cartNumber'],
      userConnection: json['userConnection'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      v: json['__v'],
      username: json['username'],
      totalBill: json['totalBill'],
    );
  }
}

class Product {
  String? id;
  String? productName;
  int? productPrice;
  String? productCode;
  String? createdAt;
  String? updatedAt;
  int? v;

  Product({
    required this.id,
    required this.productName,
    required this.productPrice,
    required this.productCode,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'],
      productName: json['productName'],
      productPrice: json['productPrice'],
      productCode: json['productCode'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      v: json['__v'],
    );
  }
}
