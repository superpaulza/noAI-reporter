class recordModel {
  int case_id;
  String report_datetime;
  String case_datetime;
  String car_class;
  String car_brand;
  String car_color;
  String lic_plate;
  String lic_issuer;
  String details;
  String location_name;
  double location_lat;
  double location_long;
  String reporter;
  String status;
  String pictureUrl;
  String comment;
 
  recordModel({
    required this.case_id,
    required this.report_datetime,
    required this.case_datetime,
    required this.car_class,
    required this.car_brand,
    required this.car_color,
    required this.lic_plate,
    required this.lic_issuer,
    required this.details,
    required this.location_name,
    required this.location_lat,
    required this.location_long,
    required this.reporter,
    required this.status,
    required this.pictureUrl,
    required this.comment,
  });
 
  factory recordModel.fromJson(Map<String, dynamic> json) {
    return recordModel(
      case_id: int.parse(json['case_id']),
      report_datetime: json['report_datetime'],
      case_datetime: json['case_datetime'],
      car_class: json['car_type'],
      car_brand: json['car_brand'],
      car_color: json['car_color'],
      lic_plate: json['lic_plate'],
      lic_issuer: json['lic_issuer'],
      details: json['details'],
      location_name: json['location_name'],
      location_lat: double.parse(json['location_lat']),
      location_long: double.parse(json['location_long']),
      reporter: json['first_name'] + " " + json['last_name'],
      status: json['status'],
      pictureUrl: json['pictureUrl'],
      comment: json['comment'],
    );
  }

  get path => null;
}