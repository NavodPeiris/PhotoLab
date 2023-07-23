import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import './Home.dart';
import './Login.dart';
import './Register.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatefulWidget {

   @override
  _MyAppState createState() => _MyAppState();

}

class _MyAppState extends State<MyApp> {
  late StreamSubscription<User?> user;
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
  }

  @override
  void dispose() {
    user.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      /// check if user is signed (Open Chat page ) if user is not signed in (open welcome page)
      initialRoute:
          FirebaseAuth.instance.currentUser == null ? "/login" : "/",
      debugShowCheckedModeBanner: false,
      ///key value pair
      routes: {
        "/": (context) => Home(),
        "/login": (context) => Login(),
        "/register": (context) => Register(),
      },
    );
  }
}