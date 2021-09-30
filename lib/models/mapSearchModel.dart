import 'package:cloud_firestore/cloud_firestore.dart';

class MapSearchModel {
  final String placeId;
  // final GeoPoint geopoint;

  MapSearchModel({
    required this.placeId,
    // required this.geopoint,
  });

  factory MapSearchModel.fromJson(Map<String, dynamic> json) {
    return MapSearchModel(placeId: json['place_id'],
    //  geopoint: json['geopoint']
     );
  }
}
