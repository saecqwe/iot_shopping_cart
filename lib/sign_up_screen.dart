import 'package:flutter/material.dart';

import 'package:iot_shopping_cart/Repository/api_calls.dart';
import 'package:iot_shopping_cart/Models/SignUpResponseModel.dart';
import 'package:iot_shopping_cart/connectCart.dart';
import 'package:iot_shopping_cart/home_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController displayNameController = TextEditingController();
  SignUpResponse? _signUpResponse;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Center(
        child: Padding(
            padding: const EdgeInsets.all(10),
            child: ListView(
              children: <Widget>[
                const SizedBox(
                  height: 50,
                ),
                Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(10),
                    child: const Text(
                      'Create New Account',
                      style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                          fontSize: 30),
                    )),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    controller: displayNameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Display Name",
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: TextField(
                    controller: userNameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'User Name',
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: TextField(
                    obscureText: true,
                    controller: passController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                Container(
                    height: 50,
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: ElevatedButton(
                      child: const Text('Register'),
                      onPressed: () async {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                        );

                        try {
                          _signUpResponse = await ApiCalls.signUp(
                              userNameController.text,
                              emailController.text,
                              passController.text,
                              displayNameController.text);
                          if (_signUpResponse!.message == "SUCCESS") {
                            await Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ConnectCart(),
                                ));
                          }
                                                    Navigator.pop(context);

                                                    showDialog(
                                                      useSafeArea: true,
                                                      context: context  , builder: (context) {
                                                      return SimpleDialog(title: Text(_signUpResponse!.message ,
                                                      style: TextStyle(fontSize: 40),),
                                                      titlePadding: EdgeInsets.all(22),
                                                      );
                                                    },);
 
                         
                        } catch (e) {
                          Navigator.pop(context);
                       

                          // ScaffoldMessenger.of(context).showSnackBar(
                          //     SnackBar(content: Text(e.toString())));
                        }

                        // if(_signUpResponse!.message=="user already exists")
                        // {
                        //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("user already exists")));
                        // }else  if(_signUpResponse!.message=="Some error occured")
                        // {
                        //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_signUpResponse!.message)));
                        // }
                        // ScaffoldMessenger.of(context).showSnackBar(
                        //     SnackBar(content: Text(_signUpResponse!.message)));
                      },
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text('Already Have an Account?'),
                    TextButton(
                      child: const Text(
                        'Sign in',
                        style: TextStyle(fontSize: 20),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    )
                  ],
                ),
              ],
            )),
      ),
    ));
  }
}
