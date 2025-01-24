import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/task.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  Future<void> addTask(Task task) async {
    _tasks.add(task);
    await _saveToPreferences();
    notifyListeners();
  }

  Future<void> updateTask(Task task) async {
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = task;
      await _saveToPreferences();
      notifyListeners();
    }
  }

  Future<void> deleteTask(String id) async {
    _tasks.removeWhere((task) => task.id == id);
    await _saveToPreferences();
    notifyListeners();
  }

  Future<void> toggleTaskStatus(String id) async {
    final index = _tasks.indexWhere((task) => task.id == id);
    if (index != -1) {
      _tasks[index].isCompleted = !_tasks[index].isCompleted;
      await _saveToPreferences();
      notifyListeners();
    }
  }

  Future<void> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('tasks');
    if (data != null) {
      final List<dynamic> jsonData = json.decode(data);
      _tasks = jsonData.map((item) => Task(
        id: item['id'],
        title: item['title'],
        description: item['description'],
        isCompleted: item['isCompleted'],
      )).toList();
      notifyListeners();
    }
  }

  Future<void> _saveToPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final data = json.encode(_tasks.map((task) => {
      'id': task.id,
      'title': task.title,
      'description': task.description,
      'isCompleted': task.isCompleted,
    }).toList());
    prefs.setString('tasks', data);
  }
}