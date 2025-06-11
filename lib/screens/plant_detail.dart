import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import paket intl untuk format tanggal
import 'package:ppb_fp_9/services/firestore.dart';

class PlantDetail extends StatefulWidget {
  final String plantName;
  final String docID;

  const PlantDetail({super.key, required this.plantName, required this.docID});

  @override
  State<PlantDetail> createState() => _PlantDetailState();
}

class _PlantDetailState extends State<PlantDetail> {
  final FireStoreService _fireStoreService = FireStoreService();
  final TextEditingController _logTitleController = TextEditingController();
  final TextEditingController _logDescriptionController = TextEditingController();
  DateTime? _selectedDate; // Variabel untuk menyimpan tanggal yang dipilih

  // Dialog box untuk menambah logs
  void openLogBox() {
    // Reset state setiap kali dialog dibuka
    _selectedDate = null;
    _logTitleController.clear();
    _logDescriptionController.clear();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder( // Gunakan StatefulBuilder agar UI di dalam dialog bisa diupdate
        builder: (context, setStateInDialog) {
          return AlertDialog(
            title: Text("Add log to this plant"),
            content: SingleChildScrollView( // Bungkus dengan SingleChildScrollView untuk menghindari overflow
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _logTitleController,
                    autofocus: true,
                    decoration: InputDecoration(hintText: "Write title for this log..."),
                  ),
                  SizedBox(height: 8),
                  TextField(
                    controller: _logDescriptionController,
                    decoration: InputDecoration(hintText: "Write description for this log..."),
                  ),
                  SizedBox(height: 16),
                  // Baris untuk menampilkan dan memilih tanggal
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _selectedDate == null
                              ? 'Choose Log Date'
                              : DateFormat('dd MMMM yyyy').format(_selectedDate!), // Format tanggal
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.calendar_today),
                        onPressed: () async {
                          // Tampilkan date picker
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: _selectedDate ?? DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101),
                          );
                          // Update state di dalam dialog jika tanggal dipilih
                          if (picked != null && picked != _selectedDate) {
                            setStateInDialog(() {
                              _selectedDate = picked;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  if (_logTitleController.text.isNotEmpty && _selectedDate != null) {
                    // Konversi DateTime ke Timestamp Firestore
                    Timestamp logTimestamp = Timestamp.fromDate(_selectedDate!);

                    _fireStoreService.addLogToPlant(
                      widget.docID,
                      _logTitleController.text,
                      _logDescriptionController.text,
                      logTimestamp, // Kirim timestamp yang sudah dikonversi
                    );

                    Navigator.pop(context);
                  } else {
                    // Opsional: Tampilkan pesan error jika judul atau tanggal kosong
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Title and Plant Date cannot be empty!')),
                    );
                  }
                },
                child: Text("Save"),
              )
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // toolbarHeight: 80,
        title: Text("${widget.plantName} Logs",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold
          ),
        ),
        backgroundColor: Color(0xFF046526),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightGreen,
        onPressed: openLogBox,
        child: Icon(Icons.note_add, color: Colors.white),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _fireStoreService.getLogsStream(widget.docID),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List logsList = snapshot.data!.docs;
            if (logsList.isEmpty) {
              return Center(
                child: Text("No logs for this plant yet.."),
              );
            }
            return ListView.builder(
              itemCount: logsList.length,
              itemBuilder: (context, index) {
                DocumentSnapshot document = logsList[index];
                Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                String logTitleText = data['title'];
                String logDescriptionText = data['desc'];
                Timestamp timestamp = data['plantdate']; // Gunakan field 'plantdate'
                DateTime dateTime = timestamp.toDate();

                return ListTile(
                    title: Text(logTitleText),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(logDescriptionText),
                        SizedBox(height: 4),
                        Text(
                          DateFormat('EEEE, dd MMMM yyyy').format(dateTime), // Format tanggal lebih baik
                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                      ],
                    )
                );
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}