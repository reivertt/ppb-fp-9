import 'package:cloud_firestore/cloud_firestore.dart';

class CareLogsModel {
  final String? id;
  final String userId;
  final String plantId;
  final String title;
  final String? description;
  final String? imgUrl;
  final Timestamp eventDate;
  final List<String>? tags;
  final Timestamp createdAt;
  final Timestamp updatedAt;

  CareLogsModel({
    this.id,
    required this.userId,
    required this.plantId,
    required this.title,
    this.description,
    this.imgUrl,
    required this.eventDate,
    this.tags,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory constructor to create a Plant from a Firestore document
  factory CareLogsModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions? options) {
    final data = snapshot.data()!;

    return CareLogsModel(
      id: snapshot.id,
      userId: data['userId'],
      plantId: data['plantId'],
      title: data['title'],
      description: data['description'] as String?,
      imgUrl: data['imgUrl'] as String?,
      eventDate: data['eventDate'],
      tags: data['tags'] is List ? List<String>.from(data['tags']) : null,
      createdAt: data['createdAt'],
      updatedAt: data['updatedAt'],
    );
  }

  // Method to convert a CareLogs instance to a Map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'plantId': plantId,
      'userId': userId,
      'title': title,
      if (description != null) 'description': description,
      if (imgUrl != null) 'imgUrl': imgUrl,
      'eventDate': eventDate,
      if (tags != null) 'tags': tags,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}