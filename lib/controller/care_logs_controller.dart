import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ppb_fp_9/models/care_logs_model.dart';
import 'package:ppb_fp_9/repository/care_logs_repository.dart';

class CareLogsController extends GetxController {
  static CareLogsController get instance => Get.find();

  final _careLogRepository = Get.put(CareLogsRepository());
  final RxList<CareLogsModel> careLogs = <CareLogsModel>[].obs;
  final isLoading = false.obs;

  Future<void> fetchCareLogs(String plantId) async {
    print("DEBUG log cont-fetch called");
    try {
      isLoading.value = true;
      final logs = await _careLogRepository.fetchLogsForPlant(plantId);
      careLogs.assignAll(logs);
      print("DEBUG log cont-assigned");

    }
    catch (e) {
      _showErrorSnackbar('Failed to fetch care logs', e.toString());
    }
    finally {
      isLoading.value = false;
    }
  }

  Future<void> addCareLog(String plantId, CareLogsModel log) async {
    try {
      await _careLogRepository.addLogToPlant(plantId, log);
      print('Success - New care log added.');
    } catch (e) {
      print('Error - Failed to add log: ${e.toString()}');
    }
  }

  Future<void> updateCareLog(String plantId, String logId, CareLogsModel log) async {
    try {
      await _careLogRepository.updateLog(plantId, logId, log);
      await fetchCareLogs(plantId);
      print('Success - Care log has been updated.');
    } catch (e) {
      print('Error: Failed to update log: ${e.toString()}');
    }
  }

  Future<void> deleteCareLog(String plantId, String logId) async {
    try {
      await _careLogRepository.deleteLog(plantId, logId);
      print('Success - Care log has been deleted.');

    } catch (e) {
      print('Error - Failed to delete log: ${e.toString()}');
    }
  }

  void _showErrorSnackbar(String title, String message) {
    Get.snackbar(
      title,
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
