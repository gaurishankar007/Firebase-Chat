import 'dart:convert';

import 'package:firebase_chat/src/domain/repositories/google_map_repo.dart';
import 'package:http/http.dart';
import 'package:uuid/uuid.dart';

class GoogleMapRepoImpl extends GoogleMapRepo {
  final Uuid uuid = Uuid();
  final String baseURL =
      'https://maps.googleapis.com/maps/api/place/autocomplete/json';
  final placesAPIKey = "AIzaSyAgSHtVjps0_86MFvoiKZAvHa-sDV9kuUU";

  @override
  Future<List<Map<String, dynamic>>> getPlaces(String name) async {
    try {
      String sessionToken = uuid.v4();
      String requestUrl =
          '$baseURL?input=$name&key=$placesAPIKey&sessiontoken=$sessionToken';
      final response = await get(Uri.parse(requestUrl));
      final data = jsonDecode(response.body);
      print(data);

      List<Map<String, dynamic>> places = [];

      if (response.statusCode == 200) {
        places = data['predictions'] as List<Map<String, dynamic>>;
        return places;
      }

      return places;
    } catch (error) {
      print(error.toString());
      return [];
    }
  }
}
