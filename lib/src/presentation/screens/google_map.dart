import 'dart:async';

import 'package:firebase_chat/src/core/extensions/build_context_extension.dart';
import 'package:firebase_chat/src/data/remote/repositories/google_map_repo_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GMap extends StatefulWidget {
  const GMap({super.key});

  @override
  State<GMap> createState() => _GMapState();
}

class _GMapState extends State<GMap> {
  Completer<GoogleMapController> completer = Completer<GoogleMapController>();
  final CameraPosition initialPosition = CameraPosition(
    target: LatLng(27.7172, 85.3240),
    zoom: 15,
  );

  bool searching = false;
  TextEditingController txtC = TextEditingController();
  List<Map<String, dynamic>> places = [];

  List<Marker> markers = [
    Marker(
      markerId: MarkerId("12"),
      position: LatLng(27.7172, 85.3240),
    ),
    Marker(
      markerId: MarkerId("101"),
      position: LatLng(27.6710, 85.4298),
    ),
  ];

  List<Polygon> polygons = [
    Polygon(
      polygonId: PolygonId("1"),
      fillColor: Colors.transparent,
      strokeColor: Colors.green.withOpacity(.3),
      strokeWidth: 4,
      points: const [
        LatLng(27.6588, 85.3247),
        LatLng(27.6710, 85.4298),
        LatLng(27.7172, 85.3240),
      ],
    )
  ];

  addCustomMarker() async {
    final icon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(),
      "assets/icons/1.png",
    );

    markers.add(Marker(
      markerId: MarkerId("108"),
      position: LatLng(27.6588, 85.3247),
      icon: icon,
    ));

    setState(() {});
  }

  Future<Position> currentLocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) {
      debugPrint(error.toString());
    });

    return await Geolocator.getCurrentPosition();
  }

  changeMapTheme(String path) async {
    GoogleMapController ctr = await completer.future;
    if (context.mounted) {
      String? style = path.isNotEmpty
          ? await DefaultAssetBundle.of(context).loadString(path)
          : null;
      ctr.setMapStyle(style);
    }
  }

  @override
  void initState() {
    super.initState();
    addCustomMarker();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Stack(
              children: [
                SizedBox(
                  height: context.height - context.statusHeight - 55,
                  child: GoogleMap(
                    initialCameraPosition: initialPosition,
                    onMapCreated: (controller) {
                      completer.complete(controller);
                    },
                    markers: Set<Marker>.of(markers),
                    polygons: Set<Polygon>.of(polygons),
                    zoomControlsEnabled: false,
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: Column(
                    children: [
                      Container(
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(.1),
                              spreadRadius: 1,
                              blurRadius: 2,
                            )
                          ],
                        ),
                        child: TextFormField(
                          controller: txtC,
                          onChanged: (value) async {
                            if (value.isEmpty) {
                              setState(() {
                                searching = false;
                              });
                              return;
                            }

                            places = await GoogleMapRepoImpl().getPlaces(value);
                            if (!searching) {
                              searching = true;
                            }
                            setState(() {});
                          },
                          decoration: InputDecoration(
                            isDense: true,
                            filled: true,
                            fillColor: Colors.white,
                            suffixIcon: searching
                                ? IconButton(
                                    onPressed: () {
                                      txtC.clear();
                                      setState(() {
                                        searching = false;
                                      });
                                    },
                                    icon: Icon(Icons.clear_rounded),
                                  )
                                : null,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                      if (searching)
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          height: 300,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ListView.builder(
                            physics: BouncingScrollPhysics(),
                            itemCount: places.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                onTap: () async {
                                  List<Location> locations =
                                      await locationFromAddress(
                                          places[index]["description"]);

                                  LatLng latLng = LatLng(
                                    locations.last.latitude,
                                    locations.last.longitude,
                                  );

                                  debugPrint(latLng.toString());
                                },
                                dense: true,
                                contentPadding: EdgeInsets.all(1),
                                title: Text(places[index]["description"]),
                              );
                            },
                          ),
                        )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            PopupMenuButton(
              icon: Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.color_lens_rounded,
                  color: Colors.white,
                ),
              ),
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                    onTap: () {
                      changeMapTheme("");
                    },
                    child: Text("Standard"),
                  ),
                  PopupMenuItem(
                    onTap: () {
                      changeMapTheme("assets/mapThemes/silver.json");
                    },
                    child: Text("Silver"),
                  ),
                  PopupMenuItem(
                    onTap: () {
                      changeMapTheme("assets/mapThemes/retro.json");
                    },
                    child: Text("Retro"),
                  ),
                  PopupMenuItem(
                    onTap: () {
                      changeMapTheme("assets/mapThemes/dark.json");
                    },
                    child: Text("Dark"),
                  ),
                  PopupMenuItem(
                    onTap: () {
                      changeMapTheme("assets/mapThemes/night.json");
                    },
                    child: Text("Night"),
                  ),
                  PopupMenuItem(
                    onTap: () {
                      changeMapTheme("assets/mapThemes/aubergine.json");
                    },
                    child: Text("Aubergine"),
                  ),
                ];
              },
            ),
            SizedBox(height: 10),
            FloatingActionButton(
              onPressed: () async {
                currentLocation().then((value) async {
                  markers.add(
                    Marker(
                      markerId: MarkerId("12340"),
                      position: LatLng(value.latitude, value.longitude),
                    ),
                  );
                  setState(() {});

                  GoogleMapController ctr = await completer.future;
                  CameraPosition position = CameraPosition(
                    target: LatLng(value.latitude, value.longitude),
                    zoom: 16,
                  );
                  ctr.animateCamera(CameraUpdate.newCameraPosition(position));
                });
              },
              shape: CircleBorder(),
              child: Icon(
                Icons.location_pin,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
