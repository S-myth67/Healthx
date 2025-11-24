import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/habit.dart';

class HabitProvider extends ChangeNotifier {
  List<Habit> _habits = [];

  List<Habit> get habits => _habits;

  HabitProvider() {
    _loadHabits();
  }

  Future<void> _loadHabits() async {
    final prefs = await SharedPreferences.getInstance();
    final habitsJson = prefs.getStringList('habits') ?? [];
    _habits = habitsJson.map((e) => Habit.fromJson(jsonDecode(e))).toList();
    notifyListeners();
  }

  Future<void> _saveHabits() async {
    final prefs = await SharedPreferences.getInstance();
    final habitsJson = _habits.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList('habits', habitsJson);
  }

  void addHabit(String title) {
    final newHabit = Habit(
      id: DateTime.now().toString(),
      title: title,
      createdAt: DateTime.now(),
    );
    _habits.add(newHabit);
    _saveHabits();
    notifyListeners();
  }

  void toggleHabit(String id) {
    final index = _habits.indexWhere((element) => element.id == id);
    if (index != -1) {
      _habits[index] = _habits[index].copyWith(
        isCompleted: !_habits[index].isCompleted,
      );
      _saveHabits();
      notifyListeners();
    }
  }

  void deleteHabit(String id) {
    _habits.removeWhere((element) => element.id == id);
    _saveHabits();
    notifyListeners();
  }
}
