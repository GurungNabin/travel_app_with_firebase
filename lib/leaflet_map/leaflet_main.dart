import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyMap extends StatefulWidget {
  const MyMap({Key? key, required this.placeName}) : super(key: key);

  final String placeName;

  @override
  State<MyMap> createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  final start = TextEditingController();
  final end = TextEditingController();
  bool isVisible = false;
  List<LatLng> routpoints = [LatLng(52.05884, -1.345583)];
  bool isLoading = false;
  String destinationName = "";

  @override
  void initState() {
    super.initState();
    getLongitudeAndLatitude();
  }

  Future<Position> getPostion() async {
    final postion = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return postion;
  }

  Future<void> getLongitudeAndLatitude() async {
    setState(() {
      isLoading = true;
    });
    final position = await getPostion();

    List<Placemark> placemark =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    print("The sublocality name is ${placemark[0].subLocality}");
    destinationName = placemark[0].subLocality!;

    List<Location> start_l = await locationFromAddress(
        destinationName.replaceAll("Bagbazar", "Putalisadak"));
    List<Location> end_l = await locationFromAddress(widget.placeName);
    var v1 = start_l[0].latitude;
    var v2 = start_l[0].longitude;
    var v3 = end_l[0].latitude;
    var v4 = end_l[0].longitude;
    var url = Uri.parse(
        'http://router.project-osrm.org/route/v1/driving/$v2,$v1;$v4,$v3?steps=true&annotations=true&geometries=geojson&overview=full');
    var response = await http.get(url);
    print(response.body);
    setState(() {
      routpoints = [];
      var ruter =
          jsonDecode(response.body)['routes'][0]['geometry']['coordinates'];
      for (int i = 0; i < ruter.length; i++) {
        var reep = ruter[i].toString();
        reep = reep.replaceAll("[", "");
        reep = reep.replaceAll("]", "");
        var lat1 = reep.split(',');
        var long1 = reep.split(",");
        routpoints.add(LatLng(double.parse(lat1[1]), double.parse(long1[0])));
      }
      isVisible = !isVisible;
      print(routpoints);
    });

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Routing',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
        backgroundColor: Colors.grey[500],
      ),
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        height: 500,
                        width: 400,
                        child: Visibility(
                          visible: isVisible,
                          child: FlutterMap(
                            options: MapOptions(
                              center: routpoints[0],
                              zoom: 15,
                            ),
                            nonRotatedChildren: [
                              AttributionWidget.defaultWidget(
                                  source: 'OpenStreetMap contributors',
                                  onSourceTapped: null),
                            ],
                            children: [
                              TileLayer(
                                urlTemplate:
                                    'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                userAgentPackageName: 'com.example.app',
                              ),
                              PolylineLayer(
                                polylineCulling: false,
                                polylines: [
                                  Polyline(
                                      points: routpoints,
                                      color: Colors.blue,
                                      strokeWidth: 9)
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
