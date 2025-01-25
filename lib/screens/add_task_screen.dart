import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/utils/format_date.dart';
import '../providers/task_provider.dart';
import '../models/task.dart';
import '../widgets/custom_textform_field.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _hoursController = TextEditingController();
  DateTime? _selectedDate = DateTime.now();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _hoursController.dispose();
    super.dispose();
  }

// _saveTask method add new Task
  void _saveTask() {
    if (_formKey.currentState?.validate() ?? false) {
      final taskProvider = Provider.of<TaskProvider>(
        context,
        listen: false,
      );

      final hours = int.tryParse(_hoursController.text);

      DateTime? dateTime;
      if (_selectedDate != null) {
        dateTime = DateTime(
          _selectedDate!.year,
          _selectedDate!.month,
          _selectedDate!.day,
          0,
          0,
        );
      }

      taskProvider.addTask(Task(
        id: DateTime.now().toString(),
        title: _titleController.text,
        description: _descriptionController.text,
        dateTime: dateTime,
        hours: hours,
      ));
      Navigator.of(context).pop();
    }
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (date != null) {
      setState(() {
        _selectedDate = date;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                          _selectedDate == null
                              ? 'No date selected'
                              : formatDate(_selectedDate!),
                          style: TextStyle(
                              fontSize: 18,
                              color: theme.primaryColor,
                              fontWeight: FontWeight.bold)),
                    ),
                    TextButton(
                      onPressed: _pickDate,
                      child: const Text(
                        'Change Date',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                CustomTextFormField(
                  controller: _titleController,
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
                const SizedBox(height: 20),
                CustomTextFormField(
                  controller: _descriptionController,
                  textCapitalization: TextCapitalization.sentences,
                  labelText: 'Description',
                  maxLines: 5,
                  maxLength: 200,
                ),
                const SizedBox(height: 20),
                CustomTextFormField(
                  controller: _hoursController,
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
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _saveTask,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    backgroundColor: theme.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Add Task'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
