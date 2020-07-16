import 'dart:convert';

class AlisverisListesi {
  int _id;
  String _listeAdi;
  String _urunler;
  String _jsonUrunler;
  int _tamamlandiMi = 0;

  int get id => _id;
  String get listeAdi => _listeAdi;
  String get urunler => _urunler;

  String get jsonUrunler => _jsonUrunler;

  int get tamamlandiMi => _tamamlandiMi;

  set id(int value) {
    _id = value;
  }

  set listeAdi(String value) {
    _listeAdi = value;
  }

  set urunler(String value) {
    _urunler = value;
  }

  set jsonUrunler(String value) {
    _jsonUrunler = value;
  }

  set tamamlandiMi(int value) {
    _tamamlandiMi = value;
  }

  AlisverisListesi(this._listeAdi, this._urunler) {
    this._jsonUrunler = jsonOlustur();
    this._tamamlandiMi;
  }
  AlisverisListesi.withId(this._id, this._listeAdi, this._urunler) {
    this._jsonUrunler = jsonOlustur();
    this._tamamlandiMi;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['listeAdi'] = _listeAdi;
    map['urunler'] = _urunler;
    map['jsonUrunler'] = _jsonUrunler;
    map['tamamlandiMi'] = _tamamlandiMi;
    if (id != null) {
      map['id'] = _id;
    }

    return map;
  }

  AlisverisListesi.fromObject(dynamic o) {
    this._id = o['Id'];
    this._listeAdi = o['Listeadi'];
    this._urunler = o['Urunler'];
    this._jsonUrunler = o['Jsonurunler'];
    this._tamamlandiMi = o['Tamamlandimi'];
  }

  jsonOlustur() {
    List urunOlusturma = _urunler.split(',');
    List geciciListe = [];
    for (var i in urunOlusturma) {
      if (i.length > 0) {
        geciciListe.add(i);
      }
    }

    List alinacakUrunler = List<Map<String, dynamic>>.generate(
      geciciListe.length,
      (index) => {'urun': '${geciciListe[index]}', 'deger': false},
    );
    String jsonDosyasi = jsonEncode(alinacakUrunler);
    return jsonDosyasi;
  }

  
}
