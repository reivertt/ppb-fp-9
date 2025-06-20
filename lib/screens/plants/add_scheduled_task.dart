import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:ppb_fp_9/controller/scheduled_tasks_controller.dart';
import 'package:ppb_fp_9/models/scheduled_tasks_model.dart';
import 'package:ppb_fp_9/services/notification_service.dart';

class AddScheduledTaskScreen extends StatefulWidget {
  final String plantId;
  final ScheduledTasksModel? task;

  const AddScheduledTaskScreen({
    super.key,
    required this.plantId,
    this.task,
  });

  @override
  State<AddScheduledTaskScreen> createState() => _AddScheduledTaskScreenState();
}

class _AddScheduledTaskScreenState extends State<AddScheduledTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _messageController = TextEditingController();

  final NotificationService _notificationService = NotificationService();

  DateTime? _selectedScheduledAt;
  bool _isSaving = false;

  bool get isEditMode => widget.task != null;

  @override
  void initState() {
    super.initState();
    if (isEditMode) {
      _titleController.text = widget.task!.title;
      _messageController.text = widget.task!.message;
      _selectedScheduledAt = widget.task!.scheduledAt.toDate();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = now;
    final lastDate = DateTime(now.year + 5, now.month, now.day);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedScheduledAt ?? now,
      firstDate: firstDate,
      lastDate: lastDate,
    );
    if (pickedDate != null) {
      final pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedScheduledAt ?? now),
      );
      if (pickedTime != null) {
        setState(() {
          _selectedScheduledAt = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (_selectedScheduledAt == null) {
      Get.snackbar(
        'Missing Date', 'Please select the date and time for this task.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.shade800,
        colorText: Colors.white,
      );
      return;
    }

    setState(() { _isSaving = true; });

    try {
      final tasksController = Get.find<ScheduledTasksController>();
      final task = ScheduledTasksModel(
        id: widget.task?.id,
        userId: FirebaseAuth.instance.currentUser!.uid,
        plantId: widget.plantId,
        title: _titleController.text,
        message: _messageController.text,
        status: widget.task?.status ?? 'pending',
        scheduledAt: Timestamp.fromDate(_selectedScheduledAt!),
        createdAt: widget.task?.createdAt ?? Timestamp.now(),
        updatedAt: Timestamp.now(),
      );
      if (isEditMode) {
        await tasksController.updateScheduledTask(widget.plantId, task);
        await tasksController.fetchAllTasksForUser();
        await tasksController.fetchTasksForPlant(widget.plantId);
        await _notificationService.scheduleNotification(
          id: task.id!.hashCode,
          title: 'Reminder: ${task.title}',
          body: 'It\'s time for a task for your plant!',
          scheduledTime: _selectedScheduledAt!,
        );
        Get.back();
        Get.snackbar(
            'Success', 'Task was updated!', snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white);
      } else {
        final notificationId = DateTime
            .now()
            .millisecondsSinceEpoch
            .remainder(100000);
        await tasksController.saveScheduledTask(widget.plantId, task);
        await tasksController.fetchTasksForPlant(widget.plantId);
        await _notificationService.scheduleNotification(
          id: notificationId,
          title: 'New Task: ${task.title}',
          body: 'A new task has been scheduled for your plant.',
          scheduledTime: _selectedScheduledAt!,
        );
        Get.back();
        Get.snackbar('Success', 'A new task has been scheduled!',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: const Color(0xFF046526),
            colorText: Colors.white);
      }
    } catch (e) {
        rethrow;
    } finally {
      if (mounted) {
        setState(() { _isSaving = false; });
      }
    }
  }

  void _deleteTask() {
    Get.defaultDialog(
      title: "Delete Task",
      middleText: "Are you sure you want to delete this task? This action cannot be undone.",
      textConfirm: "Delete",
      textCancel: "Cancel",
      confirmTextColor: Colors.white,
      // buttonColor: Colors.red.shade700,
      onConfirm: () async {
        Get.back();
        try {
          // Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);
          final tasksController = Get.find<ScheduledTasksController>();
          await _notificationService.cancelNotification(widget.task!.id!.hashCode);
          await tasksController.deleteScheduledTask(widget.plantId, widget.task!.id!);

          // Get.back();
          Get.back();

          Get.snackbar('Success', 'Task was successfully deleted.',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green,
              colorText: Colors.white);
        } catch (e) {
          if(Get.isDialogOpen ?? false) Get.back();
          Get.snackbar('Error', 'Failed to delete task: ${e.toString()}',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red.shade700,
              colorText: Colors.white);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const labelStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 14);

    return Scaffold(
      backgroundColor: const Color(0xFFEDFFF1),
      appBar: AppBar(
        title: Text(isEditMode ? 'Edit Task' : 'Schedule New Task'),
        backgroundColor: const Color(0xFF046526),
        foregroundColor: Colors.white,
        actions: [
          if (isEditMode)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: _deleteTask,
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text('Title*', style: labelStyle),
              const SizedBox(height: 8),
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  hintText: 'e.g., Water the Monstera',
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF046526)),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a title for the task.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              const Text('Message / Notes (Optional)', style: labelStyle),
              const SizedBox(height: 8),
              TextFormField(
                controller: _messageController,
                decoration: const InputDecoration(
                  hintText: 'e.g., Use filtered water, check soil moisture first',
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF046526)),
                  ),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              const Text('Due Date & Time*', style: labelStyle),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedScheduledAt == null
                          ? 'No Date Chosen'
                          : 'Due: ${DateFormat.yMd().add_jm().format(_selectedScheduledAt!)}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    TextButton(
                      onPressed: _presentDatePicker,
                      child: const Text(
                        'Choose Date',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF046526)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isSaving ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF046526),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                child: _isSaving
                    ? const SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                )
                    : Text(isEditMode ? 'Update Task' : 'Save Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
