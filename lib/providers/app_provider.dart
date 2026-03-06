import 'package:flutter/material.dart';

class AppProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool _showOnboarding = true;
  DateTime _lastVisit = DateTime.now();

  bool get isLoading => _isLoading;
  bool get showOnboarding => _showOnboarding;
  DateTime get lastVisit => _lastVisit;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void completeOnboarding() {
    _showOnboarding = false;
    notifyListeners();
  }

  void updateLastVisit() {
    _lastVisit = DateTime.now();
    notifyListeners();
  }

  bool get isNewDay {
    final now = DateTime.now();
    return now.year != _lastVisit.year ||
           now.month != _lastVisit.month ||
           now.day != _lastVisit.day;
  }
}
