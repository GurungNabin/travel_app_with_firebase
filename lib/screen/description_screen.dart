import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:travel_guide_app/leaflet_map/leaflet_main.dart';

class DescriptionScreen extends StatefulWidget {
  const DescriptionScreen(
      {super.key,
      required this.name,
      required this.image,
      required this.description,
      required this.address,
      required this.latitude,
      required this.longitude});

  final String name;
  final String image;
  final String description;
  final String address;
  final double latitude;
  final double longitude;

  @override
  State<DescriptionScreen> createState() => _DescriptionScreenState();
}

class _DescriptionScreenState extends State<DescriptionScreen> {
  late double lat = 0.0;
  late double lon = 0.0;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    assignValue();
  }

  void assignValue() async {
    await getCurrentLocation();
  }

  Future<void> getCurrentLocation() async {
    late double latitude;
    late double longitude;
    try {
      setState(() {
        isLoading = true;
      });
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      latitude = position.latitude;
      longitude = position.longitude;
      lon = longitude;
      lat = latitude;

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 2,
        title: Text(widget.name),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    Image.network(
                      widget.image,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                        const SizedBox(
                            width:
                                8), // Add some space between the icon and text
                        Expanded(
                          child: Text(
                            widget.address,
                            style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary,
                                fontSize: 18),
                            maxLines: 2,
                          ),
                        ),
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyMap(
                                          placeName: widget.name,
                                        )),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Theme.of(context).colorScheme.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                )),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.map,
                                    color:
                                        Colors.black), // Add your desired icon
                                SizedBox(
                                    width:
                                        8.0), // Adjust the spacing between icon and text
                                Text(
                                  'Map',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      widget.description,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.normal),
                      textAlign: TextAlign.justify,
                    ),
                    SizedBox(
                      height: 300,
                      child: FlutterMap(
                        options: MapOptions(
                          enableScrollWheel: true,
                          keepAlive: true,
                          zoom: 18,
                          maxZoom: 18,
                          minZoom: 3,
                          slideOnBoundaries: true,
                          center: LatLng(widget.latitude, widget.longitude),
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                            subdomains: const ["a", "b", "c"],
                          ),
                          MarkerLayer(
                            markers: [
                              Marker(
                                point:
                                    LatLng(widget.latitude, widget.longitude),
                                builder: (context) {
                                  return const Icon(
                                    Icons.pin_drop,
                                    color: Colors.red,
                                    size: 40,
                                  );
                                },
                              ),
                              Marker(
                                point: LatLng(lat, lon),
                                builder: (context) {
                                  return const Icon(
                                    Icons.circle,
                                    color: Colors.blue,
                                    size: 30,
                                  );
                                },
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
