import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';

class TaskProvider extends ChangeNotifier {
  List<Task> _tasks = [];
  Timer? _timer;

  List<Task> get tasks => _tasks;

  TaskProvider() {
    _loadTasks();
    _startGlobalTimer();
  }

  void _startGlobalTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      bool needsUpdate = false;
      for (int i = 0; i < _tasks.length; i++) {
        if (_tasks[i].isRunning) {
          _tasks[i] = _tasks[i].copyWith(
            durationSeconds: _tasks[i].durationSeconds + 1,
          );
          needsUpdate = true;
        }
      }
      if (needsUpdate) {
        _saveTasks(); // Save frequently if running? Maybe optimize later
        notifyListeners();
      }
    });
  }

  Future<void> _loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = prefs.getStringList('tasks') ?? [];
    _tasks = tasksJson.map((e) => Task.fromJson(jsonDecode(e))).toList();
    // Reset running state on load to avoid bugs
    for (int i = 0; i < _tasks.length; i++) {
      _tasks[i] = _tasks[i].copyWith(isRunning: false);
    }
    notifyListeners();
  }

  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = _tasks.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList('tasks', tasksJson);
  }

  void addTask(String title) {
    final newTask = Task(
      id: DateTime.now().toString(),
      title: title,
    );
    _tasks.add(newTask);
    _saveTasks();
    notifyListeners();
  }

  void toggleTaskCompletion(String id) {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index != -1) {
      _tasks[index] = _tasks[index].copyWith(
        isCompleted: !_tasks[index].isCompleted,
        isRunning: false, // Stop timer if completed
      );
      _saveTasks();
      notifyListeners();
    }
  }

  void toggleTaskTimer(String id) {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index != -1) {
      // Stop all other timers first (optional, but good for focus)
      for (int i = 0; i < _tasks.length; i++) {
        if (_tasks[i].id != id && _tasks[i].isRunning) {
          _tasks[i] = _tasks[i].copyWith(isRunning: false);
        }
      }

      _tasks[index] = _tasks[index].copyWith(
        isRunning: !_tasks[index].isRunning,
      );
      _saveTasks();
      notifyListeners();
    }
  }

  void deleteTask(String id) {
    _tasks.removeWhere((t) => t.id == id);
    _saveTasks();
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
