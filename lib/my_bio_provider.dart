import 'package:flutter/material.dart';

class MyBioProvider extends ChangeNotifier {
  String? _image;
  double _score = 0;
  DateTime _date = DateTime.now();

  String? get image => _image;
  double get score => _score;
  DateTime get date => _date;

  void setImage(String? value) {
    _image = value;
    notifyListeners();
  }

  void setScore(double value) {
    _score = value;
    notifyListeners();
  }

  void setDate(DateTime date) {
    _date = date;
    notifyListeners();
  }
}