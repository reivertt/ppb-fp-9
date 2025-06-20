import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ppb_fp_9/models/plants_model.dart';
import 'package:ppb_fp_9/repository/plants_repository.dart';
// import 'package:tni_al/data/repositories/products/product_repository.dart';
// import 'package:tni_al/features/shop/models/category_model.dart';
// import 'package:tni_al/utils/popups/loaders.dart';
//
// import '../../models/product_model.dart';

class PlantsController extends GetxController {
  static PlantsController get instance => Get.find();

  final isLoading = false.obs;
  final plantsRepository = Get.put(PlantsRepository());
  final RxList<PlantsModel> allPlants = <PlantsModel>[].obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> fetchAllPlants() async {
    try {
      isLoading.value = true;

      print("DEBUG plant-repo *Masuk fetchAllPlants()*");

      final plants = await plantsRepository.fetchPlants();

      print("DEBUG plant-repo plants: ${plants}");


      allPlants.assignAll(plants);

      print("DEBUG plant-repo *keluar fetchAllPlants()*");
    } catch (e) {
      Get.snackbar(
        'Oh Snap!',
        e.toString(),
        isDismissible: true,
        shouldIconPulse: true,
        colorText: Colors.white,
        backgroundColor: Colors.red.shade600,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(20),
        icon: const Icon(Iconsax.warning_2, color: Colors.white),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> savePlant(PlantsModel newPlant) async {
    try {
      await plantsRepository.savePlant(newPlant);
    } catch (e) {
      Get.snackbar(
        "Data not saved!",
        e.toString(),
        isDismissible: true,
        shouldIconPulse: true,
        colorText: Colors.white,
        backgroundColor: Colors.orange,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
        margin: const EdgeInsets.all(20),
        icon: const Icon(Iconsax.warning_2, color: Colors.white),
      );
    }
  }

  Future<void> deletePlant(String plantId) async {
    try {
      final deletedPlant = allPlants.firstWhere((p) => p.id == plantId);

      if (FirebaseAuth.instance.currentUser?.uid != deletedPlant.userId) {
        Get.back();
        Get.snackbar('Error', 'Failed to delete plant: Unauthorized access!',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
        return;
      }

      Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);

      await plantsRepository.deletePlant(deletedPlant.id!);

      allPlants.removeWhere((plant) => plant.id == deletedPlant.id);

      Get.back();
      Get.back();
      Get.back();
      Get.back();

      Get.snackbar('Success', 'Plant was successfully deleted.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white);

    } catch (e) {
      Get.back();
      Get.snackbar('Error', 'Failed to delete plant: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }

  Future<void> updatePlant(PlantsModel updatedPlant) async {
    try {
      if (FirebaseAuth.instance.currentUser?.uid != updatedPlant.userId) {
        Get.back();
        Get.snackbar('Error', 'Failed to update plant: Unauthorized access!',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
        return;
      }

      await plantsRepository.updatePlant(updatedPlant);

      int index = allPlants.indexWhere((p) => p.id == updatedPlant.id);
      if (index != -1) {
        allPlants[index] = updatedPlant;
      }

      await fetchAllPlants();

    } catch (e) {
      Get.snackbar('Error', 'Failed to update plant: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }

}