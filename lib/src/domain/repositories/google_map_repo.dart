abstract class GoogleMapRepo {
  Future<List<Map<String, dynamic>>> getPlaces(String name);
}
