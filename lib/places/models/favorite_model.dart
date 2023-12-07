import 'package:flutter/material.dart';

class FavoriteModel extends ChangeNotifier {
  Set<String> favoritePlace = {};

  void addToFavorites(Map<String, dynamic> placesData) {
    final String identifier =
        '${placesData['name']}_${placesData['address']}_${placesData['latitude']}_${placesData['longitude']}_${placesData['description']}_${placesData['image']}}';
    favoritePlace.add(identifier);
    notifyListeners();
  }

  void removeFromFavorite(Map<String, dynamic> placesData) {
    final String identifier =
        '${placesData['id']}_${placesData['name']}_${placesData['address']}_${placesData['latitude']}_${placesData['longitude']}_${placesData['description']}_${placesData['image']}_${placesData['title']}';
    favoritePlace.remove(identifier);
    notifyListeners();
  }
}
