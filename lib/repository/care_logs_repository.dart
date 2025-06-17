import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:ppb_fp_9/models/care_logs_model.dart';

class CareLogsRepository extends GetxController {
  static CareLogsRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  Future<List<CareLogsModel>> fetchLogsForPlant(String plantId) async {
    try {
      final documentSnapshot = await _db
          .collection("users").doc(FirebaseAuth.instance.currentUser?.uid)
          .collection("plants").doc(plantId)
          .collection("care-logs")
          .orderBy('eventDate', descending: true)
          .get();
      // print("DEBUG logs (snapshot): $documentSnapshot");

      return documentSnapshot.docs.map((document) => CareLogsModel.fromFirestore(document, null)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addLogToPlant(String plantId, CareLogsModel log) async {
    try {
      await _db
          .collection('users').doc(FirebaseAuth.instance.currentUser?.uid)
          .collection('plants').doc(plantId)
          .collection('care-logs')
          .add(log.toFirestore());
    } catch (e) {
      throw 'Error adding care log: $e';
    }
  }

  Future<void> updateLog(String plantId, String logId, CareLogsModel log) async {
    try {
      await _db
          .collection('users').doc(FirebaseAuth.instance.currentUser?.uid)
          .collection('plants').doc(plantId)
          .collection('care-logs').doc(logId)
          .update(log.toFirestore());
    } catch (e) {
      throw 'Error updating care log: $e';
    }
  }

  Future<void> deleteLog(String plantId, String logId) async {
    try {
      await _db
          .collection('users').doc(FirebaseAuth.instance.currentUser?.uid)
          .collection('plants').doc(plantId)
          .collection('care-logs').doc(logId)
          .delete();
    } catch (e) {
      throw 'Error deleting care log: $e';
    }
  }
}
