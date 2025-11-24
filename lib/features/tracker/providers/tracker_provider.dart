import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TrackerProvider extends ChangeNotifier {
  DateTime? _startDate;
  List<DateTime> _relapses = [];
  Timer? _timer;
  Duration _currentDuration = Duration.zero;

  TrackerProvider() {
    _loadData();
  }

  DateTime? get startDate => _startDate;
  Duration get currentDuration => _currentDuration;
  int get currentStreakDays => _currentDuration.inDays;
  int get relapseCount => _relapses.length;

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final startIso = prefs.getString('startDate');
    final relapsesList = prefs.getStringList('relapses') ?? [];

    if (startIso != null) {
      _startDate = DateTime.parse(startIso);
      _startTimer();
    } else {
      // First time user, start now? Or wait for manual start?
      // Let's auto-start for now
      startChallenge();
    }

    _relapses = relapsesList.map((e) => DateTime.parse(e)).toList();
    notifyListeners();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_startDate != null) {
        _currentDuration = DateTime.now().difference(_startDate!);
        notifyListeners();
      }
    });
  }

  Future<void> startChallenge() async {
    _startDate = DateTime.now();
    _currentDuration = Duration.zero;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('startDate', _startDate!.toIso8601String());
    _startTimer();
    notifyListeners();
  }

  Future<void> relapse() async {
    if (_startDate == null) return;

    _relapses.add(DateTime.now());
    // Reset start date to now
    _startDate = DateTime.now();
    _currentDuration = Duration.zero;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('startDate', _startDate!.toIso8601String());
    await prefs.setStringList(
      'relapses',
      _relapses.map((e) => e.toIso8601String()).toList(),
    );

    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
