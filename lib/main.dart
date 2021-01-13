import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert' show json, base64, ascii;

import 'package:uztex_pro/PROApp.dart';

const API = 'http://pro.uztex.uz/api/v1';
final storage = FlutterSecureStorage();

void main() {
  runApp(PROApp());
}