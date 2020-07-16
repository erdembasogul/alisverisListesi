import 'dart:convert';

import 'package:alisveris_sepeti/model/alisveris_listesi.dart';
import 'package:alisveris_sepeti/screens/shopList.dart';
import 'package:alisveris_sepeti/utils/database_helper.dart';
import 'package:flutter/material.dart';

class AddList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AddListState();
}

class _AddListState extends State {
  String uyari = 'En az bir karakter girmelisin.';
  int disardanListe = 0;
  String disardanListeEklemek = 'Dışarıdan Liste Eklemek İçin Tıklayın';

  DbHelper dbHelper = DbHelper();

  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  final _formKey3 = GlobalKey<FormState>();

  String _formListeAdi;
  String _formUrunler;
  String _jsonDosya;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: selectedThemeColorOne,
      appBar: AppBar(
        iconTheme: IconThemeData(color: selectedThemeColorTwo),
        title: Text(
          'Alışveriş Listesi Oluşturma',
          style: TextStyle(color: selectedThemeColorTwo),
        ),
        backgroundColor: selectedThemeColorOne,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 0),
              child: Container(
                height: 50,
                width: 375,
                decoration: BoxDecoration(
                    color: selectedThemeColorTwo,
                    border: Border.all(color: selectedThemeColorOne),
                    borderRadius: BorderRadius.circular(5.0)),
                child: Padding(
                  padding: EdgeInsets.only(left: 8, right: 8),
                  child: GestureDetector(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          disardanListeEklemek,
                          style: TextStyle(
                              color: selectedThemeColorOne, fontSize: 17),
                        ),
                        Icon(
                          Icons.note_add,
                          color: selectedThemeColorOne,
                        )
                      ],
                    ),
                    onTap: () {
                      if (disardanListe == 0) {
                        setState(() {
                          disardanListe = 1;
                          disardanListeEklemek =
                              'Liste Olusturmak Icin Tiklayin';
                          
                        });
                      } else {
                        setState(() {
                          disardanListe = 0;
                          disardanListeEklemek =
                              'Dışarıdan Liste Eklemek İçin Tıklayın';
                          
                        });
                      }
                    },
                  ),
                ),
              ),
            ),
            Container(
              child: disardanListe == 0
                  ? buildListeOlustur()
                  : Container(
                      padding: EdgeInsets.only(top: 25),
                      child: buildDisardanListe(),
                    ),
            )
          ],
        ),
      ),
    );
  }

  buildListeOlustur() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
              top: 10,
              left: 20,
              right: 20,
            ),
            child: Form(
              key: _formKey,
              child: TextFormField(
                style: TextStyle(color: selectedThemeColorTwo),
                cursorColor: selectedThemeColorTwo,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: selectedThemeColorTwo)),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.purple)),
                  labelText: 'Liste Adı',
                  labelStyle: TextStyle(color: selectedThemeColorTwo),
                  fillColor: selectedThemeColorTwo,
                  contentPadding:
                      EdgeInsets.only(left: 15, bottom: 11, top: 40, right: 15),
                ),
                // ignore: missing_return
                validator: (String value) {
                  if (value.length < 1) {
                    return uyari;
                  }
                },
                onSaved: (newValue) => _formListeAdi = newValue,
                autofocus: true,
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: EdgeInsets.only(left: 20, right: 20, bottom: 14),
            child: Form(
              key: _formKey2,
              child: TextFormField(
                style: TextStyle(color: selectedThemeColorTwo),
                maxLines: 4,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black45)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: selectedThemeColorTwo)),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.purple),
                  ),
                  labelText: 'Ürünlerin arasına virgül (" , ") koymayı unutma',
                  labelStyle: TextStyle(color: selectedThemeColorTwo),
                  hintText: 'Ürünlerin arasına virgül (" , ") koymayı unutma',
                  hintStyle: TextStyle(color: selectedThemeColorTwo),
                  fillColor: selectedThemeColorTwo,
                  contentPadding:
                      EdgeInsets.only(left: 15, bottom: 11, top: 40, right: 15),
                ),
                // ignore: missing_return
                validator: (String value) {
                  if (value.length < 1) {
                    return uyari;
                  }
                },
                onSaved: (newValue) => _formUrunler = newValue,
                autofocus: true,
              ),
            ),
          ),
          RaisedButton(
            child: Text(
              "Listeyi Kaydet",
              style: TextStyle(color: selectedThemeColorOne),
            ),
            color: selectedThemeColorTwo,
            onPressed: _saveForm,
          )
        ],
      ),
    );
  }

  buildDisardanListe() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 20, right: 20, bottom: 14),
            child: Form(
              key: _formKey3,
              child: TextFormField(
                style: TextStyle(color: selectedThemeColorTwo),
                maxLines: 6,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  disabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black45)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: selectedThemeColorTwo)),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.purple),
                  ),
                  labelText: 'Listeyi Buraya Yapıştırın',
                  labelStyle: TextStyle(color: selectedThemeColorTwo),
                  fillColor: selectedThemeColorTwo,
                  contentPadding:
                      EdgeInsets.only(left: 15, bottom: 11, top: 40, right: 15),
                ),
                // ignore: missing_return
                validator: (String value) {
                  if (value.length < 1) {
                    return uyari;
                  }
                },
                onSaved: (newValue) => _jsonDosya = newValue,
                autofocus: true,
              ),
            ),
          ),
          RaisedButton(
            child: Text(
              "Listeyi Kaydet",
              style: TextStyle(color: selectedThemeColorOne),
            ),
            color: selectedThemeColorTwo,
            onPressed: _saveImportList,
          )
        ],
      ),
    );
  }

  void _saveForm() async {
    // ignore: unused_local_variable
    int result;
    if (_formKey.currentState.validate() && _formKey2.currentState.validate()) {
      _formKey.currentState.save();
      _formKey2.currentState.save();

      AlisverisListesi alisverisListesi =
          AlisverisListesi(_formListeAdi, _formUrunler);

      result = await dbHelper.insert(alisverisListesi);

      Navigator.pop(context);
    }
  }

  void _saveImportList() async {
    int result;
    if (_formKey3.currentState.validate()) {
      _formKey3.currentState.save();
    }
    var gelenListe = jsonDecode(_jsonDosya);

    String listeAdi = gelenListe['listeAdi'];
    String urunler = gelenListe['urunler'];
    String jsonUrunler = gelenListe['jsonUrunler'];

    AlisverisListesi alisverisListesi = AlisverisListesi(listeAdi, urunler);
    alisverisListesi.jsonUrunler = jsonUrunler;

    result = await dbHelper.insert(alisverisListesi);
    Navigator.pop(context);
  }
}
