import 'package:flutter/material.dart';
import 'package:report_app/auth.dart';
import 'package:report_app/home.dart';
import 'package:report_app/theme.dart';

//import routes

void main() {
  runApp(MaterialApp(
      //Setting
      title: 'Score Scanner Mobile Application',
      theme: myTheme,
      initialRoute: '/auth',
      routes: {
        '/auth': (BuildContext context) => new LoginUser(),
      })
    );
}