import 'dart:convert';

import 'package:alisveris_sepeti/model/alisveris_listesi.dart';
import 'package:alisveris_sepeti/screens/shopList.dart';
import 'package:alisveris_sepeti/utils/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class ListDetail extends StatefulWidget {
  AlisverisListesi alisverisListesi;
  ListDetail(this.alisverisListesi);
  @override
  State<StatefulWidget> createState() => _ListDetailState(alisverisListesi);
}

class _ListDetailState extends State {
  DbHelper dbHelper = DbHelper();
  AlisverisListesi alisverisListesi;
  _ListDetailState(this.alisverisListesi);
  List geciciListe;
  var alinacaklar;

  @override
  void initState() {
    super.initState();
    alinacaklar = jsonDecode(alisverisListesi.jsonUrunler);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: selectedThemeColorOne,
      appBar: AppBar(
        iconTheme: IconThemeData(color: selectedThemeColorTwo),
        backgroundColor: selectedThemeColorOne,
        elevation: 0,
        title: Text(
          '${alisverisListesi.listeAdi} Liste Detayı',
          style: TextStyle(color: selectedThemeColorTwo),
        ),
      ),
      body: ListView.builder(
          itemCount: alinacaklar.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
              child: Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                      color: selectedThemeColorTwo,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(30),
                          bottomLeft: Radius.circular(30))),
                  child: Center(
                    child: CheckboxListTile(
                        activeColor: selectedThemeColorOne,
                        title: Text(
                          alinacaklar[index]['urun'],
                          style: TextStyle(
                            fontSize: 35,
                            color: selectedThemeColorOne,
                          ),
                        ),
                        value: alinacaklar[index]['deger'],
                        onChanged: (bool value) {
                          setState(() {
                            alinacaklar[index]['deger'] = value;
                            listeGuncelle();
                          });
                        }),
                  )),
            );
          }),
    );
  }

  listeGuncelle() async {
    int result;
    alisverisListesi.jsonUrunler = jsonEncode(alinacaklar);
    result = await dbHelper.update(alisverisListesi);
  }
}
