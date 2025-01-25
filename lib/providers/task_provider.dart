// ignore_for_file: empty_catches

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

// Add task
  Future<void> addTask(Task task) async {
    try {
      _tasks.add(task);
      await saveTasks();
      notifyListeners();
    } catch (e) {}
  }

// Delete task
  Future<void> deleteTask(String id) async {
    try {
      _tasks.removeWhere((task) => task.id == id);
      await saveTasks();
      notifyListeners();
    } catch (e) {}
  }

//
  Future<void> toggleTaskStatus(String id) async {
    try {
      final task = _tasks.firstWhere((task) => task.id == id);
      task.isCompleted = !task.isCompleted;
      await saveTasks();
      notifyListeners();
    } catch (e) {}
  }

  // Save tasks to SharedPreferences
  Future<void> saveTasks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final tasksJson = _tasks.map((task) => task.toJson()).toList();
      prefs.setString('tasks', jsonEncode(tasksJson));
    } catch (e) {}
  }

  // Load tasks from SharedPreferences
  Future<void> loadTasks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final tasksString = prefs.getString('tasks');
      if (tasksString != null) {
        final List<dynamic> decodedTasks = jsonDecode(tasksString);
        _tasks = decodedTasks.map((json) => Task.fromJson(json)).toList();
        notifyListeners();
      }
    } catch (e) {}
  }

//
  Future<void> updateTask(Task task) async {
    try {
      final index = _tasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        _tasks[index] = task;
        await saveTasks();
        notifyListeners();
      }
    } catch (e) {}
  }
}
