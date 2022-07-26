
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



class demo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ListViews',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: Scaffold(
        appBar: AppBar(title: Text('ListViews')),
        body: BodyLayout(),
      ),
    );
  }
}

class BodyLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _myListView(context);
  }
}
Widget _myListView(BuildContext context) {
  return ListView(
    children: const <Widget>[
      ListTile(
        title: Text('Black'),
      ),
      ListTile(
        title: Text('White'),
      ),
      ListTile(
        title: Text('Grey'),
      ),
    ],
  );
}