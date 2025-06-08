import 'package:cloud_firestore/cloud_firestore.dart';

class Repeat {
  final String unit;
  final int value;

  Repeat({
    required this.unit,
    required this.value
  });

  factory Repeat.fromMap(Map<String, dynamic> map) {
    return Repeat(
      unit: map['unit'] as String,
      value: map['value'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return{
      'unit': unit,
      'value': value
    };
  }
}

class ScheduledTasksModel {
  final String? id;
  final String userId;
  final String plantId;
  final String title;
  final String message;
  final String status;
  final Timestamp scheduledAt;
  final Repeat? repeat;
  final Timestamp createdAt;
  final Timestamp updatedAt;

  ScheduledTasksModel({
    this.id,
    required this.userId,
    required this.plantId,
    required this.title,
    required this.message,
    required this.status,
    required this.scheduledAt,
    this.repeat,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory constructor to create a Plant from a Firestore document
  factory ScheduledTasksModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions? options) {
    final data = snapshot.data()!;

    final repeatData = data['repeat'];

    return ScheduledTasksModel(
      id: snapshot.id,
      userId: data['userId'],
      plantId: data['plantId'],
      title: data['title'],
      message: data['message'],
      status: data['status'],
      repeat: repeatData != null? Repeat.fromMap(repeatData) : null,
      scheduledAt: data['scheduledAt'],
      createdAt: data['createdAt'],
      updatedAt: data['updatedAt'],
    );
  }

  // Method to convert a ScheduledTask instance to a Map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'plantId': plantId,
      'userId': userId,
      'title': title,
      'message': message,
      'status': status,
      'scheduledAt': scheduledAt,
      if (repeat != null) 'repeat': repeat!.toMap(),
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}