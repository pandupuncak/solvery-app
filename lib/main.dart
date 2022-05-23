// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:english_words/english_words.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:test_drive/providers/authentication.dart';
import 'package:test_drive/screens/authentication_page.dart';
import 'package:test_drive/screens/design_review_page.dart';
import 'package:test_drive/screens/home_page.dart';
import 'package:test_drive/screens/orders_page.dart';
import 'package:test_drive/screens/registration_page.dart';
import 'package:test_drive/screens/repair_page.dart';
import 'package:test_drive/screens/review_page.dart';
import 'package:test_drive/screens/single_order_page.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<Authentication>(
          create: (_) => Authentication(FirebaseAuth.instance),
        ),
        StreamProvider(
          initialData: null,
          create: (context) => context.read<Authentication>().authStateChanges,
        )
      ],
      child: MaterialApp(
        title: 'Tukang.in',
        theme: ThemeData(
          // Add the 5 lines from here...
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Colors.orange,
          ),
        ),
        home: AuthenticationWrapper(),
        routes: <String, WidgetBuilder>{
          '/auth': (BuildContext context) => new SignInPage(),
          '/register': ((BuildContext context) => new RegistrationPage()),
          '/home': (BuildContext context) => new HomePage(),
          '/repair': (BuildContext context) => new RepairPage(),
          '/orders': (BuildContext context) => new OrdersPage(),
          '/order': (BuildContext context) => new SingleOrderPage(),
          '/design': (BuildContext context) => new DesignReviewPage(),
          //'/review': (BuildContext context) => new ReviewPage(reviews: null),
        },
      ),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User?>();
    if (firebaseUser != null) {
      return HomePage();
    }
    return SignInPage();
  }
}

class Logo extends StatelessWidget {
  const Logo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset('assets/images/logo.png'),
            Text(
              'Tukang.in',
              style: TextStyle(
                color: Color.fromRGBO(197, 79, 0, 1),
                fontFamily: 'SourceSansPro',
                fontSize: 40,
                letterSpacing: -0.3333333432674408,
                fontWeight: FontWeight.normal,
                height: 1,
              ),
            )
          ],
        ),
      ),
    );
  }
}
