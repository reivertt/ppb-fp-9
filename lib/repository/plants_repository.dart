import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ppb_fp_9/models/plants_model.dart';
import 'package:tni_al/utils/exceptions/firebase_auth_exceptions.dart';
import 'package:tni_al/utils/exceptions/firebase_exceptions.dart';
import 'package:tni_al/utils/exceptions/format_exceptions.dart';
import 'package:tni_al/utils/exceptions/platform_exceptions.dart';

import '../authentication/authentication_repository.dart';

class PlantsRepository extends GetxController {
  static PlantsRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

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

  Future<PlantsModel> fetchPlantDetails() async {
    try {
      final documentSnapshot = await _db
          .collection("Plants")
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .get();

      if (documentSnapshot.exists) {
        return PlantsModel.fromFirestore(documentSnapshot);
      } else {
        return PlantsModel.empty();
      }
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }


  Future<void> updatePlantDetails(PlantsModel updatedPlant) async {
    try {
      await _db.collection("Plants").doc(updatedPlant.id).update(updatedPlant.toFirestore());
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  Future<void> updateSingleField(Map<String, dynamic> json) async {
    try {
      await _db
          .collection("Plants")
          .doc(FirebaseAuth.instance.currentUser?.uid)
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
      await _db.collection("Plants").doc(plantId).delete();
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
