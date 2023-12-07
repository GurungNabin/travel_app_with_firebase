import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travel_guide_app/places/models/favorite_model.dart';
import 'package:travel_guide_app/places/models/places_models.dart';
import 'package:travel_guide_app/places/services/places_services.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  final placesServices = PlacesServices();
  List<AllPlacesModels> allPlaces = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Places'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child:
            Consumer<FavoriteModel>(builder: (context, favoriteModel, child) {
          return ListView.builder(
              itemCount: favoriteModel.favoritePlace.length,
              itemBuilder: (context, index) {
                final String identifier =
                    favoriteModel.favoritePlace.elementAt(index);

                final List<String> parts = identifier.split('_');
                final String name = parts[0];
                final String imagePath = parts[1];
                final String addtess = parts[2];

                return Card(
                  color: Colors.amber,
                  margin: const EdgeInsets.only(bottom: 25),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(8.0),
                    title: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(
                            imagePath,
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            name,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                    trailing: IconButton(
                      color: Colors.red,
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        final Map<String, dynamic> placesData = {
                          'placeNmae': name,
                          'image': imagePath,
                          'address': addtess,
                        };
                        final FavoriteModel favoriteModel =
                            Provider.of<FavoriteModel>(context, listen: false);

                        favoriteModel.removeFromFavorite(placesData);
                      },
                    ),
                  ),
                );
              });
        }),
      ),
    );
  }
}
