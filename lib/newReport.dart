import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:report_app/home.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class newReportScreen extends StatefulWidget {

  String username;
  String picture;
  dynamic recognition;

  newReportScreen({
    Key? key,
    required this.username,
    required this.picture,
    required this.recognition
    }) : super(key: key);

  @override
    _newReportScreenState createState() => _newReportScreenState();

}

class _newReportScreenState extends State<newReportScreen> {
    final format = DateFormat("yyyy-MM-dd HH:mm");
    Position _currentPosition = Position(longitude: 0, latitude: 0, timestamp: DateTime.now(), accuracy: 0, altitude: 0, heading: 0, speed: 0, speedAccuracy: 0);
    String _currentAddress = "";
    String status = "";

    String selectedValue = '1';
    List<DropdownMenuItem<String>> dropdownItems =  [
      DropdownMenuItem(child: Text("รถจักรยานยต์"),value: "1"),
      DropdownMenuItem(child: Text("รถยนต์นั่งส่วนบุคคล"),value: "2"),
      DropdownMenuItem(child: Text("รถประเภทอื่น"),value: "3"),
      DropdownMenuItem(child: Text("รถขนส่ง"),value: "4"),
    ];

    TextEditingController _dateTimeController = TextEditingController();
    TextEditingController _locationController = TextEditingController();
    TextEditingController _brandController = TextEditingController();
    TextEditingController _colorController = TextEditingController();
    TextEditingController _reasonController = TextEditingController();

    final _formKey = GlobalKey<FormState>();

    @override
  void initState() {
    super.initState();
    print(widget.recognition['r_char']);
    print(widget.recognition['r_province']);
    _getCurrentLocation();
  }

  void dispose() {
    super.dispose();
  }

  Widget dateTimeFilled() {
    _dateTimeController.text = DateTime.now().toString();
    return Column(children: <Widget>[
      DateTimeField(
        controller: _dateTimeController,
        format: format,
        initialValue: DateTime.now(),
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Date & Time',
          prefixIcon: Icon(Icons.calendar_today),
          suffixIcon: Icon(Icons.add_box, size: 0,),
        ),
        onShowPicker: (context, currentValue) async {
          final date = await showDatePicker(
              context: context,
              firstDate: DateTime(1900),
              initialDate: currentValue ?? DateTime.now(),
              lastDate: DateTime(2100));
          if (date != null) {
            final time = await showTimePicker(
              context: context,
              initialTime:
                  TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
            );
            return DateTimeField.combine(date, time);
          } else {
            return currentValue;
          }
        },
      ),
    ]);
  }

  Widget formFilled() {
    _locationController.text = _currentAddress;
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _locationController,
            maxLength: 100,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Location',
              prefixIcon: Icon(Icons.location_on),
              suffixIcon: IconButton(
                    onPressed:() async {
                      await _getCurrentLocation();
                    },
                    icon: Icon(Icons.my_location),
                  ),
            ),
            validator: (value) {
              value!.isEmpty ? '* Cannot be empty!' : null;
            },
            onSaved: (String? value) {
                print('Value for field saved as "$value"');
            },
          ),
          Padding(padding: EdgeInsets.only(bottom: 10)),
          TextFormField(
            controller: _brandController,
            maxLength: 20,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Brand',
              prefixIcon: Icon(Icons.branding_watermark_rounded),
            ),
            validator: (value) =>
                value!.isEmpty ? '* Cannot be empty!' : null,
            onSaved: (String? value) {
                print('Value for field saved as "$value"');
            },
          ),
          Padding(padding: EdgeInsets.only(bottom: 10)),
          DropdownButtonFormField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Class',
              prefixIcon: Icon(Icons.car_repair),
            ),
            validator: (value) => value == null ? "Select car class" : null,
            onChanged: (String? newValue) {
              setState(() {
                selectedValue = newValue!;
              });
            },
            items: dropdownItems
          ),
          Padding(padding: EdgeInsets.only(bottom: 10)),
          TextFormField(
            controller: _colorController,
            maxLength: 20,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Color',
              prefixIcon: Icon(Icons.color_lens),
            ),
            validator: (value) =>
                value!.isEmpty ? '* Cannot be empty!' : null,
            onSaved: (String? value) {
                print('Value for field saved as "$value"');
            },
          ),
          Padding(padding: EdgeInsets.only(bottom: 10)),
          TextFormField(
            controller: _reasonController,
            maxLength: 200,
            maxLines: 5,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Reason',
              prefixIcon: Icon(Icons.note),
            ),
            validator: (value) =>
                value!.isEmpty ? '* Cannot be empty!' : null,
            onSaved: (String? value) {
                print('Value for field saved as "$value"');
            },
          ),
          Padding(padding: EdgeInsets.only(bottom: 10)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // resizeToAvoidBottomInset: false,
        appBar: AppBar(
        title: const Text("Editing Report"),
        leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: [
                    Image.file(File(widget.picture), width: 100.0, height: 100.0),
                    Flexible(
                      child: Container(
                        padding: EdgeInsets.only(right: 13.0),
                          child: Column(
                            children: [
                              Text("Licence Plate Information",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 13.0,
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text("${widget.recognition['r_char'].toString().split('/').last} ${widget.recognition['r_digit']}\n${widget.recognition['r_province']}",
                              overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 13.0,
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          )
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 50, left: 20, right: 20),
                  child: 
                  Column(children: <Widget>[
                    Padding(padding: EdgeInsets.only(bottom: 10), child: dateTimeFilled(),),
                    formFilled()
                  ],)
                  ),
                Center(
                  child: 
                ElevatedButton.icon(
                  onPressed: () async {
                    if (_formKey.currentState!.validate() && status == "complete") {
                      _onLoading();
                      await senddata();
                    } else {
                      _locationController.clear();
                    }
                  },
                  icon: Icon(Icons.check),
                  label: Text('Submit'),
                )),
                Padding(padding: EdgeInsets.all(10)),
              ],
            ),
          ),
      );
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

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the 
      // App to enable the location services.
      return print('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale 
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return print('Location permissions are denied');
      }
    }
    
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately. 
      return print(
        'Location permissions are permanently denied, we cannot request permissions.');
    } 

    setState(() {
      _currentAddress = 'Locating...';
    });
  }

  _getCurrentLocation() async {
    await _determinePosition();
    await Geolocator
      .getCurrentPosition(desiredAccuracy: LocationAccuracy.best, forceAndroidLocationManager: true)
      .then((Position position) {
        setState(() {
          _currentPosition = position;
          _getAddressFromLatLng();
        });
      }).catchError((e) {
        print(e);
      });
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        _currentPosition.latitude,
        _currentPosition.longitude
      );

      Placemark place = placemarks[0];

      setState(() {
        _currentAddress = "${place.street}, ${place.postalCode}, ${place.country}";
        status = "complete";

      });
    } catch (e) {
      print(e);
    }
  }

  senddata() async {
    final Uri uploadEndPoint = Uri.parse('http://home112.ddns.net/report_api/newreport.php');
	  final response = await http.post(uploadEndPoint, 
    body: {
	    "car_class": selectedValue,
	    "car_brand": _brandController.text,
	    "car_color": _colorController.text,
      "lic_plate": widget.recognition['r_char'].toString().split('/').last + " " + widget.recognition['r_digit'],
      "lic_issuer": widget.recognition['r_province'],
      "details": _reasonController.text,
      "location_name": _locationController.text,
      "location_lat": _currentPosition.latitude.toString(),
      "location_long": _currentPosition.longitude.toString(),
      "case_datetime": _dateTimeController.text,
      "report_datetime": DateTime.now().toString(),
      "reporter": widget.username,
      "image": base64Encode(File(widget.picture).readAsBytesSync()),
      "name": widget.username + '_'+ DateTime.now().year.toString() + "-" + DateTime.now().month.toString() +"-"+ DateTime.now().day.toString() + "_" + DateTime.now().hour.toString() + "-"+DateTime.now().minute.toString() +"-"+ DateTime.now().second.toString() +"_" + DateTime.now().millisecondsSinceEpoch.toString()+ ".jpg" ,
	  });
    var message = response.body;

    if(message == 'Sucessfully to add data!') { 
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        ));
        setState(() {
        });
      print(message); 
      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (BuildContext context) => ProfileScreen(username: widget.username)),
                        (Route<dynamic> route) => false
                    );
    }
	}

}