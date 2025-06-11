import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ppb_fp_9/controller/encyclopedia_controller.dart'; // <-- Use the new EncyclopediaController

class EncyclopediaItem extends StatelessWidget {
  const EncyclopediaItem({super.key});

  @override
  Widget build(BuildContext context) {
    final encyclopediaController = Get.put(EncyclopediaController());

    return Scaffold(
      backgroundColor: const Color(0xFFEDFFF1),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          encyclopediaController.fetchAllPlants();
        },
        backgroundColor: const Color(0xFF046526),
        tooltip: 'Search Plant',
        child: const Icon(Icons.arrow_forward, color: Colors.white, size: 28),
      ),
      body: Obx(() {
        if (encyclopediaController.isLoading.value && encyclopediaController.allPlants.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (encyclopediaController.allPlants.isEmpty) {
          return const Center(child: Text('No plants found.'));
        }

        return GridView.builder(
          padding: const EdgeInsets.all(16.0),
          // --- Grid Configuration ---
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            childAspectRatio: 0.75,
          ),
          itemCount: encyclopediaController.allPlants.length,
          itemBuilder: (context, index) {
            final plant = encyclopediaController.allPlants[index];

            return InkWell(
              onTap: () {

                // Get.to(() => PlantDetail(plant: plant));
                print("Tapped on plant ID: ${plant.id}");
              },
              child: Card(
                color: Color(0xFFFCFDFC),
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Image.network(
                        plant.imgUrl ?? 'https://images-cdn.ubuy.co.id/6369ceadde00db205016ea52-peashooter-from-plants-vs-zombies-vinyl.jpg',
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(child: CircularProgressIndicator());
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(child: Icon(Icons.broken_image, size: 40, color: Colors.grey));
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        plant.commonName ?? 'Unnamed Plant',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
