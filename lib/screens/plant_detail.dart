import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ppb_fp_9/models/plants_model.dart';
import 'package:ppb_fp_9/screens/plants/add_plant.dart';

import '../controller/plants_controller.dart';

class PlantDetail extends StatelessWidget {
  final String plantId;
  const PlantDetail({super.key, required this.plantId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PlantsController>();

    void showDeleteConfirmationDialog() {
      Get.defaultDialog(
        title: "Delete Plant",
        middleText: "Are you sure you want to delete '${controller.allPlants.firstWhere((p) => p.id == plantId).commonName}'? This action cannot be undone.",
        textConfirm: "Delete",
        textCancel: "Cancel",
        confirmTextColor: Colors.white,
        onConfirm: () {
          controller.deletePlant(plantId); // Call controller to delete
        },
      );
    }

    return Obx(
      () {
        final Rx<PlantsModel>? plant = controller.allPlants.firstWhere((p) => p.id == plantId).isNull ? null : controller.allPlants.firstWhere((p) => p.id == plantId).obs;
        
        if (plant == null) {
          return Scaffold(
            backgroundColor: const Color(0xFFEDFFF1),
            appBar: AppBar(
              title: Text(plant!.value.commonName),
              backgroundColor: const Color(0xFF046526),
              foregroundColor: Colors.white,
            ),
            body: Center(child: Text("No plant data found."),)
          );
        }
        
        return Scaffold(
          backgroundColor: const Color(0xFFEDFFF1),
          appBar: AppBar(
            title: Text(plant!.value.commonName),
            backgroundColor: const Color(0xFF046526),
            foregroundColor: Colors.white,
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- PLANT IMAGE ---
                Image.network(
                  plant!.value.imgUrl ??
                      "https://storage.googleapis.com/proudcity/mebanenc/uploads/2021/03/placeholder-image.png",
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const SizedBox(
                        height: 250,
                        child: Center(child: CircularProgressIndicator()));
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const SizedBox(
                        height: 250,
                        child: Center(child: Icon(
                            Icons.broken_image, size: 60, color: Colors.grey)));
                  },
                ),

                // --- DETAILS SECTION ---
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        plant.value.commonName,
                        style: const TextStyle(fontWeight: FontWeight.bold,
                            fontSize: 24,
                            color: Color(0xFF046526)),
                      ),
                      if (plant.value.customName != null &&
                          plant.value.customName!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            '"${plant.value.customName!}"', // Nickname
                            style: const TextStyle(fontSize: 18,
                                fontStyle: FontStyle.italic,
                                color: Colors.black54),
                          ),
                        ),

                      const SizedBox(height: 24),

                      // --- INFO TILES ---
                      InfoTile(
                        icon: Icons.calendar_today,
                        label: 'Planted On',
                        value: plant.value.plantedDate != null
                            ? DateFormat.yMMMMd().format(plant.value
                            .plantedDate!.toDate())
                            : 'No date set',
                      ),
                      InfoTile(
                        icon: Icons.access_time,
                        label: 'Entry Created',
                        value: plant.value.createdAt != null
                            ? DateFormat.yMMMMd().format(plant!.value.createdAt!
                            .toDate())
                            : 'N/A',
                      ),

                      const SizedBox(height: 32),

                      // --- ACTION BUTTONS ---
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              icon: const Icon(Icons.edit),
                              label: const Text('Edit'),
                              onPressed: () {
                                // Navigate to the Add/Edit screen, passing the existing plant data
                                Get.to(() =>
                                    AddPlantScreen(plant: plant!.value));
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFF046526),
                                side: const BorderSide(
                                    color: Color(0xFF046526)),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.delete_outline),
                              label: const Text('Delete'),
                              onPressed: showDeleteConfirmationDialog,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red.shade700,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}

// Helper widget for displaying information neatly
class InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const InfoTile({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey.shade600, size: 20),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(color: Colors.grey.shade700)),
              Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            ],
          ),
        ],
      ),
    );
  }
}