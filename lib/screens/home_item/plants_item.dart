import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ppb_fp_9/controller/plants_controller.dart';

class PlantsItem extends StatefulWidget {
  const PlantsItem({super.key});

  @override
  State<PlantsItem> createState() => _PlantsItemState();
}

class _PlantsItemState extends State<PlantsItem> {
  // Find the controller that was already put() by a parent widget or screen
  final PlantsController plantsController = Get.put(PlantsController());

  @override
  void initState() {
    super.initState();
    plantsController.fetchAllPlants();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Center(child: plantsController.allPlants.isEmpty ? Text("No data found.") : Text(plantsController.allPlants[0].commonName)));
  }
}



