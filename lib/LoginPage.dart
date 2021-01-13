import 'dart:convert';
import 'dart:async';
import 'dart:developer';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:http/http.dart' as http;
import 'package:uztex_pro/main.dart';

import 'package:uztex_pro/HomePage.dart';




class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);
  @override
  _LoginPageState createState()=>_LoginPageState();

}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {

  AnimationController _controller;
  Animation _animation;

  FocusNode _focusNode = FocusNode();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  //final TabController _tabController = TabController();




  void displayDialog(context, title, text) => showDialog(
    context: context,
    builder: (context) =>
        AlertDialog(
            title: Text(title),
            content: Text(text)
        ),
  );

  Future<String> attemptLogIn(String username, String password) async {
    print(username);
    print(password);
    var res = await http.post(
        "$API/auth/login/",
        body: {
          "username": username,
          "password": password
        }
    );
    print(res);
    if(res.statusCode == 200) return res.body;
    return null;
  }

//  Future<int> attemptSignUp(String username, String password) async {
//    var res = await http.post(
//        '$API/auth/register/',
//        body: {
//          "username": username,
//          "password": password
//        }
//    );
//    return res.statusCode;
//
//  }

  _LoginPageState() {
    this._usernameController.text = '';
    this._passwordController.text = '';
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync:this,duration: Duration(milliseconds: 300));
    _animation = Tween(begin: 300.0, end: 50.0).animate(_controller)
      ..addListener(() {
        setState(() {});
      });

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();

    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("UZTEX PRO Mobile"),),
        resizeToAvoidBottomPadding: false,
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child:

          InkWell( // to dismiss the keyboard when the user tabs out of the TextField
            splashColor: Colors.transparent,
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Column(
              children: <Widget>[

                Container(
                  child: Image.asset(
                      'assets/images/uztex.png'),
                  width: 330,
                  margin: EdgeInsets.only(top: 30.0),
                ),




                Container(
                  child: TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText:  'Логин',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  width: 330,
                  margin: EdgeInsets.only(top: 30.0),
                ),
                Container(
                  child: TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                        labelText: 'Парол',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.lock)
                    ),
                  ),
                  width: 330,
                  margin: EdgeInsets.only(top: 30.0),
                ),



                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 30.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 330.0,
                            height: 45.0,
                            child: FlatButton(
                              onPressed: () async {
                                var username = _usernameController.text;
                                var password = _passwordController.text;
                                var jwt = await attemptLogIn(username, password);
                                if(jwt != null) {
                                  var token = jsonDecode(jwt);
                                  //log(token["token"]);
                                  //storage.write(key: "token", value: jwt);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => HomePage.fromBase64(jwt)
                                      )
                                  );
                                } else {
                                  displayDialog(context, "Ошибка", "Логин или пароль неправильный");
                                }
                              },
                              child: Text("ВХОД"),
                              color: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                          )



                        ],),
                    ),


                  ],
                )






              ],
            ),
          ),





        )
    );
  }
}