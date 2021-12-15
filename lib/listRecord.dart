import 'dart:convert';

import 'package:report_app/recordModel.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:report_app/viewRecord.dart';

class listRecordScreen extends StatefulWidget {

  String username;

  listRecordScreen({
    Key? key,
    required this.username,
  }) : super(key: key);

  @override
  listRecordScreenState createState() => listRecordScreenState();
 
}
 
class listRecordScreenState extends State<listRecordScreen> {
 
  final Uri apiURL = Uri.parse('http://home112.ddns.net/report_api/listmyreport.php');
 
  Future<List<recordModel>> fetchRecord() async {
    
    // Store all data with Param Name.
    var data = {'username': widget.username};

    // Starting Web API Call.
    var response = await http.post(apiURL, body: data);
 
    if (response.statusCode == 200) {
 
      final items = json.decode(response.body).cast<Map<String, dynamic>>();

      print(items);

      List<recordModel> recordList = items.map<recordModel>((json) {
        return recordModel.fromJson(json);
      }).toList();
 
      return recordList;
      }
     else {
      throw Exception('Failed to load data from Server.');
    }
  }
 
  @override
  Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
        title: const Text("Report List")),
    body: FutureBuilder<List<recordModel>>(
      future: fetchRecord(),
      builder: (context, snapshot) {
      if(snapshot.hasData) {
        List<recordModel>? data = snapshot.data;
        return ListView.builder(
          itemCount: data!.length,
          itemBuilder: (BuildContext context, int index) {
            data.sort((b, a) => a.report_datetime.compareTo(b.report_datetime));
            return 
            GestureDetector(
              onTapDown: (TapDownDetails details) {
                setState(() {
                  // fileName = (data[index].case_id;
                  // detail = details.globalPosition;
                });
              },
              onLongPress: () {
                // HapticFeedback.mediumImpact();
                // _showPopupMenu(detail, index, fileSystem[index].path);
              },
              child: Card(
                child: ListTile(
                onTap: () async {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) =>
                      viewRecord(
                        dataList: data[index],
                      ),
                    ),
                  );
                },
                leading: Icon(Icons.file_copy),
                title: Text(
                  ("Case Id: " + data[index].case_id.toString()),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text("Report date: " + data[index].report_datetime + "\n" + "Status: " + data[index].status),
                ),
              ),
            );
          }
        );
        } else {
          return Center( child: CircularProgressIndicator());
        }
    //   return ListView(
    //   children: snapshot.data!
    //   .map((data) => Column(children: <Widget>[
    //     GestureDetector(
    //       onTap: () {navigateToNextActivity(context, data.case_id);},
    //       child: Row(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
          
    //       Padding(
    //       padding: EdgeInsets.fromLTRB(20, 5, 0, 5),
    //       child: Text(data.car_brand,
    //         style: TextStyle(fontSize: 21), 
    //         textAlign: TextAlign.left))
          
    //   ]),),
 
    //   Divider(color: Colors.black),
    //   ],))
    // .toList(),
    // );
    },
  ),
  );
 }
}