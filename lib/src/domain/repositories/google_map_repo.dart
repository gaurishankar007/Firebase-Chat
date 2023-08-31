abstract class GoogleMapRepo {
  Future<Map<String, dynamic>> getPlaces(String name);
  Future<Map<String, dynamic>> getDirections({
    required String origin,
    required String destination,
  });
}
