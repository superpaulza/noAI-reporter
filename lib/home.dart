import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:report_app/aiRecognition.dart';
import 'package:report_app/auth.dart';
import 'package:report_app/licenceRecord.dart';
import 'package:report_app/listRecord.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {

  // Creating String Var to Hold sent Email.  
  final String username;
  // Receiving Email using Constructor.
  ProfileScreen({Key? key, required this.username}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();

}
class _ProfileScreenState extends State<ProfileScreen> {
  final ImagePicker _picker = ImagePicker();
  SharedPreferences? preferences;
  bool _isAutoLogin = false;

  @override
  void initState() {
    super.initState();
     initializePreference().whenComplete((){
       setState(() {});
     });
  }

  Future<void> initializePreference() async{
    this.preferences = await SharedPreferences.getInstance();
    setState(() {
      _isAutoLogin = (preferences!.getBool('isAutoLogin') ?? false);

    });
  }

  Future<bool> logout() async {
    return (await showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Logout'),
        content: new Text('Do you want to logout ?'),
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
                  builder: (context) => LoginUser(
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

  camera(BuildContext context, String path) {
    Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (BuildContext context) => licenceRecordScreen(username: widget.username, picture: path)),
    (Route<dynamic> route) => false
    );
  }

  listview(BuildContext context) {
    Navigator.push(
    context,
    MaterialPageRoute(builder: (BuildContext context) => listRecordScreen(username: widget.username)),
    );
  }

  

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    body: SafeArea(
        child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () {
                      logout();
                    },
                    icon: const Icon(Icons.logout),
                  ),
                ],
              )
            ],
          ),
          Container(
            width: 280,
            padding: EdgeInsets.all(10.0),
            child: Text('Welcome, ' + widget.username, 
                  style: TextStyle(fontSize: 25))
          ),
          Container(
            width: 280,
            padding: EdgeInsets.all(10.0),
            child: Text("to Thai license plate recognition (T-LPR) report system", 
                  style: TextStyle(fontSize: 15)),
          ),
          SizedBox(
            height: 30,
          ),
          GestureDetector(
            child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage('assets/img/1.png'), fit: BoxFit.cover),
                borderRadius: BorderRadius.circular(30), color: Colors.green),
            height: 200,
          ),
            onTap: () async {
              final XFile? photo = await _picker.pickImage(source: ImageSource.camera, imageQuality: 80, maxHeight: 1980, maxWidth: 1080);
              if (photo != null) {
                camera(context, photo.path);
              }
            },
          ),
          SizedBox(
            height: 20,
          ),
          GestureDetector(
            child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage('assets/img/2.png'), fit: BoxFit.cover),
                borderRadius: BorderRadius.circular(30), color: Colors.yellow),
            height: 200,
          ),
            onTap: () {
              listview(context);
            },
          ),
        ],
      ),
    )),
    floatingActionButton: FloatingActionButton(
      onPressed: () async {
        final XFile? photo = await _picker.pickImage(source: ImageSource.camera, imageQuality: 80, maxHeight: 1980, maxWidth: 1080);
        if (photo != null) {
          camera(context, photo.path);
        }
      },
      tooltip: 'Camera',
      child: const Icon(Icons.camera_alt),
    ),
  );

  // return MaterialApp(
  //   home: Scaffold(
  //       body: SingleChildScrollView(
  //         child: Column(children: <Widget>[
  //         Center(
  //             child: Column(children: <Widget>[
  //           Padding(
  //             padding: EdgeInsets.only(top: 40),
  //             child: Column(children: <Widget>[
  //                         Container(
  //           width: 280,
  //           padding: EdgeInsets.all(10.0),
  //           child: Text('Username = ' + widget.username, 
  //                 style: TextStyle(fontSize: 20))
  //             ),

  //           ElevatedButton(
  //           onPressed: () {
  //             logout(context);
  //           },
  //           child: Text('Logout'),
  //         ),
  //             ])
  //           ),
  //         ])
  //           ),
  //           Center(
  //             child: ElevatedButton(
  //               onPressed: () async {
  //                 _onLoading();
  //                 final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
  //                 if (photo != null) {
  //                   Navigator.pushAndRemoveUntil(
  //                       context,
  //                       MaterialPageRoute(builder: (BuildContext context) => licenceRecordScreen(username: widget.username, picture: photo.path)),
  //                       (Route<dynamic> route) => false
  //                   );
  //                 }
  //               },
  //               child: Text("ถ่ายรูป"),
  //             )
  //           ),
  //           Center(
  //             child: ElevatedButton(
  //               onPressed: () {
                  
  //               },
  //               child: Text("ดูรายงาน"),
  //             )
  //           ),
  //         ])
  //         )
  //       )
  //     );
  }

    void _onLoading() {
    showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // _isGayray
              // ? Container(
              //   child:  Image(
              //   image: AssetImage("assets/img/loading.gif"),
              //   width: 200,
              //   height: 200,
              //   )
              // )
               Container(),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            Padding(
              padding: EdgeInsets.only(left: 30),
              child: Text("Loading"),
              ),
          ],
        ),
            ],
          )
        )
      );
    },
  );
  }
}