import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:test_3/data/model/crypto.dart';
import 'package:test_3/data/model/user.dart';
import 'package:test_3/screen/coin_listscreen.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class homescreen extends StatefulWidget {
  const homescreen({super.key});

  @override
  State<homescreen> createState() => _homescreenState();
}

class _homescreenState extends State<homescreen> {
  String title = 'loading...';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'mh'),
      home: Scaffold(
        backgroundColor: Colors.grey[800],
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(image: AssetImage('assets/images/logo.png')),
              SpinKitWave(
                color: Colors.white,
                size: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> getdata() async {
    var response = await Dio().get('https://api.coincap.io/v2/assets');
    List<crypto> cryptolist = response.data['data']
        .map<crypto>((jsonMapObject) => crypto.fromMapJSON(jsonMapObject))
        .toList();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => coinlistscreen(
          cryptolist: cryptolist,
        ),
      ),
    );
  }
}
