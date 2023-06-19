import 'package:flutter/material.dart';
import 'package:iot_shopping_cart/Repository/api_calls.dart';
import 'package:iot_shopping_cart/connectCart.dart';
import 'package:iot_shopping_cart/home_screen.dart';
import 'package:iot_shopping_cart/login_scree.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ApiCalls.user == null ? const LoginScreen() : ConnectCart(),
    );
  }
}
