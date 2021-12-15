import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:report_app/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginUser extends StatefulWidget {

LoginUserState createState() => LoginUserState();

}

class LoginUserState extends State<LoginUser> {

  // For CircularProgressIndicator.
  bool visible = false;

  bool checkedValue = false;

  bool _isHiddenpwd = true;

  // Getting value from TextField widget.
  final usrController = TextEditingController();
  final passwordsController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  SharedPreferences? preferences;
  bool _isAutoLogin = false;
  String _username = "";
  String _password = "";

  @override
  void initState() {
    super.initState();
     initializePreference().whenComplete((){
       setState(() {});
     });
    //  if(_isAutoLogin) {
    //    usrController.text = (preferences!.getString('username') ?? '');
    //    passwordsController.text = (preferences!.getString('password') ?? '');
    //    userLogin(usrController.text, passwordsController.text);
    //  }
  }

  Future<void> initializePreference() async{
    this.preferences = await SharedPreferences.getInstance();
    setState(() {
      _isAutoLogin = (preferences!.getBool('isAutoLogin') ?? false);
      _username = (preferences!.getString('username') ?? '');
      _password = (preferences!.getString('password') ?? '');

    });
  }

Future userLogin(String user, String pwd) async {

  // Showing CircularProgressIndicator.
  setState(() {
  visible = true ; 
  });

  // Getting value from Controller
  String usr = user;
  String passwords = pwd;

  // SERVER LOGIN API URL
  Uri url = Uri.parse("http://home112.ddns.net/report_api/auth.php");

  // Store all data with Param Name.
  var data = {'username': usr, 'passwords' : passwords};

  // Starting Web API Call.
  var response = await http.post(url, body: json.encode(data));

  // Getting Server response into variable.
  var message = jsonDecode(response.body);

  // If the Response Message is Matched.
  if (message["status"] == 'Login Matched')
  {

    // Hiding the CircularProgressIndicator.
      setState(() {
      visible = false; 
      });

    // Navigate to Profile Screen & Sending Email to Next Screen.
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => ProfileScreen(username : usrController.text)),
        (route) => false
      );
  } else {
    // If Email or Password did not Matched.
    // Hiding the CircularProgressIndicator.
    setState(() {
      visible = false; 
      });

    // Showing Alert Dialog with Response JSON Message.
    showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: new Text('Error'),
        content: new Text(message["status"]),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: new Text('OK'),
          ),
        ],
      );
    },
    );}

}

  _forgotPassword(context) {
   return (showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Message'),
        content: new Text('ใจเย็นๆ แล้วค่อยๆนึก'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('Yes'),
          ),
        ])
   ));
  }

@override
Widget build(BuildContext context) {
return Scaffold(
  backgroundColor: Colors.black,
  body: Center(
  child:
  SingleChildScrollView(
    child: Center(
    child: Column(
      children: <Widget>[
        Container(
          width: 100,
          height: 100,
          child: Image(image: AssetImage("assets/img/logo.png")),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text("Login", style: TextStyle(fontSize: 21))),

        Divider(),          
        Form(
          key: _formKey,
          child: Column(children: [
            Container(
            width: 280,
            padding: EdgeInsets.all(10.0),
            child: TextFormField(
                controller: usrController,
                autocorrect: true,
                decoration: InputDecoration(labelText: 'Username'),
                validator: (value) =>
                    value!.isEmpty ? '* Cannot be empty!' : null,
              )
            ),

            Container(
            width: 280,
            padding: EdgeInsets.all(10.0),
            child: TextFormField(
                controller: passwordsController,
                autocorrect: true,
                obscureText: _isHiddenpwd,
                decoration: InputDecoration(
                  labelText: 'Password',
                  suffixIcon: IconButton(
                    onPressed:() {
                      setState(() {
                        _isHiddenpwd = !_isHiddenpwd;
                      });
                    },
                    icon: Icon(Icons.remove_red_eye),
                  ),
                ),
                validator: (value) =>
                    value!.isEmpty ? '* Cannot be empty!' : null,
              )
            ),
            // CheckboxListTile(
            //   title: Text("Remember me"),
            //   value: checkedValue,
            //   onChanged: (newValue) {
            //     if (_formKey.currentState!.validate()) {
            //       setState(() {
            //         _isAutoLogin = newValue!;
            //         if(newValue) {
            //           _username = usrController.text;
            //           _password = passwordsController.text;
            //           this.preferences?.setString("username", _username);
            //           this.preferences?.setString("password", _password);
            //         } else {
            //           this.preferences?.setString("username", '');
            //           this.preferences?.setString("password", '');
            //         }
            //           this.preferences?.setBool("isAutoLogin", _isAutoLogin);
            //           checkedValue = newValue;
            //       });
            //     }
            //   },
            //   controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
            // ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  userLogin(usrController.text, passwordsController.text);
                }
              },
              child: Text('Login'),
            ),
            TextButton(
                onPressed: () {
                  _forgotPassword(context);
                },
                child: new Text('Forgot your password?'),
              ),
          ],)
        ),
        Visibility(
          visible: visible, 
          child: Container(
            margin: EdgeInsets.only(bottom: 30),
            child: CircularProgressIndicator()
            )
          ),

      ],
    ),
  ))));
}
}

