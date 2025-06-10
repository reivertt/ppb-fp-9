import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ppb_fp_9/models/plants_model.dart';
import 'package:ppb_fp_9/repository/plants_repository.dart';
import 'package:tni_al/data/repositories/products/product_repository.dart';
import 'package:tni_al/features/shop/models/category_model.dart';
import 'package:tni_al/utils/popups/loaders.dart';

import '../../models/product_model.dart';

class ProductController extends GetxController {
  static ProductController get instance => Get.find();

  final isLoading = false.obs;
  final plantsRepository = Get.put(PlantsRepository());
  final RxList<PlantsModel> featuredProducts = <PlantsModel>[].obs;
  final RxList<PlantsModel> featuredCategoryProducts = <PlantsModel>[].obs;

  @override
  void onInit() {
    fetchAllPlants();
    super.onInit();
  }

  Future<void> fetchAllPlants() async {
    try {
      isLoading.value = true;

      final plants = await plantsRepository.fetchPlants();

      featuredProducts.assignAll(plants);
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
        "Something went wrong while saving your information. Please try again later.",
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
}