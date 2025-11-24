import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/food_log.dart';

class FoodProvider extends ChangeNotifier {
  List<FoodLog> _logs = [];
  DateTime? _lastMealTime;
  Timer? _timer;
  Duration _fastingDuration = Duration.zero;

  List<FoodLog> get logs => _logs;
  Duration get fastingDuration => _fastingDuration;

  FoodProvider() {
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final logsJson = prefs.getStringList('food_logs') ?? [];
    _logs = logsJson.map((e) => FoodLog.fromJson(jsonDecode(e))).toList();

    if (_logs.isNotEmpty) {
      _logs.sort((a, b) => b.eatenAt.compareTo(a.eatenAt));
      _lastMealTime = _logs.first.eatenAt;
      _startTimer();
    }
    notifyListeners();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_lastMealTime != null) {
        _fastingDuration = DateTime.now().difference(_lastMealTime!);
        notifyListeners();
      }
    });
  }

  Future<void> logMeal(String mealType) async {
    final newLog = FoodLog(
      id: DateTime.now().toString(),
      eatenAt: DateTime.now(),
      mealType: mealType,
    );

    _logs.insert(0, newLog);
    _lastMealTime = newLog.eatenAt;
    _fastingDuration = Duration.zero;

    final prefs = await SharedPreferences.getInstance();
    final logsJson = _logs.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList('food_logs', logsJson);

    _startTimer();
    notifyListeners();
  }

  Future<void> deleteLog(String id) async {
    _logs.removeWhere((log) => log.id == id);

    final prefs = await SharedPreferences.getInstance();
    final logsJson = _logs.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList('food_logs', logsJson);

    // Update last meal time if we deleted the most recent meal
    if (_logs.isNotEmpty) {
      _logs.sort((a, b) => b.eatenAt.compareTo(a.eatenAt));
      _lastMealTime = _logs.first.eatenAt;
    } else {
      _lastMealTime = null;
      _fastingDuration = Duration.zero;
    }

    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
