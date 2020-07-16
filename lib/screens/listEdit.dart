import 'package:alisveris_sepeti/model/alisveris_listesi.dart';
import 'package:alisveris_sepeti/utils/database_helper.dart';
import 'package:alisveris_sepeti/screens/shopList.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ListEdit extends StatefulWidget {
  AlisverisListesi alisverisListesi;
  ListEdit(this.alisverisListesi);
  DbHelper dbHelper = DbHelper();
  @override
  State<StatefulWidget> createState() => _ListEditState(alisverisListesi);
}

class _ListEditState extends State {
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();

  String _formListeAdi;
  String _formUrunler;

  String uyari = 'En az bir karakter girmelisin.';

  _ListEditState(this.alisverisListesi);
  AlisverisListesi alisverisListesi;
  DbHelper dbHelper = DbHelper();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: selectedThemeColorOne,
      appBar: AppBar(
        iconTheme: IconThemeData(color: selectedThemeColorTwo),
        backgroundColor: selectedThemeColorOne,
        elevation: 0,
        title: Text(
          '${alisverisListesi.listeAdi} Liste Düzenleme',
          style: TextStyle(color: selectedThemeColorTwo),
        ),
      ),
      body: SingleChildScrollView(
        child: buildBody(),
      ),
    );
  }

  Widget buildBody() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 20, right: 20, top: 10),
            child: Form(
              key: _formKey,
              child: TextFormField(
                initialValue: this.alisverisListesi.listeAdi,
                style: TextStyle(color: selectedThemeColorTwo),
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: selectedThemeColorTwo)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                    color: selectedThemeColorTwo.withOpacity(0.1),
                  )),
                  labelText: 'Liste Adı',
                  labelStyle: TextStyle(color: selectedThemeColorTwo),
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
                initialValue: this.alisverisListesi.urunler,
                style: TextStyle(color: selectedThemeColorTwo),
                maxLines: 4,
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: selectedThemeColorTwo)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                    color: selectedThemeColorTwo.withOpacity(0.1),
                  )),
                  labelText: 'Ürünlerin arasına virgül (" , ") koymayı unutma',
                  labelStyle: TextStyle(color: selectedThemeColorTwo),
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

  void _saveForm() async {
    // ignore: unused_local_variable
    int result;
    if (_formKey.currentState.validate() && _formKey2.currentState.validate()) {
      _formKey.currentState.save();
      _formKey2.currentState.save();

      this.alisverisListesi.listeAdi = _formListeAdi;
      this.alisverisListesi.urunler = _formUrunler;

      result = await dbHelper.update(alisverisListesi);

      Navigator.pop(context);
    }
  }
}
