import 'package:flutter/material.dart';

class AddPlantScreen extends StatefulWidget {
  const AddPlantScreen({super.key});

  @override
  State<AddPlantScreen> createState() => _AddPlantScreenState();
}

class _AddPlantScreenState extends State<AddPlantScreen> {
  // A GlobalKey to identify and manage the form
  final _formKey = GlobalKey<FormState>();

  // Controllers to read the text from the input fields
  final _plantNameController = TextEditingController();
  final _plantDetailsController = TextEditingController();

  // Clean up the controllers when the widget is removed from the widget tree
  @override
  void dispose() {
    _plantNameController.dispose();
    _plantDetailsController.dispose();
    super.dispose();
  }

  void _submitForm() {
    // This validates the form. If all fields are valid, it returns true.
    if (_formKey.currentState!.validate()) {
      // If the form is valid, we can process the data.
      final plantName = _plantNameController.text;
      final plantDetails = _plantDetailsController.text;

      // For now, just print it to the console and show a confirmation.
      print('Plant Name: $plantName');
      print('Plant Details: $plantDetails');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$plantName added to your garden!'),
          backgroundColor: Colors.green,
        ),
      );

      // Go back to the previous screen after submitting
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDFFF1),
      appBar: AppBar(
        title: const Text('Add Your Own Plant'),
        backgroundColor: const Color(0xFF046526),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        // Use a Form widget to enable validation
        child: Form(
          key: _formKey,
          child: ListView( // Use ListView to prevent overflow on smaller screens
            children: [
              // Plant Name Text Field
              TextFormField(
                controller: _plantNameController,
                decoration: const InputDecoration(
                  labelText: 'Plant Name',
                  hintText: 'e.g., Monstera Deliciosa',
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF046526)),
                  ),
                ),
                // Validator to ensure the field is not empty
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter the plant name.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Plant Details Text Field
              TextFormField(
                controller: _plantDetailsController,
                decoration: const InputDecoration(
                  labelText: 'Other Details',
                  hintText: 'e.g., Needs bright, indirect light',
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF046526)),
                  ),
                ),
                maxLines: 4, // Make the text field taller
              ),
              const SizedBox(height: 32),

              // Submit Button
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF046526),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}