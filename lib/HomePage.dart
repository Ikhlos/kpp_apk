import 'dart:developer';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';
import 'dart:async';
import "dart:convert";
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert' show json, base64, ascii, jsonDecode, utf8;
import 'package:http/http.dart' as http;
import 'package:uztex_pro/main.dart';

class HomePage extends StatefulWidget {
  HomePage(this.jwt, this.payload);

  factory HomePage.fromBase64(String jwt) =>
      HomePage(
          jwt,
          jsonDecode(jwt)
      );

  final String jwt;
  final Map<String, dynamic> payload;

  @override
  _HomePageState createState() => _HomePageState(jwt);
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _barcodeController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  List data = [];
  bool vText=false;
  List localData = [];
  List postData = [];
  FocusNode myFocusNode;
  String jwt;

  List<bool> _isChecked;
  String idMat;
  _HomePageState(String jwt) {
    this.jwt=jwt;
  }
 fetchBarcode(String id, String token) async {
//    material_purchase-app-details/
   http://pro.uztex.uz/api/v1/texmansys/material-purchase-application/2696/
    var res = await http.get(
    "$API/texmansys/material-purchase-application/${id}/",
    headers: {"Authorization": "Bearer " + jsonDecode(token)["token"]}
    );
    final jsonResponse = json.decode(utf8.decode(res.bodyBytes));
      setState(() {
        data = jsonResponse['data']['details'];
        localData = jsonResponse['data']['details'];
      });
      if(data.length>0){
        _isChecked = List<bool>.filled(data.length, false);
      }
    print(data);
//    return data;
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myFocusNode = FocusNode();
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UZTEX PRO Mobile'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
              child:Stack(
                  children:[ Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
//                      color: Color.fromRGBO(255, 179, 102, 0.7),
                            alignment: Alignment.center,
                            padding: EdgeInsets.only(top: 10.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  child: TextField(
                                    controller: _barcodeController,
                                    textInputAction: TextInputAction.go,
                                    onChanged: (val){

                                    },
                                    onSubmitted: (vl){
                                      setState(() {
                                        idMat=vl;
                                      });
                                      Future bd = fetchBarcode(vl, this.jwt);
                                      print(bd);
//                                if(bd != null){
//                                  showDialog(
//                                      context: context,
//                                      builder: (_)=> AlertDialog(
//                                        title: Text("Ощибка"),
//                                        content: Text("Не найден!"),
//                                        actions: [
//                                          FlatButton(
//                                            child: Text("Продолжить"),
//                                            onPressed: (){
//                                              Navigator.pop(context);
//                                              myFocusNode.requestFocus();
//                                              _barcodeController.clear();
//                                            },
//                                          )
//                                        ],
//                                      ),
//                                      barrierDismissible: false
//                                  );
//                                }
//                      print(vl);
//                      print(bd);
                                    },
                                    obscureText: false,
                                    focusNode: myFocusNode,
                                    decoration: InputDecoration(
                                      labelText:  'ID',
                                      border: OutlineInputBorder(),
                                    ),
                                  ),
                                  width: 330,
                                  margin: EdgeInsets.only(top: 30.0),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      iconSize: 40,
                                      padding: EdgeInsets.only(top: 20.0),
                                      alignment: Alignment.center,
                                      icon: Icon(Icons.search),
                                      onPressed: (){
                                        setState(() {
                                          vText = !vText;
                                        });
                                      },
                                    ),
                                    Visibility(
                                        visible: vText,
                                        child:Container(
                                          alignment: Alignment.topCenter,
                                          child: TextField(
                                            controller: _searchController,
//                              textInputAction: TextInputAction.go,
                                            onChanged: (val){
//                                setState(() {
//                                  data = [];
//                                });
//                                print(val);
                                              List dd = [];
                                              if(val.isNotEmpty){
                                                data.forEach((element) {
//                                  print(element['id']);
                                                  if(element['id'].toString()==val){
//                                    print(element);
                                                    dd.add(element);
                                                    setState(() {
                                                      data = dd;
                                                    });
                                                  }
                                                  print(dd);
                                                });
                                              }else{
                                                setState(() {
                                                  data = localData;
                                                });
                                              }

//                                print(data.length);
                                            },
                                            onSubmitted: (vl){

                                            },
                                            obscureText: false,
//                              focusNode: myFocusNode,
                                            decoration: InputDecoration(
                                              labelText: "Поиск",
//                                     hintText: "Search",
//                                     prefixIcon: Icon(Icons.search),
//                                     suffixIcon: _searchController.text.isEmpty
//                                         ? null
//                                         : InkWell(
//                                       onTap: () => _searchController.clear(),
//                                       child: Icon(Icons.clear),
//                                     ),
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(10.0),
                                                ),
                                              ),
                                            ),
                                          ),
                                          width: 150,
                                          margin: EdgeInsets.only(top: 30.0),
                                        )
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      itemCount: data.length,
                                      itemBuilder: (context, index) {
                                        return CheckboxListTile(
                                          title: Text(data[index]['id'].toString()+"."+data[index]['material_name']+" "+data[index]['amount'].toString()+" "+data[index]['m_unit_name']),
                                          value: _isChecked[index],
                                          onChanged: (val) {
//                                      print(val);
                                            if(val==true){
                                              postData.add(data[index]['id']);
                                              setState(() {
                                                postData = postData;
                                              });
                                              print(postData);
                                            }else{
                                              postData.removeWhere((element) => element==data[index]['id']);
//                                        print(f);
                                              setState(() {
                                                postData = postData;
                                              });
                                              print(postData);
                                            }
//                                      print(data[index]);
                                            setState(() {
                                              _isChecked[index] = val;
                                            },
                                            );
//                                      print(_isChecked);
                                          },
                                        );
                                      },
                                    )
//                              for (var i in data)
//                                Text(data.length>0 ? data[i]['material_name'] : "", style: TextStyle(fontSize: 25),),
//                              Row(
//                                mainAxisAlignment: MainAxisAlignment.center,
//                                children: [
//                                  Text(data.length>0 ? data[i]['amount'].toString() : "", style: TextStyle(fontSize: 25),),
//                                  Text(data.length>0 ? data[i]['m_unit_name'] : "", style: TextStyle(fontSize: 25),),
//                                ],
//                              )
                                  ],
                                )
                              ],),
                          ),


                        ],
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
                                      print('ss');
                                      var dataPost = {
                                        "mpad":postData,
                                      };
                                      var dtp = jsonEncode(dataPost);
                                      var res = await http.post(
                                          "$API/texmansys/arrived-material/",
                                          headers: {
                                            "Content-Type":"application/json",
                                            "Authorization": "Bearer " + jsonDecode(this.jwt)["token"],
                                          },

                                          body:dtp.toString()
                                      );
                                      if(res.statusCode == 201){
                                        setState(() {
                                          data = [];
                                        });
                                        showDialog(
                                            context: context,
                                            builder: (_)=> AlertDialog(
                                              title: Text("Успешно"),
                                              content: Text("Успешно завершено!"),
                                              actions: [
                                                FlatButton(
                                                  child: Text("Продолжить"),
                                                  onPressed: (){
                                                    Navigator.pop(context);
                                                    myFocusNode.requestFocus();
                                                    _barcodeController.clear();
                                                  },
                                                )
                                              ],
                                            ),
                                            barrierDismissible: false
                                        );
                                      }else{
                                        showDialog(
                                            context: context,
                                            builder: (_)=> AlertDialog(
                                              title: Text("Ошибка"),
                                              content: Text("Произошла ошибка!"),
                                              actions: [
                                                FlatButton(
                                                  child: Text("Продолжить"),
                                                  onPressed: (){
                                                    Navigator.pop(context);
                                                    myFocusNode.requestFocus();
                                                    _barcodeController.clear();
                                                  },
                                                )
                                              ],
                                            ),
                                            barrierDismissible: false
                                        );
                                      }
                                    },
                                    child: Text("Проверил", style: TextStyle(fontSize: 20),),
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
                  ]
              )

          ),

      );



  }

}