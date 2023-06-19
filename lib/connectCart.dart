import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:iot_shopping_cart/Models/connectCartResponseModel.dart';
import 'package:iot_shopping_cart/Models/quote_model.dart';
import 'package:iot_shopping_cart/Repository/api_calls.dart';
import 'package:iot_shopping_cart/home_screen.dart';

class ConnectCart extends StatefulWidget {
  const ConnectCart({super.key});

  @override
  State<ConnectCart> createState() => _ConnectCartState();
}

class _ConnectCartState extends State<ConnectCart> {
  ConnectCartResponseModel? connectCartResponseModel;
  TextEditingController _specialCodeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.settings))],
      ),
      body: Container(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 18.0),
                child: Text(
                  "Connect To Cart",
                  style: TextStyle(fontSize: 30 , fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                width: double.infinity,
                margin: EdgeInsets.only(top: 50),
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: TextField(
                  controller: _specialCodeController,
                  decoration: InputDecoration(
                      hintText: "Enter Special Code",
                      border: OutlineInputBorder()),
                ),
              ),
              ElevatedButton(
                  onPressed: () async {
                    //Loading Indicator
                    showDialog(
                      context: context,
                      builder: (context) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    );
                    try {
                      connectCartResponseModel = await ApiCalls.connectToCart(
                          _specialCodeController.text, ApiCalls.user!.id);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeScreen(
                                cartId: connectCartResponseModel!.specialCode),
                          ));
                    } catch (e) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(e.toString())));
                    }
                  },
                  child: Text("Connect")),
          SizedBox(height: 50,),
              FutureBuilder<Quote>(
                future: ApiCalls.getQuote(),
                builder: (context, snapshot2) {
                if(snapshot2.hasData)
                {
                  Quote _quote = snapshot2.data!;
                    return Column(
                      children: [
                        Text("Quote Of The Day" , style: TextStyle(fontSize: 30 , fontWeight: FontWeight.bold),),
                        Container(
                          padding: EdgeInsets.all(22),
                          child: Text(_quote.q , style: TextStyle(fontSize: 20),),
                        ),
                      ],
                    );
                }
                else
                {
                  return Center(child: CircularProgressIndicator(),);
                }
              },)
          
            ],
          ),
        ),
      ),
    );
  }
}
