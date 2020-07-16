import 'package:alisveris_sepeti/screens/shopList.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primaryColor: selectedThemeColorOne,
          accentColor: selectedThemeColorOne),
      debugShowCheckedModeBanner: false,
      title: 'Alisveris Listesi',
      home: ShoppingList(),
    );
  }
}
