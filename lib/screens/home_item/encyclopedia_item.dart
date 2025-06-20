import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ppb_fp_9/controller/encyclopedia_controller.dart';
import 'package:ppb_fp_9/models/species_model.dart';
import 'package:ppb_fp_9/screens/plants/add_plant.dart';

class EncyclopediaItem extends StatefulWidget {
  const EncyclopediaItem({super.key});

  @override
  State<EncyclopediaItem> createState() => _EncyclopediaItemState();
}

class _EncyclopediaItemState extends State<EncyclopediaItem> {
  final encyclopediaController = Get.put(EncyclopediaController());
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent == _scrollController.position.pixels) {
        encyclopediaController.fetchMorePlants();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDFFF1),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          encyclopediaController.fetchInitialPlants();
        },
        backgroundColor: const Color(0xFF046526),
        tooltip: 'Refresh Plants',
        child: const Icon(Icons.refresh, color: Colors.white, size: 28),
      ),
      body: Obx(() {
        if (encyclopediaController.isLoading.value && encyclopediaController.allPlants.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (encyclopediaController.allPlants.isEmpty) {
          return const Center(child: Text('No plants found. Press the button to fetch them!'));
        }

        return GridView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.all(16.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            childAspectRatio: 0.75,
          ),
          itemCount: encyclopediaController.allPlants.length + (encyclopediaController.hasMorePlants.value ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == encyclopediaController.allPlants.length) {
              return const Center(child: CircularProgressIndicator());
            }

            final plant = encyclopediaController.allPlants[index];
            return InkWell(
              onTap: () {
                Get.bottomSheet(
                  _buildPlantDetailsSheet(plant),
                  backgroundColor: Colors.white,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                );
              },
              child: Card(
                color: const Color(0xFFFCFDFC),
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
                        plant.imgUrl ?? 'https://via.placeholder.com/150',
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

  Widget _buildPlantDetailsSheet(SpeciesModel species) {
    return Container(
      height: Get.height * 0.525,
      padding: const EdgeInsets.all(24.0),
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  species.commonName ?? 'No Common Name',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF046526)),
                ),
                const SizedBox(height: 8),
                Text(
                  species.scientificName,
                  style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: Colors.grey),
                ),
                const Divider(height: 32, thickness: 1),

                _buildDetailRow(Icons.grass, 'Family', species.family ?? 'N/A'),
                const SizedBox(height: 16),
                _buildDetailRow(Icons.forest_outlined, 'Genus', species.genus ?? 'N/A'),
                const SizedBox(height: 16),
                _buildDetailRow(Icons.calendar_today_outlined, 'Year', species.year.toString()),
                const SizedBox(height: 16),
                _buildDetailRow(Icons.description_outlined, 'Bibliography', species.bibliography ?? 'N/A'),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Get.back();
                      Get.to(() => const AddPlantScreen(), arguments: species);
                    },
                    icon: const Icon(Icons.add, color: Colors.white),
                    label: const Text('Add Plant to Library', style: TextStyle(color: Colors.white, fontSize: 16)),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF046526),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.grey),
              iconSize: 32.0,
              splashRadius: 24.0,
              onPressed: () => Get.back(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, color: Colors.grey[600], size: 30),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text(value, style: TextStyle(fontSize: 16, color: Colors.grey[800])),
            ],
          ),
        ),
      ],
    );
  }
}
