import 'package:flutter/material.dart';
import './Home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "/",
      debugShowCheckedModeBanner: false,
      ///key value pair
      routes: {
        "/": (context) => Home(),
      //  "/login": (context) => Login(),
      //  "/register": (context) => Register(),
      },
    );
  }
}