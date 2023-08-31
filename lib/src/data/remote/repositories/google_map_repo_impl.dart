import 'dart:convert';

import 'package:firebase_chat/src/domain/repositories/google_map_repo.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:http/http.dart';
import 'package:uuid/uuid.dart';

class GoogleMapRepoImpl extends GoogleMapRepo {
  final Uuid uuid = Uuid();
  final String baseUrl = 'https://maps.googleapis.com/maps/api';
  final apiKey = "AIzaSyAgSHtVjps0_86MFvoiKZAvHa-sDV9kuUU";

  @override
  Future<Map<String, dynamic>> getPlaces(String name) async {
    try {
      String requestUrl = '$baseUrl/place/findplacefromtext/json'
          '?input=$name&inputtype=textquery&key=$apiKey';
      final response = await get(Uri.parse(requestUrl));
      final data = jsonDecode(response.body);
      String placeId = data['candidates'][0]['place_id'] as String;

      String requestUrl2 =
          "$baseUrl/place/details/json?place_id=$placeId&key=$apiKey";
      final response2 = await get(Uri.parse(requestUrl2));
      final data2 = jsonDecode(response2.body);
      final places = data2["result"] as Map<String, dynamic>;

      return places;
    } catch (error) {
      return {};
    }
  }

  @override
  Future<Map<String, dynamic>> getDirections({
    required String origin,
    required String destination,
  }) async {
    try {
      String requestUrl = "$baseUrl/directions/json?origin=$origin"
          "&destination=$destination&key=$apiKey";

      final response = await get(Uri.parse(requestUrl));
      final data = jsonDecode(response.body);

      final result = {
        "bounds_ne": data["routes"][0]["bounds"]["northeast"],
        "bounds_sw": data["routes"][0]["bounds"]["southwest"],
        "start_location": data["routes"][0]["legs"][0]["start_location"],
        "end_location": data["routes"][0]["legs"][0]["end_location"],
        "polyline": data["routes"][0]["overview_polyline"]["points"],
        "polyline_decoded": PolylinePoints()
            .decodePolyline(data["routes"][0]["overview_polyline"]["points"]),
      };

      return result;
    } catch (error) {
      return {};
    }
  }
}
