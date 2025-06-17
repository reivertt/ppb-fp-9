import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ppb_fp_9/controller/care_logs_controller.dart';
import 'package:ppb_fp_9/models/care_logs_model.dart';

class AddCareLogsScreen extends StatefulWidget {
  final String plantId;
  final CareLogsModel? log;

  const AddCareLogsScreen({
    super.key,
    required this.plantId,
    this.log,
  });

  @override
  State<AddCareLogsScreen> createState() => _AddCareLogsScreenState();
}

class _AddCareLogsScreenState extends State<AddCareLogsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  DateTime? _selectedLogDate;
  bool _isSaving = false;

  bool get isEditMode => widget.log != null;

  @override
  void initState() {
    super.initState();
    if (isEditMode) {
      _titleController.text = widget.log!.title;
      _descriptionController.text = widget.log!.description!;
      _selectedLogDate = widget.log!.eventDate.toDate();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 5, now.month, now.day);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedLogDate ?? now,
      firstDate: firstDate,
      lastDate: now,
    );
    if (pickedDate != null) {
      setState(() {
        _selectedLogDate = pickedDate;
      });
    }
  }

  void _deleteLog() {
    Get.defaultDialog(
        title: "Delete Log",
        middleText: "Are you sure you want to delete this log entry?",
        textConfirm: "Delete",
        textCancel: "Cancel",
        confirmTextColor: Colors.white,
        buttonColor: Colors.red.shade700,
        onConfirm: () async {
          Get.back(); // Close dialog
          setState(() { _isSaving = true; });
          try {
            final controller = Get.find<CareLogsController>();
            await controller.deleteCareLog(widget.plantId, widget.log!.id!);
            await controller.fetchCareLogs(widget.plantId);
            Get.back();
            Get.snackbar('Success', 'Log entry deleted successfully.', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green, colorText: Colors.white);
          } catch (e) {
            Get.snackbar('Error', 'Failed to delete log: ${e.toString()}', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
          } finally {
            if(mounted) {
              setState(() { _isSaving = false; });
            }
          }
        }
    );
  }

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (_selectedLogDate == null) {
      Get.snackbar('Missing Date', 'Please select a date for this log entry.', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.yellow, colorText: Colors.white);
      return;
    }

    setState(() { _isSaving = true; });

    try {
      final controller = Get.find<CareLogsController>();
      final logData = CareLogsModel(
        id: widget.log?.id,
        userId: FirebaseAuth.instance.currentUser!.uid,
        plantId: widget.plantId,
        title: _titleController.text,
        description: _descriptionController.text,
        eventDate: Timestamp.fromDate(_selectedLogDate!),
        createdAt: widget.log?.createdAt ?? Timestamp.now(),
        updatedAt: Timestamp.now(),
      );

      if (isEditMode) {
        await controller.updateCareLog(widget.plantId, logData.id!, logData);
        await controller.fetchCareLogs(widget.plantId);
        Get.back();
        Get.snackbar('Success', 'Care log has been updated.', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        await controller.addCareLog(widget.plantId, logData);
        await controller.fetchCareLogs(widget.plantId);
        Get.back();
        Get.snackbar('Success', 'New care log has been added.', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green, colorText: Colors.white);
      }
    } catch (e) {
      rethrow;
      Get.snackbar('Error', 'Failed to save log: ${e.toString()}', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      if (mounted) {
        setState(() { _isSaving = false; });
      }

    }
  }

  @override
  Widget build(BuildContext context) {
    const labelStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 14);

    return Scaffold(
      backgroundColor: const Color(0xFFEDFFF1),
      appBar: AppBar(
        title: Text(isEditMode ? 'Edit Care Log' : 'Add Care Log'),
        backgroundColor: const Color(0xFF046526),
        foregroundColor: Colors.white,
        actions: [
          if(isEditMode)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: _deleteLog,
            )
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
                  hintText: 'e.g., Watered, Repotted, Fertilized',
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF046526)),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a title for the log.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              const Text('Description (Optional)', style: labelStyle),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  hintText: 'e.g., Used 200ml of water.',
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF046526)),
                  ),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              const Text('Log Date*', style: labelStyle),
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
                      _selectedLogDate == null
                          ? 'No Date Chosen'
                          : 'Date: ${DateFormat.yMd().format(_selectedLogDate!)}',
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
                    : Text(isEditMode ? 'Update Log' : 'Save Log'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
