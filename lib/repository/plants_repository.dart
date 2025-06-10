import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ppb_fp_9/models/plants_model.dart';

class PlantsRepository extends GetxController {
  static PlantsRepository get instance => Get.find();

  final _db = FirebaseFirestore.instance;

  // function to save user data to firestore
  Future<void> savePlant(PlantsModel plant) async {
    try {
      print('DEBUG (user_repositories.dart): Coba save user ke firebase firestore');
      await _db.collection('Users').doc(plant.id).set(plant.toFirestore());
      print('DEBUG (user_repositories.dart): selesai save user ke firebase firestore');
    } catch (e) {
      throw 'Something went wrong. Please try again.';
    }
  }

  Future<List<PlantsModel>> fetchPlants() async {
    try {
      final documentSnapshot = await _db
          // .collection("users").doc(FirebaseAuth.instance.currentUser?.uid)
          .collection("plants")
          .get();
      return documentSnapshot.docs.map((document) => PlantsModel.fromFirestore(document)).toList();
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }


  Future<void> updatePlantDetails(PlantsModel updatedPlant) async {
    try {
      await _db.collection("users").doc(FirebaseAuth.instance.currentUser?.uid).collection("plants").doc(updatedPlant.id).update(updatedPlant.toFirestore());
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  Future<void> updateSingleField(Map<String, dynamic> json, String plantId) async {
    try {
      await _db
          .collection("users").doc(FirebaseAuth.instance.currentUser?.uid).collection("plants")
          .doc(plantId)
          .update(json);
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  Future<void> removeUserRecord(String plantId) async {
    try {
      // final currentUid = FirebaseAuth.instance.currentUser?.uid;
      // if (currentUid != userId) {
      //   throw 'Unauthorized action';
      // }
      await _db.collection("users").doc(FirebaseAuth.instance.currentUser?.uid).collection("plants").doc(plantId).delete();
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  // Future<String> uploadImage(String path, XFile image) async {
  //   try{
  //     final ref = FirebaseStorage.instance.ref(path).child(image.name);
  //     await ref.putFile(File(image.path));
  //
  //     final url = await ref.getDownloadURL();
  //     return url;
  //   } catch (e) {
  //     throw 'Something went wrong. Please try again';
  //   }
  // }
}
