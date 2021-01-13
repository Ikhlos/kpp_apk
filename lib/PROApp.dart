import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'dart:convert' show json, base64, ascii;
import 'package:uztex_pro/main.dart';
import 'package:uztex_pro/LoginPage.dart';
import 'package:uztex_pro/HomePage.dart';



class PROApp extends StatefulWidget{
  @override
  _ProMobile createState() => _ProMobile();
}

class _ProMobile extends State<PROApp> {
  @override
  void initState() {
    super.initState();
  }
  Future<String> get jwtOrEmpty async {
    try{
      var jwt = await storage.read(key: "jwt");
      if(jwt == null) return "";
    }
    catch(identifier) {
      return "";
    }
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Authentication Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
          future: jwtOrEmpty,
          builder: (context, snapshot) {
//            if(snapshot.connectionState == ConnectionState.waiting) return SplashScreen();
//            if(this._now==0){
//              return SplashScreen();
//            }else {
              if (!snapshot.hasData) return CircularProgressIndicator();

              if (snapshot.data != "") {
                var str = snapshot.data;
                var jwt = str.split(".");

                if (jwt.length != 3) {
                  return LoginPage();
                } else {
                  var payload = json.decode(
                      ascii.decode(base64.decode(base64.normalize(jwt[1]))));
                  if (DateTime.fromMillisecondsSinceEpoch(payload["exp"] * 1000)
                      .isAfter(DateTime.now())) {
                    return HomePage(str, payload);
                  } else {
                    return LoginPage();
                  }
                }
              } else {
                return LoginPage();
              }
//            }
          }
      ),
    );
  }
}

