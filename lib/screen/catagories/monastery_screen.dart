import 'package:flutter/material.dart';

import 'package:travel_guide_app/places/models/places_models.dart';

import 'package:travel_guide_app/places/models/places_models.dart'
    as places_models;
import 'package:travel_guide_app/places/services/places_services.dart';
import 'package:travel_guide_app/screen/description_screen.dart';

class MonasteryPlace extends StatefulWidget {
  const MonasteryPlace({Key? key}) : super(key: key);

  @override
  State<MonasteryPlace> createState() => _MonasteryPlaceState();
}

class _MonasteryPlaceState extends State<MonasteryPlace> {
  final placesServices = PlacesServices();
  List<AllPlacesModels> monasteryData = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Monastery'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder(
          future: placesServices.getPlacesData(context: context),
          builder: (context, AsyncSnapshot<List<AllPlacesModels>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            } else if (snapshot.hasData) {
              // Filter the data to show only temples
              monasteryData = snapshot.data!
                  .where(
                      (place) => place.title == places_models.Title.MONASTERY)
                  .toList();

              return ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: monasteryData.length,
                itemBuilder: (context, index) {
                  final monastery = monasteryData[index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DescriptionScreen(
                                  name: monastery.name,
                                  image: monastery.image,
                                  description: monastery.description,
                                  address: monastery.address,
                                  latitude: double.parse(monastery.latitude),
                                  longitude:
                                      double.parse(monastery.longitude))));
                    },
                    child: Card(
                      margin: const EdgeInsets.only(bottom: 20),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(15.0),
                              topRight: Radius.circular(15.0),
                            ),
                            child: Image.network(
                              monastery.image,
                              height: 150,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  monastery.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  monastery.description,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Center(
                child: Text('No data available'),
              );
            }
          },
        ),
      ),
    );
  }
}
