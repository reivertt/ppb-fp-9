import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ppb_fp_9/controller/plants_controller.dart';
import '../plant_detail.dart';

class PlantsItem extends StatefulWidget {
  const PlantsItem({super.key});

  @override
  State<PlantsItem> createState() => _PlantsItemState();
}

class _PlantsItemState extends State<PlantsItem> {
  final PlantsController plantsController = Get.put(PlantsController());

  @override
  void initState() {
    super.initState();
    plantsController.fetchAllPlants();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEDFFF1),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Color(0xFF046526),
        child: Icon(Icons.add, color: Colors.white, size: 32),
      ),
      body: Obx(() { // Bungkus dengan Obx agar UI reaktif terhadap perubahan data
        if (plantsController.allPlants.isEmpty) {
          return Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: plantsController.allPlants.length,
          itemBuilder: (context, index) {
            final plant = plantsController.allPlants[index];

            return InkWell(
              onTap: () {
                // 2. NAVIGASI KE HALAMAN DETAIL DENGAN MENGIRIM DATA
                Get.to(() => PlantDetail(
                  plantName: plant.commonName,
                  docID: plant.id!, // Pastikan model Anda punya properti 'id' untuk docID
                ));
              },
              child: Card(
                margin: const EdgeInsets.only(bottom: 16.0),
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Image.network(
                      plant.imgUrl!,
                      height: 150,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(child: Padding(padding: EdgeInsets.all(32.0), child: CircularProgressIndicator()));
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(child: Padding(padding: EdgeInsets.all(32.0), child: Icon(Icons.broken_image, size: 50, color: Colors.grey)));
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        plant.commonName,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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