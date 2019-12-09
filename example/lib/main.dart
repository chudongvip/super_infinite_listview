import 'package:flutter/material.dart';
import 'package:super_infinit_listview/super_infinit_listview.dart';

//For test
import 'dart:math';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Super infinite list view Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  num total = 100;//Show up to 100

  generateRandomString () {
    String alphabet = 'qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM';
    int strlenght = 30; /// 生成的字符串固定长度
    String left = '';
    for (var i = 0; i < strlenght; i++) {
      // right = right + (min + (Random().nextInt(max - min))).toString();
      left = left + alphabet[Random().nextInt(alphabet.length)];
    } 
    print(left);
    return left;
  }

  getList () {
    List list = [];
    for (var i = 0; i < 10; i++) {
      list.add(generateRandomString());
    }

    return { "list": list, "totalNumber": total };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Super infinite list view Demo'),
      ),
      body: Center(
        child: SuperInfiniteListView(
          itemBuilder: (item, index, list) {
            return ListTile(title: Text("$index"));
          },
          onRequest: getList,
        ),
      )
    );
  }
}
