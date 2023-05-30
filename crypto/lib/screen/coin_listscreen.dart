import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:test_3/data/constants/constants.dart';
import 'package:test_3/data/model/crypto.dart';
import 'package:test_3/data/model/user.dart';

class coinlistscreen extends StatefulWidget {
  coinlistscreen({super.key, this.cryptolist});
  List<crypto>? cryptolist;
  @override
  State<coinlistscreen> createState() => _coinlistscreenState();
}

class _coinlistscreenState extends State<coinlistscreen> {
  List<crypto>? cryptolist;
  bool issearchloadingvisibile = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cryptolist = widget.cryptolist;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('کریپتو بازار', style: TextStyle(fontFamily: 'mh')),
          centerTitle: true,
          backgroundColor: blackcolor,
          automaticallyImplyLeading: false,
        ),
        backgroundColor: blackcolor,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: TextField(
                    onChanged: (value) {
                      _filterlist(value);
                    },
                    decoration: InputDecoration(
                        hintText: 'اسم رمز ارز معتبر خود را وارد کنید',
                        hintStyle:
                            TextStyle(fontFamily: 'mh', color: Colors.white),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              BorderSide(width: 0, style: BorderStyle.none),
                        ),
                        filled: true,
                        fillColor: greencolor),
                  ),
                ),
              ),
              Visibility(
                visible: issearchloadingvisibile,
                child: Text(
                  '...در حال آپدیت اطلاعات رمز ارز ها',
                  style: TextStyle(color: greencolor, fontFamily: 'mh'),
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  backgroundColor: greencolor,
                  color: blackcolor,
                  onRefresh: () async {
                    List<crypto> freshdata = await _getdata();
                    setState(() {
                      cryptolist = freshdata;
                    });
                  },
                  child: ListView.builder(
                    itemCount: cryptolist!.length,
                    itemBuilder: (context, index) =>
                        _getlisttileitem(cryptolist![index]),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getlisttileitem(crypto crypto) {
    return ListTile(
      title: Text(
        crypto.name,
        style: TextStyle(color: greencolor),
      ),
      subtitle: Text(
        crypto.symbol,
        style: TextStyle(color: greycolor),
      ),
      leading: SizedBox(
        width: 30.0,
        child: Center(
          child: Text(
            crypto.rank.toString(),
            style: TextStyle(color: greycolor),
          ),
        ),
      ),
      trailing: SizedBox(
        width: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  crypto.priceUsd.toStringAsFixed(2),
                  style: TextStyle(color: greycolor, fontSize: 18),
                ),
                Text(
                  crypto.changePercent24Hr.toStringAsFixed(2),
                  style: TextStyle(
                    color: _getcolorchangetext(crypto.changePercent24Hr),
                  ),
                ),
              ],
            ),
            SizedBox(
                width: 30,
                child: Center(
                    child: _geticonchangepercent(crypto.changePercent24Hr)))
          ],
        ),
      ),
    );
  }

  Widget _geticonchangepercent(double percentchange) {
    return percentchange <= 0
        ? Icon(
            Icons.trending_down,
            size: 24,
            color: redcolor,
          )
        : Icon(
            Icons.trending_up,
            size: 24,
            color: greencolor,
          );
  }

  Color _getcolorchangetext(double percentchange) {
    return percentchange <= 0 ? redcolor : greencolor;
  }

  Future<List<crypto>> _getdata() async {
    var response = await Dio().get('https://api.coincap.io/v2/assets');
    List<crypto> cryptolist = response.data['data']
        .map<crypto>((jsonMapObject) => crypto.fromMapJSON(jsonMapObject))
        .toList();
    return cryptolist;
  }

  Future<void> _filterlist(String enterkeyword) async {
    List<crypto> cryptoresultlist = [];
    if (enterkeyword.isEmpty) {
      setState(() {
        issearchloadingvisibile = true;
      });
      var result = await _getdata();
      setState(() {
        cryptolist = result;
        issearchloadingvisibile = false;
      });
      return;
    }

    cryptoresultlist = cryptolist!.where((element) {
      return element.name.toLowerCase().contains(enterkeyword.toLowerCase());
    }).toList();

    setState(() {
      cryptolist = cryptoresultlist;
    });
  }
}
