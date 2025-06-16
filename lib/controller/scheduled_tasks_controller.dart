import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ppb_fp_9/models/scheduled_tasks_model.dart';
import 'package:ppb_fp_9/repository/scheduled_tasks_repository.dart';

class ScheduledTasksController extends GetxController {
  static ScheduledTasksController get instance => Get.find();
  final isLoading = false.obs;
  final isSaving = false.obs;

  final _tasksRepository = Get.put(ScheduledTasksRepository());

  final RxList<ScheduledTasksModel> tasksForCurrentPlant = <ScheduledTasksModel>[].obs;
  final RxList<ScheduledTasksModel> allUserTasks = <ScheduledTasksModel>[].obs;

  Future<void> fetchTasksForPlant(String plantId) async {
    try {
      isLoading.value = true;
      final tasks = await _tasksRepository.fetchTasksForPlant(plantId);
      tasksForCurrentPlant.assignAll(tasks);
    } catch (e) {
      _showErrorSnackbar('Failed to fetch tasks', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchAllTasksForUser() async {
    try {
      isLoading.value = true;
      final tasks = await _tasksRepository.fetchTasksForUser();
      allUserTasks.assignAll(tasks);
    } catch (e) {
      _showErrorSnackbar('Failed to load schedule', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveScheduledTask(String plantId, ScheduledTasksModel newTask) async {
    try {
      isSaving.value = true;
      await _tasksRepository.saveScheduledTask(plantId, newTask);
      await fetchTasksForPlant(plantId);
      _showSuccessSnackbar('Success', 'Task has been scheduled.');
    } catch (e) {
      _showErrorSnackbar('Data not saved!', e.toString());
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> updateScheduledTask(String plantId, ScheduledTasksModel updatedTask) async {
    try {
      isSaving.value = true;
      await _tasksRepository.updateScheduledTask(plantId, updatedTask);
      await fetchTasksForPlant(plantId);
      _showSuccessSnackbar('Success', 'Task has been updated.');
    } catch (e) {
      _showErrorSnackbar('Failed to update task', e.toString());
    } finally {
      isSaving.value = false;
    }
  }


  Future<void> deleteScheduledTask(String plantId, String taskId) async {
    try {
      Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);

      await _tasksRepository.deleteScheduledTask(plantId, taskId);
      tasksForCurrentPlant.removeWhere((task) => task.id == taskId);

      Get.back();
      _showSuccessSnackbar('Success', 'Task was successfully deleted.');

    } catch (e) {
      Get.back();
      _showErrorSnackbar('Failed to delete task', e.toString());
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

  void _showSuccessSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      isDismissible: true,
      shouldIconPulse: true,
      colorText: Colors.white,
      backgroundColor: Colors.green,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 3),
      margin: const EdgeInsets.all(20),
      icon: const Icon(Iconsax.tick_circle, color: Colors.white),
    );
  }
}
