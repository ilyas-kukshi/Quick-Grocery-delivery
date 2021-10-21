import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:quickgrocerydelivery/models/mapSearchModel.dart';
import 'package:quickgrocerydelivery/shared/constants.dart';

class MapSearchService {
  Future<List<MapSearchModel>> getPredictions(String search) async {
    var client = http.Client();
    // var url = Constants.url +
    //     search +
    //     Constants.language +
    //     Constants.geoCodeType +
    //     Constants.mapApiKey;
    Map<String, String> queryParameters = {
      'key': Constants.tomTomApiKey,
      'language': 'en-US',
      'idxSet': 'Addr'
    };
    var response = await client.get(Uri.https(
        "api.tomtom.com", "/search/2/search/$search.json", queryParameters));
    var json = convert.jsonDecode(response.body);
    var jsonResults = json['results'] as List;

    return jsonResults.map((place) => MapSearchModel.fromJson(place)).toList();
  }
}
