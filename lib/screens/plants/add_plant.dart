import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:ppb_fp_9/controller/plants_controller.dart';

import 'package:ppb_fp_9/models/plants_model.dart';
import 'package:ppb_fp_9/models/species_model.dart';

class AddPlantScreen extends StatefulWidget {
  const AddPlantScreen({super.key});

  @override
  State<AddPlantScreen> createState() => _AddPlantScreenState();
}

class _AddPlantScreenState extends State<AddPlantScreen> {
  final _formKey = GlobalKey<FormState>();
  final _commonNameController = TextEditingController();
  final _customNameController = TextEditingController();

  DateTime? _selectedPlantedDate;
  bool _isSaving = false;
  String? _imageUrl;

  @override
  void initState(){
    super.initState();
    if (Get.arguments != null && Get.arguments is SpeciesModel) {
      final species = Get.arguments as SpeciesModel;
      _commonNameController.text = species.commonName ?? '';
      _imageUrl = species.imgUrl;
    }
  }

  @override
  void dispose() {
    _commonNameController.dispose();
    _customNameController.dispose();
    super.dispose();
  }

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 5, now.month, now.day);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: now,
    );
    setState(() {
      _selectedPlantedDate = pickedDate;
    });
  }

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (_selectedPlantedDate == null) {
      Get.snackbar(
        'Missing Date',
        'Please select the date you planted your plant.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.shade800,
        colorText: Colors.white,
      );
      return;
    }
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Get.snackbar('Error', 'No user logged in. Please log in again.');
      return;
    }

    setState(() { _isSaving = true; });

    try {
      final plantsController = Get.find<PlantsController>();
      final now = Timestamp.now();
      final newPlant = PlantsModel(
        userId: user.uid,
        commonName: _commonNameController.text,
        customName: _customNameController.text.isNotEmpty ? _customNameController.text : null,
        imgUrl: _imageUrl,
        plantedDate: Timestamp.fromDate(_selectedPlantedDate!),
        createdAt: now,
        updatedAt: now,
      );
      await plantsController.savePlant(newPlant);
      await plantsController.fetchAllPlants();
      Get.snackbar(
        'Success',
        '${newPlant.commonName} was added to your garden!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF046526),
        colorText: Colors.white,
      );
      if (mounted) Navigator.pop(context);
    } finally {
      setState(() { _isSaving = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    // A consistent style for the labels
    const labelStyle = TextStyle(fontWeight: FontWeight.bold, fontSize: 14);

    return Scaffold(
      backgroundColor: const Color(0xFFEDFFF1),
      appBar: AppBar(
        title: const Text('Add Your Own Plant'),
        backgroundColor: const Color(0xFF046526),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // --- 1. COMMON NAME FIELD ---
              const Text('Common Name*', style: labelStyle),
              const SizedBox(height: 8),
              TextFormField(
                controller: _commonNameController,
                decoration: const InputDecoration(
                  // REMOVED: labelText
                  hintText: 'e.g., Monstera Deliciosa',
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF046526)),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter the plant\'s common name.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // --- 2. CUSTOM NAME FIELD ---
              const Text('Custom Name / Nickname (Optional)', style: labelStyle),
              const SizedBox(height: 8),
              TextFormField(
                controller: _customNameController,
                decoration: const InputDecoration(
                  // REMOVED: labelText
                  hintText: 'e.g., My Desk Buddy',
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF046526)),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // --- 3. PLANTED DATE FIELD ---
              const Text('Planted Date*', style: labelStyle),
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
                      _selectedPlantedDate == null
                          ? 'No Date Chosen'
                          : 'Planted on: ${DateFormat.yMd().format(_selectedPlantedDate!)}',
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

              // --- SUBMIT BUTTON ---
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
                    : const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}