import 'dart:io';

import 'package:flutter/material.dart';

class PreviewScreen extends StatelessWidget {

String picture;

PreviewScreen({
  Key? key,
  required this.picture
  }) : super(key: key);

@override
Widget build(BuildContext context) {
return Scaffold(
  body: new Image.file(File(picture),
    fit: BoxFit.cover,
    height: double.infinity,
    width: double.infinity,
    alignment: Alignment.center,
  ),);
}
}