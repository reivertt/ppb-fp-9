import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ppb_fp_9/models/species_model.dart';
import 'package:ppb_fp_9/repository/encyclopedia_repository.dart';

class EncyclopediaController extends GetxController {
  static EncyclopediaController get instance => Get.find();

  final isLoading = true.obs;
  final isFetchingMore = false.obs;
  final hasMorePlants = true.obs;

  final RxList<SpeciesModel> allPlants = <SpeciesModel>[].obs;
  final encyclopediaRepository = Get.put(EncyclopediaRepository());
  int _currentPage = 1;

  @override
  void onInit() {
    fetchInitialPlants();
    super.onInit();
  }

  Future<void> fetchInitialPlants() async {
    try {
      isLoading.value = true;
      _currentPage = 1;
      hasMorePlants.value = true;

      final plants = await encyclopediaRepository.getAllPlants(page: _currentPage);
      allPlants.assignAll(plants);

      if (plants.isEmpty) {
        hasMorePlants.value = false;
      }

    } catch (e) {
      _showErrorSnackbar(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchMorePlants() async {
    if (isFetchingMore.value || !hasMorePlants.value) return;

    try {
      isFetchingMore.value = true;
      _currentPage++;

      final newPlants = await encyclopediaRepository.getAllPlants(
          page: _currentPage);

      if (newPlants.isNotEmpty) {
        allPlants.addAll(
            newPlants);
      } else {
        hasMorePlants.value = false;
      }
    } catch (e) {
      _showErrorSnackbar(e.toString());
      _currentPage--;
    } finally {
      isFetchingMore.value = false;
    }
  }

  void _showErrorSnackbar(String message) {
    Get.snackbar(
      'Oh Snap!',
      message,
      isDismissible: true,
      shouldIconPulse: true,
      colorText: Colors.white,
      backgroundColor: Colors.red.shade600,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(20),
      icon: const Icon(Iconsax.warning_2, color: Colors.white),
    );
  }
}