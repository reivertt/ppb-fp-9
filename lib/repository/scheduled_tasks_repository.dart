import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:ppb_fp_9/models/scheduled_tasks_model.dart';

class ScheduledTasksRepository extends GetxController {
  static ScheduledTasksRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  // function to save user data to firestore
  Future<void> saveScheduledTask(String plantId, ScheduledTasksModel scheduledTask) async {
    try {
      await _db
          .collection("users").doc(FirebaseAuth.instance.currentUser?.uid)
          .collection('plants').doc(plantId)
          .collection('scheduledTasks').doc(scheduledTask.id)
          .set(scheduledTask.toFirestore());
    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }

  Future<List<ScheduledTasksModel>> fetchTasksForPlant(String plantId) async {
    try {
      final documentSnapshot = await _db
          .collection("users").doc(FirebaseAuth.instance.currentUser?.uid)
          .collection("plants").doc(plantId)
          .collection('scheduledTasks')
          .get();
      // print("DEBUG plants (snapshot): ${documentSnapshot}");
      // print("DEBUG plants (PlantsModel):  ${documentSnapshot.docs.map((document) => PlantsModel.fromFirestore(document)).toList()[0].commonName}");
      return documentSnapshot.docs.map((document) => ScheduledTasksModel.fromFirestore(document, null)).toList();
    } catch (e) {
      rethrow;
      // throw 'Something went wrong. Please try again';
    }
  }

  Future<void> updateScheduledTask(String plantId, ScheduledTasksModel updatedScheduledTask) async {
    try {
      await _db
          .collection("users").doc(FirebaseAuth.instance.currentUser?.uid)
          .collection("plants").doc(plantId)
          .collection("scheduledTasks").doc(updatedScheduledTask.id)
          .update(updatedScheduledTask.toFirestore());
    } catch (e) {
      throw Exception('Error updating plant in Firestore: $e');
    }
  }

  Future<void> deleteScheduledTask(String plantId, String scheduledTaskId) async {
    try {
      await _db
          .collection("users").doc(FirebaseAuth.instance.currentUser?.uid)
          .collection("plants").doc(plantId)
          .collection("scheduledTasks").doc(scheduledTaskId).delete();
    } catch (e) {
      // Re-throw the error to be caught by the controller
      throw Exception('Error deleting plant from Firestore: $e');
    }
  }

  Future<List<ScheduledTasksModel>> fetchTasksForUser() async {
    try {
      final snapshot = await _db
          .collectionGroup('scheduledTasks')
          .where('userId', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
          .get();
      return snapshot.docs.map((document) => ScheduledTasksModel.fromFirestore(document, null)).toList();
    } catch (e) {
      throw Exception('Error updating plant from Firestore: $e');
    }
  }

}
