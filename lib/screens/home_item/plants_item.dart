import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ppb_fp_9/controller/plants_controller.dart';
import '../home.dart';
import '../plant_detail.dart';
import '../plants/add_plant.dart';
import 'encyclopedia_item.dart';

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

  void _showAddPlantDialog(BuildContext context) {
    final navController = Get.find<NavigationController>();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Add a New Plant'),
          backgroundColor: const Color(0xFFEDFFF1),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context);
                navController.changeScreen(3);
              },
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              child: const Text('Add from Encyclopedia', style: TextStyle(fontSize: 16)),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddPlantScreen()),
                );
              },
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              child: const Text('Add Your Own Plant', style: TextStyle(fontSize: 16)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEDFFF1),
      floatingActionButton: FloatingActionButton(
        onPressed: () {_showAddPlantDialog(context);},
        backgroundColor: Color(0xFF046526),
        child: Icon(Icons.add, color: Colors.white, size: 32),
      ),
      body: Obx(() { // Bungkus dengan Obx agar UI reaktif terhadap perubahan data
        if (plantsController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        if (plantsController.allPlants.isEmpty) {
          return Center(child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("No plant data found."),
              SizedBox(height: 8,),
              ElevatedButton(onPressed: () {_showAddPlantDialog(context);}, child: Text("Add Plant", style: TextStyle(color: Colors.white),), style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF046526)))
            ],
          ));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: plantsController.allPlants.length,
          itemBuilder: (context, index) {
            final plant = plantsController.allPlants[index];

            return InkWell(
              onTap: () {
                Get.to(() => PlantDetail(
                  plantId: plantsController.allPlants[index].id!,
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
                      plant.imgUrl.isNull ? "https://storage.googleapis.com/proudcity/mebanenc/uploads/2021/03/placeholder-image.png" : plant.imgUrl!,
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
                        plant.customName.isNull ? plant.commonName : plant.customName!,
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