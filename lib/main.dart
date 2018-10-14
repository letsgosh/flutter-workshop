import 'package:flutter/material.dart';
import 'widgets/home.dart';
import 'widgets/splash.dart';

void main() => runApp(new MaterialApp(
      title: 'Flutter Workshop',
      home: new SplashPage(),
      routes: <String, WidgetBuilder>{
        '/HomePage': (BuildContext context) => new HomePage()
      },
    ));
