import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  DateTime? _selectedDate;

  // Dialog box untuk menambah & mengupdate logs
  void openLogBox({DocumentSnapshot? doc}) {
    String? docLogID = doc?.id;

    // Jika mode update, isi field dengan data yang ada. Jika tidak, kosongkan.
    if (doc != null) {
      _logTitleController.text = doc['title'];
      _logDescriptionController.text = doc['desc'];
      _selectedDate = (doc['plantdate'] as Timestamp).toDate();
    } else {
      _logTitleController.clear();
      _logDescriptionController.clear();
      _selectedDate = null;
    }

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setStateInDialog) {
          return AlertDialog(
            title: Text(doc == null ? "Add log to this plant" : "Update log"),
            content: SingleChildScrollView(
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
                  // date picker
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _selectedDate == null
                              ? 'Choose Log Date'
                              : DateFormat('dd MMMM yyyy').format(_selectedDate!),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.calendar_today),
                        onPressed: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: _selectedDate ?? DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101),
                          );
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
                    Timestamp logTimestamp = Timestamp.fromDate(_selectedDate!);

                    if (docLogID == null) {
                      // CREATE
                      _fireStoreService.addLogToPlant(
                        widget.docID,
                        _logTitleController.text,
                        _logDescriptionController.text,
                        logTimestamp,
                      );
                    } else {
                      // UPDATE
                      _fireStoreService.updateLog(
                        widget.docID,
                        docLogID,
                        _logTitleController.text,
                        _logDescriptionController.text,
                        logTimestamp,
                      );
                    }
                    Navigator.pop(context);
                  } else {
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
        title: Text("${widget.plantName} Logs",
          style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Color(0xFF046526),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightGreen,
        onPressed: () => openLogBox(),
        child: Icon(Icons.note_add, color: Colors.white),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _fireStoreService.getLogsStream(widget.docID),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List logsList = snapshot.data!.docs;
            if (logsList.isEmpty) {
              return Center(child: Text("No logs for this plant yet.."));
            }
            return ListView.builder(
              itemCount: logsList.length,
              itemBuilder: (context, index) {
                DocumentSnapshot document = logsList[index];
                String docLogID = document.id; // GET LOG ID
                Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                String logTitleText = data['title'];
                String logDescriptionText = data['desc'];
                Timestamp timestamp = data['plantdate'];
                DateTime dateTime = timestamp.toDate();

                return ListTile(
                  title: Text(logTitleText),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(logDescriptionText),
                      SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            DateFormat('EEEE, dd MMMM yyyy').format(dateTime),
                            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // UPDATE BUTTON
                              IconButton(
                                onPressed: () => openLogBox(doc: document),
                                icon: Icon(Icons.edit),
                              ),
                              // DELETE BUTTON
                              IconButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text("Delete Log"),
                                      content: Text("Are you sure you want to delete this log?"),
                                      actions: [
                                        TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel")),
                                        TextButton(
                                          onPressed: () {
                                            _fireStoreService.deleteLog(widget.docID, docLogID);
                                            Navigator.pop(context);
                                          },
                                          child: Text("Delete"),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                icon: Icon(Icons.delete),
                              ),
                            ],
                          )
                        ],
                      ),
                      Divider(height: 2, color: Colors.grey[400]),
                    ],
                  ),
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