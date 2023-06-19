import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:iot_shopping_cart/Models/cart_model.dart';
import 'package:http/http.dart' as http;

import 'package:iot_shopping_cart/Repository/api_calls.dart';
import 'package:iot_shopping_cart/Models/SignUpResponseModel.dart';

String publishKey =
    "pk_test_51NBwjBKndRBOWAUWI3g9lSDOkz65syqR9rdQOf3Ie5EXG3wcuMt2ztjvT7OTIvFXts1kNQEy8qScMjQdVpJjngtT00QTYUkXA0";
String secretKey =
    "sk_test_51NBwjBKndRBOWAUW2M57bpTb0w4FxygX9U5fNC6tEIHjfB4bxU5bVaSPNLHInmH3Gt3d48ETmTCShBbprXCykypq00YK0RdMY9";

class HomeScreen extends StatefulWidget {
  final String cartId;

  const HomeScreen({super.key, required this.cartId});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final User _user = ApiCalls.user!;
  final TextEditingController _cartIdController = TextEditingController();
  late Future<CartModel> _future;
  CartModel? _cartModel;
  CardFieldInputDetails? _card;
  Map<String, dynamic>? paymentIntent;
  var clientkey = secretKey; // Secret Key

  @override
  void initState() {
    _future = ApiCalls.getCartById(widget.cartId);
    Stripe.publishableKey = publishKey;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      TextEditingController _controller =
                          TextEditingController();
                      return AlertDialog(
                        title: Container(
                          child: TextField(
                            controller: _controller,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: "Enter Your Local IP"),
                          ),
                        ),
                        actions: [
                          ElevatedButton(
                              onPressed: () {
                                ApiCalls.baseUrl = _controller.text;
                              },
                              child: Text("Submit"))
                        ],
                      );
                    },
                  );
                },
                icon: Icon(Icons.settings))
          ],
        ),
        body: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              "Hi ${_user.username}",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const Text(
              "Welcome To IOT Based Shopping Centre",
              style: TextStyle(fontSize: 20),
            ),
            const Text(
              "Thank You for Choosing Us.",
              style: TextStyle(fontSize: 20),
            ),
            FutureBuilder(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  _cartModel = snapshot.data!;
                  return SizedBox(
                    height: 500,
                    child: ListView(
                      children: [
                        DataTable(
                            columns: const [
                              DataColumn(label: Text('Product Name')),
                              DataColumn(label: Text('Product Price')),
                            ],
                            rows: _cartModel!.products.map((product) {
                              return DataRow(
                                cells: [
                                  DataCell(Text(product.productName ?? "")),
                                  DataCell(
                                      Text(product.productPrice.toString())),
                                ],
                              );
                            }).toList()),
                        Divider(
                          height: 5,
                          thickness: 2,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              "Total Price",
                              style: TextStyle(fontSize: 20),
                            ),
                            Text(_cartModel!.totalBill.toString(),
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold))
                          ],
                        )
                      ],
                    ),
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
            ElevatedButton(
                onPressed: () async {
                 await makePayment();
                 await ApiCalls.disconnectCart();
                },
                child: Text("Check-Out"))
          ]),
        ));
  }

  calculateAmount(String amount) {
    final calculatedAmout = (int.parse(amount)) * 100;
    return calculatedAmout.toString();
  }

  Future<void> makePayment() async {
    try {
      // TODO: Create Payment intent
      paymentIntent = await createPaymentIntent('50000', 'INR');

      // TODO: Initialte Payment Sheet
      await Stripe.instance
          .initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent!['client_secret'],
          applePay: null,
          googlePay: null,
          style: ThemeMode.light,
          merchantDisplayName: 'someMerchantName',
        ),
      )
          .then((value) {
        print("Success");
      });

      // TODO: now finally display payment sheeet
      displayPaymentSheet();
    } catch (e, s) {
      String ss = "exception 1 :$e";
      String s2 = "reason :$s";
      print("exception 1:$e");
    }
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: const [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Icon(
                        Icons.check_circle,
                        color: Colors.green,
                      ),
                    ),
                    Text("Payment Successfull"),
                  ],
                ),
              ],
            ),
          ),
        );

        // TODO: update payment intent to null
        paymentIntent = null;
      }).onError((error, stackTrace) {
        String ss = "exception 2 :$error";
        String s2 = "reason :$stackTrace";
      });
    } on StripeException catch (e) {
      print('Error is:---> $e');
      String ss = "exception 3 :$e";
    } catch (e) {
      print('$e');
    }
  }
}

createPaymentIntent(String amount, String currency) async {
  try {
    Map<String, dynamic> body = {
      'amount': amount,
      'currency': currency,
      'payment_method_types[]': 'card'
    };
    debugPrint("Body : $body");
    var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        body: body,
        headers: {
          'Authorization': 'Bearer $secretKey',
          'Content-Type': 'application/x-www-form-urlencoded'
        });
    print("this is response " + response.body.toString());
    return jsonDecode(response.body);
  } catch (err) {
    debugPrint('callPaymentIntentApi Exception: ${err.toString()}');
  }
}



// class PaymentScreen extends StatefulWidget {
//   const PaymentScreen({Key? key}) : super(key: key);

//   @override
//   State<PaymentScreen> createState() => _PaymentScreenState();
// }

// class _PaymentScreenState extends State<PaymentScreen> {

//   Map<String, dynamic>? paymentIntent;
//   var clientkey = secretKey; // Secret Key

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         body: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Text("Buy Premium Membership at 10 INR"),
//             Container(
//               width: MediaQuery.of(context).size.width,
//               color: Colors.teal,
//               margin: const EdgeInsets.all(10),
//               child: TextButton(
//                 onPressed: () => makePayment(), 
//                 child: const Text(
//                   'Pay',
//                   style: TextStyle(color: Colors.white),
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }


// }
