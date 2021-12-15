// ignore_for_file: unnecessary_string_escapes, prefer_final_fields

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:report_app/home.dart';
import 'package:report_app/newReport.dart';
import 'package:image/image.dart' as im;
import 'package:crypto/crypto.dart';

class licenceRecordScreen extends StatefulWidget {

  String username;
  String picture;

  licenceRecordScreen({
    Key? key,
    required this.username,
    required this.picture
  }) : super(key: key);

  @override
    _licenceRecordScreenState createState() => _licenceRecordScreenState();

}
class _licenceRecordScreenState extends State<licenceRecordScreen> {
  static final Uri uploadEndPoint = Uri.parse('http://home112.ddns.net/report_api/tlpr.php');
  String base64Image = "";
  late File tmpFile = File(widget.picture);
  dynamic recognition = [];

  TextEditingController _licnumController = TextEditingController();
  TextEditingController _provinceController = TextEditingController();

  String status = '';
  String errMessage = 'Error Uploading Image';

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    startUpload();
  }

  void dispose() {
    super.dispose();
  }

  setStatus(String message) {
    setState(() {
      status = message;
    });
  }

  setJson(dynamic jsonData) {
    setState(() {
      recognition = jsonData;
      status = "Complete";
    });
  }

  startUpload() async {
    setStatus('Uploading Image...');
    if (null == tmpFile) {
      setStatus(errMessage);
      return;
    }
    log(status);
    setState(() {});
    String fileData = base64Encode(tmpFile.readAsBytesSync());
    // setStatus('Manually');
    // setState(() {});
    print(fileData);
    await upload(fileData);
  }
 
  upload(String fileData) async {
    await http.post(uploadEndPoint, body: {
      "image": fileData,
    }).then((result) {
      setStatus(result.statusCode == 200 ? "Complete" : errMessage);
      if(result.statusCode == 200 && result.body.startsWith('<')) {
        setStatus("Can\'t identify this image, please try again");
      } else {
        setJson(jsonDecode(result.body));
      }
    }).catchError((error) {
      setStatus(error);
    });
    log(status);
    setState(() {});
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Are you sure?'),
        content: new Text('Do you want to discard this record'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('No'),
          ),
          TextButton(
            onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(
                      username: widget.username,
                    ),
                  ),
                  (route) => false
                );
            },
            child: new Text('Yes'),
          ),
        ],
      ),
    )) ?? false;
  }

  Widget showStatus() {
    if(status == '') {
      return 
      Center(
        child: 
          Column(
            children: <Widget>[
              CircularProgressIndicator(),
              Text("Loading..")
            ],
          )
      );
    } 
    else if (status == 'Uploading Image...') {
      return 
      Center(
        child: 
          Column(
            children: <Widget>[
              CircularProgressIndicator(),
              Padding(
                padding: EdgeInsets.only(top: 30),
                child: Text(status),
              )
            ],
          )
      );
    }
    else if (status == 'Complete' || status == 'Manually') {
      if(status == 'Complete') {
        _licnumController.text = recognition['r_char'].toString().split('/').last + " " + recognition['r_digit'];
        _provinceController.text = recognition['r_province'];
      }
      return 
        Column(
          children: <Widget>[
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _licnumController,
                  maxLength: 20,
                  decoration: InputDecoration(
                    // isDense: true,
                    // filled: true,
                    // fillColor: Colors.blue.shade100,
                    border: OutlineInputBorder(),
                    labelText: 'Licence Plate Number',
                    // hintText: 'hint',
                    // helperText: 'help',
                    // counterText: 'counter',
                    // icon: Icon(Icons.star),
                    prefixIcon: Icon(Icons.featured_play_list_outlined),
                    // suffixIcon: Icon(Icons.park),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? '* Cannot be empty!' : null,
                  onSaved: (String? value) {
                      print('Value for field saved as "$value"');
                  },
                ),
                Padding(padding: EdgeInsets.all(10)),
                TextFormField(
                  controller: _provinceController,
                  maxLength: 20,
                  decoration: InputDecoration(
                    // isDense: true,
                    // filled: true,
                    // fillColor: Colors.blue.shade100,
                    border: OutlineInputBorder(),
                    labelText: 'Province',
                    // hintText: 'hint',
                    // helperText: 'help',
                    // counterText: 'counter',
                    // icon: Icon(Icons.star),
                    prefixIcon: Icon(Icons.label),
                    // suffixIcon: Icon(Icons.park),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? '* Cannot be empty!' : null,
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      recognition = jsonDecode('{"r_char":"${_licnumController.text}","r_digit":"","r_province":"${_provinceController.text}"}');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => newReportScreen(
                            username: widget.username,
                            picture: widget.picture,
                            recognition: recognition,
                          ),
                        ),
                      );
                    }
                  },
                  icon: Icon(Icons.check),
                  label: Text('Look good!'),
                ),
              ],
            ),
          )
//  TextFormField(
//    initialValue: 'Input text',
//    maxLength: 20,
//    decoration: InputDecoration(
//      icon: Icon(Icons.favorite),
//      labelText: 'Label text',
//      labelStyle: TextStyle(
//        color: Color(0xFF6200EE),
//      ),
//      helperText: 'Helper text',
//      suffixIcon: Icon(
//        Icons.check_circle,
//      ),
//      enabledBorder: UnderlineInputBorder(
//        borderSide: BorderSide(color: Color(0xFF6200EE)),
//      ),
//    ),
//  ),
          ],
        );
    }
    else if (status == 'Can\'t identify this image, please try again') {
      return 
      Center(
        child: 
          Column(
            children: <Widget>[
              Text(status),
              Padding(
                padding: EdgeInsets.only(top: 20),
              child: SizedBox( 
                height: 50, //height of button
                width: double.infinity, //width of button equal to parent widget
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.amber, //background color of button
                    padding: EdgeInsets.all(10) //content padding inside button
                  ),
              onPressed: () {
                setStatus("Manually");
                setState(() {});
              }, 
              icon: Icon(Icons.edit), 
              label: Text("Manually Editting")
              ),
              ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 20),
              child: SizedBox( 
                height: 50, //height of button
                width: double.infinity, //width of button equal to parent widget
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blueAccent, //background color of button
                    padding: EdgeInsets.all(10) //content padding inside button
                  ),
              onPressed: () {
                _onWillPop();
              }, 
              icon: Icon(Icons.home), 
              label: Text("Back to Home")
              ),
              ),
              ),
            ],
          )
      );
    }
    else {
      return 
      Center(
        child: 
          Column(
            children: <Widget>[
              CircularProgressIndicator(),
              Text("Error")
            ],
          )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // resizeToAvoidBottomInset: false,
        appBar: AppBar(
        title: const Text("Licence Plate Recognition"),
        leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () {
              _onWillPop();
            },
          ),
        ),
        body: WillPopScope(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    padding: EdgeInsets.only(top: 20),
                    alignment: Alignment.topCenter,
                    child: Image.file(File(widget.picture)),
                    width: 300,
                    height: 300,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 50, left: 20, right: 20),
                  child: showStatus(),
                  )
              ],
            ),
          ),
          onWillPop: _onWillPop,
        )
      );
    }
}
