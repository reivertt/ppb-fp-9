import 'package:cloud_firestore/cloud_firestore.dart';

class PlantsModel {
  final String? id;
  final String userId;
  final String? customName;
  final String commonName;
  final String? imgUrl;
  final Timestamp? plantedDate;
  final Timestamp? createdAt;
  final Timestamp? updatedAt;

  PlantsModel({
    this.id,
    required this.userId,
    this.customName,
    required this.commonName,
    this.imgUrl,
    required this.plantedDate,
    required this.createdAt,
    required this.updatedAt,
  });

  // Factory constructor to create a Plant from a Firestore document
  factory PlantsModel.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions? options) {
    final data = snapshot.data()!;
    return PlantsModel(
      id: snapshot.id,
      userId: data['userId'],
      customName: data['customName'] as String?,
      commonName: data['commonName'],
      imgUrl: data['imgUrl'],
      plantedDate: data['plantedDate'],
      createdAt: data['createdAt'],
      updatedAt: data['updatedAt'],
    );
  }

  // Method to convert a Plant instance to a Map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      if (customName != null) 'customName': customName,
      'commonName': commonName,
      if (imgUrl != null) 'imgUrl': imgUrl,
      'plantedDate': plantedDate,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  static PlantsModel empty() => PlantsModel(
    id: '',
    userId: '',
    customName: '',
    commonName: '',
    imgUrl: '',
    plantedDate: null,
    createdAt: null,
    updatedAt: null,
  );
}