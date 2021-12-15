import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:report_app/home.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:report_app/recordModel.dart';

class viewRecord extends StatefulWidget {

  recordModel dataList;

  viewRecord({
    Key? key,
    required this.dataList,
    }) : super(key: key);

  @override
    _viewRecordState createState() => _viewRecordState();

}

class _viewRecordState extends State<viewRecord> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Case Id " + widget.dataList.case_id.toString()),
      ),
      body: SingleChildScrollView(
        child: Column(
        children: <Widget>[
          Center(
            child: Image.network(
              widget.dataList.pictureUrl, 
              fit: BoxFit.fill,
              width: 200,
              height: 300,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                int fileSize = loadingProgress.expectedTotalBytes ?? 1;
                  return Center(
                    child: CircularProgressIndicator(
                    value: loadingProgress.cumulativeBytesLoaded / fileSize
                    ),
                  );
              },
            ),
          ),
            Text("ยี่ห้อ: " + widget.dataList.car_brand),
            Text("ประเภทรถ: " + widget.dataList.car_class),
            Text("สี: " + widget.dataList.car_color),
            Text("หมายเลขทะเบียน: \n" + widget.dataList.lic_plate + " " + widget.dataList.lic_issuer),
            Divider(),
            Text("ข้อหา: \n" + widget.dataList.details),
            Text("จุดเกิดเหตุ: \n" + widget.dataList.location_name),
            Text("สถานะรายงาน: " + widget.dataList.status),
            Text("ความคิดเห็นจากผู้ดูแล: \n" + widget.dataList.comment),
        ],
      ),
      )
    );
  }
}