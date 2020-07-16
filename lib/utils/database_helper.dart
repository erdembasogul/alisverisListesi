import 'dart:io';
import 'package:alisveris_sepeti/model/alisveris_listesi.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  String tblList = 'Lists';
  String colId = 'Id';
  String colListeAdi = 'Listeadi';
  String colUrunler = 'Urunler';
  String colJsonUrunler = 'Jsonurunler';
  String colTamamlandiMi = 'Tamamlandimi';
  static final DbHelper _dbHelper = DbHelper._internal();

  DbHelper._internal();

  factory DbHelper() {
    return _dbHelper;
  }

  static Database _db;

  Future<Database> get db async {
    if (_db == null) {
      _db = await initializeDb();
    }
    return _db;
  }

  Future<Database> initializeDb() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'shoppinglist.db';

    var dbShoppingList =
        await openDatabase(path, version: 1, onCreate: _createDb);
    return dbShoppingList;
  }

  void _createDb(Database db, int version) async {
    await db.execute(
        'Create table $tblList($colId integer primary key,$colListeAdi text,$colUrunler text,$colJsonUrunler text,$colTamamlandiMi integer)');
  }

  Future<int> insert(AlisverisListesi alisverisListesi) async {
    Database db = await this.db;
    var result = await db.insert(tblList, alisverisListesi.toMap());

    return result;
  }

  Future<int> update(AlisverisListesi alisverisListesi) async {
    Database db = await this.db;
    var result = await db.update(tblList, alisverisListesi.toMap(),
        where: '$colId = ?', whereArgs: [alisverisListesi.id]);
    return result;
  }

  Future<int> delete(int id) async {
    Database db = await this.db;
    var result = await db.rawDelete('Delete from $tblList where $colId = $id');
    return result;
  }

  Future<List> getLists() async {
    Database db = await this.db;
    var result = await db.rawQuery('Select * from $tblList');

    return result;
  }
}
