class MapSearchModel {
  var position;
  // final GeoPoint geopoint;

  MapSearchModel(
    this.position,
    // required this.geopoint,
  );

  factory MapSearchModel.fromJson(Map<String, dynamic> json) {
    return MapSearchModel(
      json['segments'],
      //  geopoint: json['geopoint']
    );
  }
}
