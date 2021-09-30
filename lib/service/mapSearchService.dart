import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:quickgrocerydelivery/models/mapSearchModel.dart';
import 'package:quickgrocerydelivery/shared/constants.dart';

class MapSearchService {
  Future<List<MapSearchModel>> getPredictions(String search) async {
    var client = http.Client();
    var url = Constants.url +
        search +
        Constants.language +
        Constants.geoCodeType +
        Constants.mapApiKey;
    var response = await client.get(Uri.parse(url), headers: {});
    var json = convert.jsonDecode(response.body);
    var jsonResults = json['predictions'] as List;

    return jsonResults.map((place) => MapSearchModel.fromJson(place)).toList();
  }
}
