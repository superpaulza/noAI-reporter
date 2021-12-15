  import 'package:flutter/material.dart';


      MaterialColor PrimaryMaterialColor = MaterialColor(
      4294940928,
      <int, Color>{
        50: Color.fromRGBO(
          255,
          153,
          0,
          .1,
        ),
        100: Color.fromRGBO(
          255,
          153,
          0,
          .2,
        ),
        200: Color.fromRGBO(
          255,
          153,
          0,
          .3,
        ),
        300: Color.fromRGBO(
          255,
          153,
          0,
          .4,
        ),
        400: Color.fromRGBO(
          255,
          153,
          0,
          .5,
        ),
        500: Color.fromRGBO(
          255,
          153,
          0,
          .6,
        ),
        600: Color.fromRGBO(
          255,
          153,
          0,
          .7,
        ),
        700: Color.fromRGBO(
          255,
          153,
          0,
          .8,
        ),
        800: Color.fromRGBO(
          255,
          153,
          0,
          .9,
        ),
        900: Color.fromRGBO(
          255,
          153,
          0,
          1,
        ),
      },
    );

    ThemeData myTheme = ThemeData(
      fontFamily: "customFont",
      primaryColor: Color(0xffff9900),
      buttonColor: Color(0xffff9900),
      accentColor: Color(0xffff9900),
      scaffoldBackgroundColor: Colors.black,

      primarySwatch: PrimaryMaterialColor,

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            Color(0xffff9900),
          ),
        ),
      ),
    );
  