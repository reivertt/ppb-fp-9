import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ppb_fp_9/models/species_model.dart';
import 'package:ppb_fp_9/repository/encyclopedia_repository.dart';

class EncyclopediaController extends GetxController {
  static EncyclopediaController get instance => Get.find();

  final isLoading = false.obs;
  final RxList<SpeciesModel> allPlants = <SpeciesModel>[].obs;
  final encyclopediaRepository = Get.put(EncyclopediaRepository());
  int currentPage = 1;

  @override
  void onInit() {
    fetchAllPlants();
    super.onInit();
  }

  Future<void> fetchAllPlants() async {
    try {
      isLoading.value = true;
      // print("Fetching Plants, page ${currentPage}");
      final plants = await encyclopediaRepository.getAllPlants(page: currentPage);
      // print("Got Plants: ${plants.length}");
      allPlants.assignAll(plants);
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

  Future<void> loadNextPage() async {
    currentPage++;
    await fetchAllPlants();
  }
}