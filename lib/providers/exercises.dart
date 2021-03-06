import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'exercise.dart';

class Exercises with ChangeNotifier {
  List<Exercise> _items = [];

  List<Exercise> get items {
    return [..._items];
  }

  List<String> get itemName {
    return _items.map((item) => item.title).toList();
  }

  List<String> findName(String pattern) {
    return _items
        .where((item) => item.title.contains(pattern))
        .toList()
        .map((item) => item.title);
  }

  List<Exercise> get favoriteItems {
    return _items.where((exItem) => exItem.isFavorite).toList();
  }

  Exercise findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  Future<void> fetchAllExercises() async {
    var url = 'https://wger.de/api/v2/exercise/?limit=416';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      List<dynamic> arrEx = extractedData['results'];
      final List<Exercise> loadedExercises = [];
      arrEx.forEach((exData) {
        loadedExercises.add(Exercise(
          id: exData['id'].toString(),
          title: exData['name'],
          description: exData['description'],
        ));
      });
      _items = loadedExercises;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }
}
