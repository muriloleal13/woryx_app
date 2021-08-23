import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/http_exception.dart';
import 'package:http/http.dart' as http;

class WorkoutPlanItem {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final TimeOfDay time;
  final String recurrency;

  WorkoutPlanItem({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.date,
    @required this.time,
    @required this.recurrency,
  });
}

class WorkoutPlan with ChangeNotifier {
  final String authToken;
  final String userId;

  WorkoutPlan(this.authToken, this.userId);

  List<WorkoutPlanItem> _items = [];

  List<WorkoutPlanItem> get items {
    return [..._items];
  }

  int get itemCount {
    return _items.length;
  }

  Future<void> fetchAndSetWorkouts() async {
    var url =
        'https://woryx-app-33859-default-rtdb.firebaseio.com/workout-plan.json?auth=$authToken';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      final List<WorkoutPlanItem> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(WorkoutPlanItem(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          date: DateTime.parse(prodData['date']),
          time: TimeOfDay.fromDateTime(DateTime.parse(prodData['date'])),
          recurrency: prodData['recurrency'],
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addItem(WorkoutPlanItem newWorkout) async {
    final url =
        'https://woryx-app-33859-default-rtdb.firebaseio.com/workout-plan.json?auth=$authToken';
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': newWorkout.title,
          'description': newWorkout.description,
          'dateTime': DateTime(
                  newWorkout.date.year,
                  newWorkout.date.month,
                  newWorkout.date.day,
                  newWorkout.time.hour,
                  newWorkout.time.minute)
              .toIso8601String(),
          'recurrency': newWorkout.recurrency,
        }),
      );
      final newExercise = WorkoutPlanItem(
        id: json.decode(response.body)['title'],
        title: newWorkout.title,
        description: newWorkout.description,
        date: newWorkout.date,
        time: newWorkout.time,
        recurrency: newWorkout.recurrency,
      );
      _items.add(newExercise);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> updateItem(String id, WorkoutPlanItem newWorkout) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url =
          'https://woryx-app-33859-default-rtdb.firebaseio.com/workout-plan/$id.json?auth=$authToken';
      await http.patch(url,
          body: json.encode({
            'title': newWorkout.title,
            'description': newWorkout.description,
            'dateTime': DateTime(
                    newWorkout.date.year,
                    newWorkout.date.month,
                    newWorkout.date.day,
                    newWorkout.time.hour,
                    newWorkout.time.minute)
                .toIso8601String(),
            'recurrency': newWorkout.recurrency,
          }));
      _items[prodIndex] = newWorkout;
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> removeItem(String id) async {
    final url =
        'https://woryx-flutter-default-rtdb.firebaseio.com/workout-plan/$id.json?auth=$authToken';
    final existingExerciseIndex = _items.indexWhere((ex) => ex.id == id);
    var existingExercise = _items[existingExerciseIndex];
    _items.removeAt(existingExerciseIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingExerciseIndex, existingExercise);
      notifyListeners();
      throw HttpException('Could not delete product.');
    }
    existingExercise = null;
  }

  WorkoutPlanItem findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }
}
