import 'dart:convert';
import 'dart:io';
import 'package:hexcolor/hexcolor.dart';
import 'package:share/share.dart';
import 'package:alisveris_sepeti/model/alisveris_listesi.dart';
import 'package:alisveris_sepeti/model/colors.dart';
import 'package:alisveris_sepeti/screens/listDetail.dart';
import 'package:alisveris_sepeti/screens/listEdit.dart';
import 'package:alisveris_sepeti/utils/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'addList.dart';

var iconCompleted = Icon(Icons.check_box);
var iconUncompleted = Icon(Icons.check_box_outline_blank);

var selectedThemeColorOne;
var selectedThemeColorTwo = Hexcolor('#FFFFFF');

class ShoppingList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ShoppingListState();
}

class _ShoppingListState extends State {
  int selectedIndex = 0;
  AlisverisListesi alisverisListesi;
  DbHelper dbHelper = DbHelper();
  List<AlisverisListesi> lists;
  List<AlisverisListesi> completedLists;
  int count = 0;
  int completedCount;
  @override
  void initState() {
    super.initState();
    _verileriGetir().then((value) {
      setState(() {
        selectedThemeColorOne = Hexcolor(value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (lists == null) {
      lists = List<AlisverisListesi>();
      getData();
    }

    return Scaffold(
        body: Column(
          children: <Widget>[
            ClipPath(
              clipper: MyClipper(),
              child: Container(
                height: 270,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [selectedThemeColorOne, selectedThemeColorTwo],
                  ),
                ),
                child: Align(
                    alignment: Alignment.center,
                    child: Image(
                      fit: BoxFit.fitWidth,
                      image: AssetImage('assets/images/shoppingcart.png'),
                    )),
              ),
            ),
            secondContainer()
          ],
        ),
        // ignore: missing_return
        floatingActionButton: (() {
          if (selectedIndex == 0 || selectedIndex == 1) {
            return FloatingActionButton(
              onPressed: goToAdd,
              elevation: 0,
              child: SvgPicture.asset('assets/icons/shopping_bag.svg'),
              backgroundColor: Colors.transparent,
            );
          }
        }()),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: selectedThemeColorTwo,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.last_page),
              title: Text('Son Eklenen'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              title: Text('Tüm Listeler'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.style),
              title: Text('Temalar'),
            ),
          ],
          currentIndex: selectedIndex,
          selectedItemColor: selectedThemeColorOne,
          selectedFontSize: 15,
          onTap: onItemTapped,
        ));
  }

  onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  secondContainer() {
    return Expanded(
        child: (() {
      if (selectedIndex == 0) {
        return latestShoppingListItem();
      } else if (selectedIndex == 1) {
        return shoppingListItems();
      } else {
        return themes();
      }
    }()));
  }

  shoppingListItems() {
    return Container(
        padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
        child: (() {
          if (lists.length == 0) {
            return Container(
                width: 400,
                height: 50,
                decoration: BoxDecoration(
                    color: selectedThemeColorOne,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                      bottomLeft: Radius.circular(30),
                    )),
                child: Center(
                  child: Text(
                    'Hic Liste Yok :(',
                    style:
                        TextStyle(color: selectedThemeColorTwo, fontSize: 45),
                  ),
                ));
          } else {
            return ListView.builder(
              itemCount: count,
              itemBuilder: (BuildContext context, int position) {
                return Container(
                    margin: EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                        color: selectedThemeColorOne.withOpacity(0.8),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30))),
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          title: Center(
                              child: Row(
                            children: <Widget>[
                              IconButton(
                                  icon: this.lists[position].tamamlandiMi == 0
                                      ? Icon(
                                          Icons.check_box_outline_blank,
                                          color: selectedThemeColorTwo,
                                        )
                                      : Icon(
                                          Icons.check_box,
                                          color: selectedThemeColorTwo,
                                        ),
                                  onPressed: () {
                                    if (this.lists[position].tamamlandiMi ==
                                        0) {
                                      this.lists[position].tamamlandiMi = 1;
                                      dbHelper.update(this.lists[position]);
                                      getData();
                                    } else {
                                      this.lists[position].tamamlandiMi = 0;
                                      dbHelper.update(this.lists[position]);
                                      getData();
                                    }
                                  }),
                              Text(
                                this.lists[position].listeAdi,
                                style: TextStyle(
                                    decoration:
                                        this.lists[position].tamamlandiMi == 1
                                            ? TextDecoration.lineThrough
                                            : TextDecoration.none,
                                    fontSize: 25,
                                    color: selectedThemeColorTwo),
                              ),
                            ],
                          )),
                          subtitle: Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Center(
                              child: Text(
                                this.lists[position].urunler,
                                style: TextStyle(color: selectedThemeColorTwo),
                              ),
                            ),
                          ),
                          onTap: () {
                            goToDetail(this.lists[position]);
                            getData();
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: selectedThemeColorTwo,
                                ),
                                onPressed: () {
                                  deleteSelectedList(this.lists[position]);
                                }),
                            IconButton(
                                icon: Icon(Icons.edit,
                                    color: selectedThemeColorTwo),
                                onPressed: () {
                                  goToEdit(this.lists[position]);
                                }),
                            IconButton(
                                icon: Icon(Icons.share,
                                    color: selectedThemeColorTwo),
                                onPressed: () {
                                  Share.share(
                                      listeGonder(this.lists[position]));
                                })
                          ],
                        )
                      ],
                    ));
              },
            );
          }
        }()));
  }

  latestShoppingListItem() {
    return Container(
        padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
        child: (() {
          if (lists.length == 0) {
            return Container(
                width: 400,
                height: 50,
                decoration: BoxDecoration(
                    color: selectedThemeColorOne,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                      bottomLeft: Radius.circular(30),
                    )),
                child: Center(
                  child: Text(
                    'Hic Liste Yok :(',
                    style:
                        TextStyle(color: selectedThemeColorTwo, fontSize: 45),
                  ),
                ));
          } else {
            return ListView.builder(
              itemCount: 1,
              itemBuilder: (BuildContext context, int position) {
                getData();
                return Container(
                    decoration: BoxDecoration(
                        color: selectedThemeColorOne.withOpacity(0.8),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30))),
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          title: Center(
                              child: Row(
                            children: <Widget>[
                              IconButton(
                                  icon: this.lists.last.tamamlandiMi == 0
                                      ? Icon(
                                          Icons.check_box_outline_blank,
                                          color: selectedThemeColorTwo,
                                        )
                                      : Icon(
                                          Icons.check_box,
                                          color: selectedThemeColorTwo,
                                        ),
                                  onPressed: () {
                                    if (this.lists.last.tamamlandiMi == 0) {
                                      this.lists.last.tamamlandiMi = 1;
                                      dbHelper.update(this.lists.last);
                                      getData();
                                    } else {
                                      this.lists.last.tamamlandiMi = 0;
                                      dbHelper.update(this.lists.last);
                                      getData();
                                    }
                                  }),
                              Text(
                                this.lists.last.listeAdi,
                                style: TextStyle(
                                    decoration:
                                        this.lists.last.tamamlandiMi == 1
                                            ? TextDecoration.lineThrough
                                            : TextDecoration.none,
                                    fontSize: 25,
                                    color: selectedThemeColorTwo),
                              ),
                            ],
                          )),
                          subtitle: Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Center(
                              child: Text(
                                this.lists.last.urunler,
                                style: TextStyle(color: selectedThemeColorTwo),
                              ),
                            ),
                          ),
                          onTap: () {
                            goToDetail(this.lists.last);
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: selectedThemeColorTwo,
                                ),
                                onPressed: () {
                                  deleteSelectedList(this.lists.last);
                                }),
                            IconButton(
                                icon: Icon(Icons.edit,
                                    color: selectedThemeColorTwo),
                                onPressed: () {
                                  goToEdit(this.lists.last);
                                }),
                            IconButton(
                                icon: Icon(Icons.share,
                                    color: selectedThemeColorTwo),
                                onPressed: () {
                                  Share.share(listeGonder(this.lists.last));
                                })
                          ],
                        )
                      ],
                    ));
              },
            );
          }
        }()));
  }

  themes() {
    return SingleChildScrollView(
      child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30))),
          child: Padding(
            padding: EdgeInsets.only(
              left: 30,
              top: 20,
              right: 30,
            ),
            child: Column(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Container(
                      height: 40,
                      width: 300,
                      decoration: BoxDecoration(
                          color: selectedThemeColorOne,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                              bottomLeft: Radius.circular(30),
                              bottomRight: Radius.circular(30))),
                      child: Center(
                        child: Text(
                          'Temalar',
                          style: TextStyle(
                              color: selectedThemeColorTwo, fontSize: 30),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 40),
                Padding(
                  padding: EdgeInsets.only(bottom: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        height: 75,
                        width: 150,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              Hexcolor(themeColorNine),
                              selectedThemeColorTwo
                            ]),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30),
                                bottomLeft: Radius.circular(30),
                                bottomRight: Radius.circular(30))),
                        child: IconButton(
                            icon: Icon(null),
                            onPressed: () {
                              setState(() {
                                selectedThemeColorOne =
                                    Hexcolor(themeColorNine);
                              });
                              _verileriKaydet(themeColorNine);
                            }),
                      ),
                      Container(
                        height: 75,
                        width: 150,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              Hexcolor(themeColorThree),
                              selectedThemeColorTwo
                            ]),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30),
                                bottomLeft: Radius.circular(30),
                                bottomRight: Radius.circular(30))),
                        child: IconButton(
                            icon: Icon(null),
                            onPressed: () {
                              setState(() {
                                selectedThemeColorOne =
                                    Hexcolor(themeColorThree);
                              });
                              _verileriKaydet(themeColorThree);
                            }),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        height: 75,
                        width: 150,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              Hexcolor(themeColorFive),
                              selectedThemeColorTwo
                            ]),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30),
                                bottomLeft: Radius.circular(30),
                                bottomRight: Radius.circular(30))),
                        child: IconButton(
                            icon: Icon(null),
                            onPressed: () {
                              setState(() {
                                selectedThemeColorOne =
                                    Hexcolor(themeColorFive);
                              });
                              _verileriKaydet(themeColorFive);
                            }),
                      ),
                      Container(
                        height: 75,
                        width: 150,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              Hexcolor(themeColorSeven),
                              selectedThemeColorTwo
                            ]),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30),
                                bottomLeft: Radius.circular(30),
                                bottomRight: Radius.circular(30))),
                        child: IconButton(
                            icon: Icon(null),
                            onPressed: () {
                              setState(() {
                                selectedThemeColorOne =
                                    Hexcolor(themeColorSeven);
                              });
                              _verileriKaydet(themeColorSeven);
                            }),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        height: 75,
                        width: 150,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              Hexcolor(mainColorOne),
                              selectedThemeColorTwo
                            ]),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30),
                                bottomLeft: Radius.circular(30),
                                bottomRight: Radius.circular(30))),
                        child: IconButton(
                            icon: Icon(null),
                            onPressed: () {
                              setState(() {
                                selectedThemeColorOne = Hexcolor(mainColorOne);
                              });
                              _verileriKaydet(mainColorOne);
                            }),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }

  _verileriKaydet(color) async {
    var tema1 = color;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('tema1', tema1);
  }

  Future<String> _verileriGetir() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var tema1 = prefs.getString('tema1');

    if (tema1 == null) {
      setState(() {
        selectedThemeColorOne = Hexcolor(mainColorOne);
      });
    }
    return tema1;
  }

  void getData() {
    var dbFuture = dbHelper.initializeDb();
    dbFuture.then((value) {
      var listsFuture = dbHelper.getLists();

      listsFuture.then((data) {
        List<AlisverisListesi> listsData = List<AlisverisListesi>();
        count = data.length;
        for (int i = 0; i < count; i++) {
          listsData.add(AlisverisListesi.fromObject(data[i]));
        }

        setState(() {
          lists = listsData;
          count = count;
        });
      });
    });
  }

  void goToEdit(AlisverisListesi alisverisListesi) async {
    int result;
    result = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => ListEdit(alisverisListesi)));
    if (result == 1 || result == 0) {
      getData();
    }
    getData();
  }

  void goToDetail(AlisverisListesi alisverisListesi) async {
    int result;
    result = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => ListDetail(alisverisListesi)));

    if (result == 1 || result == 0) {
      getData();
    }
    getData();
  }

  void goToAdd() async {
    int result;

    result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => AddList()));
    if (result != 0) {
      getData();
    }
  }

  void deleteSelectedList(AlisverisListesi alisverisListesi) async {
    int result;
    result = await dbHelper.delete(alisverisListesi.id);

    if (result != 0) {}
    getData();
  }

  listeGonder(AlisverisListesi alisverisListesi) {
    var map = Map<String, dynamic>();
    map['listeAdi'] = alisverisListesi.listeAdi;
    map['urunler'] = alisverisListesi.urunler;
    map['jsonUrunler'] = alisverisListesi.jsonUrunler;

    return jsonEncode(map);
  }
}

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 80);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 80);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
