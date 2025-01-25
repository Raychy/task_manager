// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:task_manager/utils/format_date.dart';
import 'package:task_manager/widgets/custom_textform_field.dart';
import 'package:task_manager/widgets/task_item.dart';
import '../models/task.dart';

class TaskListScreen extends StatefulWidget {
  final List<Task> tasks;
  final taskProvider;

  const TaskListScreen(
      {super.key, required this.tasks, required this.taskProvider});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  String _filter = 'All Task';

  List<Task> get filteredTasks {
    List<Task> sortedTasks = [...widget.tasks];

    // Sort tasks by date and time
    sortedTasks.sort((a, b) {
      if (a.dateTime == null && b.dateTime == null) return 0;
      if (a.dateTime == null) return 1;
      if (b.dateTime == null) return -1;
      return a.dateTime!.compareTo(b.dateTime!);
    });

    switch (_filter) {
      case 'Pending':
        return sortedTasks.where((task) => !task.isCompleted).toList();
      case 'Completed':
        return sortedTasks.where((task) => task.isCompleted).toList();
      default:
        return sortedTasks;
    }
  }

  void _toggleTaskStatus(Task task) {
    setState(() {
      task.isCompleted = !task.isCompleted;
    });
    widget.taskProvider.updateTask(task);
  }

  Future<void> _pickDate(BuildContext context, DateTime? selectedDate,
      ValueChanged<DateTime?> onDatePicked) async {
    final date = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (date != null) {
      onDatePicked(date);
    }
  }

  void _editTask(Task task) async {
    final editedTask = await showDialog<Task>(
      context: context,
      builder: (ctx) {
        final titleController = TextEditingController(text: task.title);
        final descriptionController =
            TextEditingController(text: task.description);
        final hoursController =
            TextEditingController(text: task.hours?.toString());
        DateTime? selectedDate = task.dateTime;

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Edit Task'),
              content: SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              selectedDate == null
                                  ? 'No date selected'
                                  : formatDate(selectedDate),
                              style: const TextStyle(
                                fontSize: 18,
                                color: Colors.purple,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () =>
                                _pickDate(context, selectedDate, (date) {
                              setState(() {
                                selectedDate = date;
                              });
                            }),
                            child: const Text(
                              'Change Date',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                      CustomTextFormField(
                        controller: titleController,
                        textCapitalization: TextCapitalization.sentences,
                        textInputAction: TextInputAction.done,
                        labelText: 'Title',
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a title';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomTextFormField(
                        controller: descriptionController,
                        textCapitalization: TextCapitalization.sentences,
                        labelText: 'Description',
                        maxLines: 5,
                        maxLength: 200,
                      ),
                      const SizedBox(height: 16),
                      CustomTextFormField(
                        controller: hoursController,
                        textInputAction: TextInputAction.send,
                        labelText: 'Estimated Hours to Complete',
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the estimated hours';
                          }
                          if (int.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (titleController.text.isNotEmpty) {
                      final hours = int.tryParse(hoursController.text);
                      task.title = titleController.text;
                      task.description = descriptionController.text;
                      task.hours = hours;
                      task.dateTime = selectedDate;
                      widget.taskProvider.updateTask(task);
                      Navigator.of(ctx).pop();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );

    if (editedTask != null) {
      setState(() {});
    }
  }

  Future<void> _deleteTask(Task task) async {
    await widget.taskProvider.deleteTask(task.id);
    setState(() {
      widget.tasks.remove(task);
    });
  }

//  _confirmDismiss connfrim if the user wants to delete the task
  Future<bool> _confirmDismiss(DismissDirection direction, Task task) async {
    return await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Delete Task'),
            content: const Text('Are you sure you want to delete this task?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child: const Text('Delete'),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Task Manager'),
          bottom: TabBar(
            onTap: (index) {
              setState(() {
                _filter = ['All Task', 'Pending', 'Completed'][index];
              });
            },
            tabs: const [
              Tab(text: 'All Task'),
              Tab(text: 'Pending'),
              Tab(text: 'Completed'),
            ],
          ),
        ),
        body: filteredTasks.isEmpty
            ? const Center(
                child: Text('No tasks available.'),
              )
            : ListView.builder(
                itemCount: filteredTasks.length,
                itemBuilder: (context, index) {
                  final task = filteredTasks[index];
                  return Dismissible(
                    key: ValueKey(task.id),
                    direction: DismissDirection.endToStart,
                    confirmDismiss: (direction) =>
                        _confirmDismiss(direction, task),
                    onDismissed: (_) {
                      _deleteTask(task);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Task "${task.title}" deleted.'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                    background: Container(
                      color: Colors.red.withOpacity(0.8),
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    child: TaskCard(
                      task: task,
                      onToggleStatus: () => _toggleTaskStatus(task),
                      onEdit: () => _editTask(task),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
