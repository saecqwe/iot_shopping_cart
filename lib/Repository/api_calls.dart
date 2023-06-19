import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:iot_shopping_cart/Models/SignUpResponseModel.dart';
import 'package:iot_shopping_cart/Models/cart_model.dart';
import 'package:iot_shopping_cart/Models/connectCartResponseModel.dart';
import 'package:iot_shopping_cart/Models/quote_model.dart';

class ApiCalls {
  static String baseUrl = "https://us-central1-cart-4dab3.cloudfunctions.net/api"; //Emulator == LocalHost.
  static User? user;


static Future<Quote> getQuote() async {
  final response = await http.get(Uri.parse("https://zenquotes.io/api/today"));

  if (response.statusCode == 200) {
    final List<dynamic> quoteList = jsonDecode(response.body);
    if (quoteList.isNotEmpty) {
      final json = quoteList[0];
      return Quote.fromJson(json);
    }
  }

  throw Exception();
}


static Future disconnectCart() async{
  try {
    final response = await http.post(Uri.parse("http://$baseUrl/users/${user!.id}/disconnect"));

  if(response.statusCode==400)
  {
      throw Exception();

  }
  else
  {
    return "Cart Disconnected";
  }
  } catch (e) {
    return "Error Occured";
  }
}


  static Future<User> signIn(String username, String password) async {
    print("http://$baseUrl/user/login");
    final response =
        await http.post(Uri.parse("http://$baseUrl/user/login"), body: {
      "username": username,
      "password": password,
    });

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);

      print("this is json " + json.toString());

      if (json.containsKey("user")) {
        user = User.fromJson(json['user']);
        return User.fromJson(json['user']);
      } else {
        throw Exception('Unexpected response format');
      }
    } else {
      throw Exception('Failed to login');
    }
  }

  static Future<SignUpResponse> signUp(String username, String email,
      String password, String displayName) async {
    print("baseUrl : http://$baseUrl/users/register");
    final response = await http
        .post(Uri.parse("http://$baseUrl/users/register"), body: {
      "username": username,
      "password": password,
      "email": email,
      "displayName": displayName
    });

    if (response.statusCode == 200) {
      print("success in account creation");
      // If the server did return a 200 OK response,
      // then parse the JSON.
      user = SignUpResponse.fromJson(jsonDecode(response.body)).user;
      return SignUpResponse.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 400) {
      print("failure in account creation");
      // If the user already exists, return the appropriate response.
      return SignUpResponse(user: null, message: "user already exists");
    } else {
      print("error in account creation");
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  static Future<ConnectCartResponseModel> connectToCart(
      String cartSpecialCode, String userId) async {
    final response = await http.post(
        Uri.parse("http://$baseUrl/users/$userId/connect"),
        body: {"specialCode": cartSpecialCode});

    print("this is connectCart Response " + response.body.toString());
    if (response.statusCode == 200) {
      return ConnectCartResponseModel.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 400) {
      // If the user already exists, return the appropriate response.
      throw Exception('Failed to load album');
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  static Future<CartModel> getCartById(String id) async {
    print("call this : http://$baseUrl/cart/$id");
    final response = await http.get(Uri.parse("http://$baseUrl/cart/$id"));


      print(response.body);
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return CartModel.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 400) {
      // If the user already exists, return the appropriate response.
      throw Exception('Error Occured');
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load Cart');
    }
  }

  static Future<void> getProductById(String id) async {}

  static Future<void> addToCart(String productId) async {}

  static Future<void> removeFromCart(String productId) async {}

  static Future<void> getCartItems() async {}

  static Future<void> checkout() async {}

  static Future<void> updateProfile(String displayName) async {}

  static Future<void> changePassword(
      String oldPassword, String newPassword) async {}

  static Future<void> deleteAccount() async {}

  static Future<void> logout() async {}
}
