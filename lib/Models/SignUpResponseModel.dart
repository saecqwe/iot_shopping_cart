class SignUpResponse {
  final String message;
  final User? user;

  SignUpResponse({required this.message, this.user});

  factory SignUpResponse.fromJson(Map<String, dynamic> json) {
    return SignUpResponse(
      message: json['message'],
      user: json['user1'] != null ? User.fromJson(json['user1']) : null,
    );
  }
}

class User {
  final List<dynamic> cart;
  final String id;
  final String username;
  final String? specialCode;
  final String email;
  final String password;
  final String displayName;
  final bool adminPrevilages;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int v;

  User({
    required this.cart,
    required this.id,
    required this.username,
    required this.email,
    required this.password,
    required this.displayName,
    required this.adminPrevilages,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    this.specialCode,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      cart: json['cart'],
      id: json['_id'],
      username: json['username'],
      specialCode: json['specialCode'],
      email: json['email'],
      password: json['password'],
      displayName: json['displayName'],
      adminPrevilages: json['adminPrevilages'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      v: json['__v'],
    );
  }
}

class CartItem {
  final String id;
  final int quantity;

  CartItem({required this.id, required this.quantity});

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['_id'],
      quantity: json['quantity'],
    );
  }
}
