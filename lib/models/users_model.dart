import 'package:cloud_firestore/cloud_firestore.dart';

class UsersModel {
  final String? id;
  final String displayName;
  final String email;
  final Timestamp createdAt;
  final Timestamp updatedAt;

  UsersModel({
    this.id,
    required this.displayName,
    required this.email,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory constructor to create a Plant from a Firestore document
  factory UsersModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions? options) {
    final data = snapshot.data()!;
    return UsersModel(
      id: snapshot.id,
      displayName: data['displayName'],
      email: data['email'],
      createdAt: data['createdAt'],
      updatedAt: data['updatedAt'],
    );
  }

  // Method to convert a Plant instance to a Map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'displayName': displayName,
      'email': email,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}