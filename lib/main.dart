import 'package:flutter/material.dart';
import 'package:flutter_get_new_version/common/strings.dart';
import 'package:flutter_get_new_version/updater_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(title: 'Flutter get new version app'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return UpdaterPage(Scaffold(
        //调用UpdaterPage
        appBar: new AppBar(
          backgroundColor: Color(0xFF384F6F),
          centerTitle: true,
          title: new Text("Home"),
          iconTheme: new IconThemeData(color: Color(0xFF384F6F)),
        ),
        body: new Text(Strings.home)));
  }
}
