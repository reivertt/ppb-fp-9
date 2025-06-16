import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:ppb_fp_9/controller/scheduled_tasks_controller.dart';
import 'package:ppb_fp_9/models/plants_model.dart';
import 'package:ppb_fp_9/screens/plants/add_plant.dart';
import 'package:ppb_fp_9/controller/plants_controller.dart';
import 'package:ppb_fp_9/screens/scheduled_tasks/add_scheduled_task.dart';

// Converted to a StatefulWidget to manage the TabController
class PlantDetail extends StatefulWidget {
  final String plantId;
  const PlantDetail({super.key, required this.plantId});

  @override
  State<PlantDetail> createState() => _PlantDetailState();
}

class _PlantDetailState extends State<PlantDetail> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    // You can also fetch data here if needed
    // Get.find<ScheduledTasksController>().fetchTasksForPlant(widget.plantId);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final plantsController = Get.find<PlantsController>();

    void showDeleteConfirmationDialog(PlantsModel plant) {
      Get.defaultDialog(
        title: "Delete Plant",
        middleText: "Are you sure you want to delete '${plant.commonName}'? This action cannot be undone.",
        textConfirm: "Delete",
        textCancel: "Cancel",
        confirmTextColor: Colors.white,
        onConfirm: () {
          plantsController.deletePlant(widget.plantId);
        },
      );
    }

    return Obx(() {
      final plant = plantsController.allPlants.firstWhereOrNull((p) => p.id == widget.plantId);

      if (plant == null) {
        return Scaffold(
          backgroundColor: const Color(0xFFEDFFF1),
          appBar: AppBar(
            title: const Text("Plant Not Found"),
            backgroundColor: const Color(0xFF046526),
            foregroundColor: Colors.white,
          ),
          body: const Center(child: Text("This plant may have been removed.")),
        );
      }

      return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_tabController.index == 0) {
              // Navigate to AddScheduledTaskScreen
              Get.to(() => AddScheduledTaskScreen(plantId: widget.plantId));
              Get.snackbar('Navigate', 'Go to Add Scheduled Task Screen');
            } else {
              // Navigate to AddCareLogScreen
              Get.snackbar('Navigate', 'Go to Add Care Log Screen');
            }
          },
          backgroundColor: const Color(0xFF046526),
          child: const Icon(Icons.add, color: Colors.white),
        ),
        backgroundColor: const Color(0xFFEDFFF1),
        // We use NestedScrollView to coordinate scrolling between the header and the tab content
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                title: Text(plant.commonName),
                backgroundColor: const Color(0xFF046526),
                foregroundColor: Colors.white,
                expandedHeight: 250.0,
                floating: true,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Image.network(
                    plant.imgUrl ??
                        "https://storage.googleapis.com/proudcity/mebanenc/uploads/2021/03/placeholder-image.png",
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(child: Icon(Icons.broken_image, size: 60, color: Colors.white54));
                    },
                  ),
                ),
              ),
              // This sliver contains the plant name and action buttons
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              plant.commonName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                                color: Color(0xFF046526),
                              ),
                            ),
                            if (plant.customName != null && plant.customName!.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Text(
                                  '"${plant.customName!}"',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            color: const Color(0xFF046526),
                            onPressed: () => Get.to(() => AddPlantScreen(plant: plant)),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline),
                            color: Colors.red.shade700,
                            onPressed: () => showDeleteConfirmationDialog(plant),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // This makes the TabBar stick to the top when you scroll
              SliverPersistentHeader(
                delegate: _SliverAppBarDelegate(
                  TabBar(
                    controller: _tabController,
                    labelColor: const Color(0xFF046526),
                    unselectedLabelColor: Colors.grey,
                    indicatorColor: const Color(0xFF046526),
                    tabs: const [
                      Tab(icon: Icon(Icons.calendar_today), text: "Schedule"),
                      Tab(icon: Icon(Icons.content_paste), text: "Care Log"),
                    ],
                  ),
                ),
                pinned: true,
              ),
            ];
          },
          // The body contains the content for each tab
          body: TabBarView(
            controller: _tabController,
            children: [
              _ScheduledTasksView(plantId: widget.plantId),
              _CareLogView(plantId: widget.plantId),
            ],
          ),
        ),
      );
    });
  }
}

// A custom delegate to make the TabBar work inside a SliverPersistentHeader
class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: const Color(0xFFEDFFF1), // Match the scaffold background
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}


// --- Placeholder Widget for the Scheduled Tasks Tab ---
class _ScheduledTasksView extends StatelessWidget {
  final String plantId;
  const _ScheduledTasksView({required this.plantId});

  @override
  Widget build(BuildContext context) {
    // You can use your ScheduledTasksController here
    final controller = Get.put(ScheduledTasksController());

    // Fetch tasks when this widget is built
    controller.fetchTasksForPlant(plantId);

    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      if (controller.tasksForCurrentPlant.isEmpty) {
        return const Center(
          child: Text(
            "No upcoming tasks scheduled.",
            style: TextStyle(color: Colors.grey),
          ),
        );
      }
      // Build your list of tasks here
      return ListView.builder(
        itemCount: controller.tasksForCurrentPlant.length,
        itemBuilder: (context, index) {
          final task = controller.tasksForCurrentPlant[index];
          return ListTile(
            leading: const Icon(Icons.notifications_active_outlined, color: Color(0xFF046526)),
            title: Text(task.title),
            subtitle: Text('Due: ${DateFormat.yMMMMd().format(task.scheduledAt.toDate())}'),
          );
        },
      );
    });
  }
}

// --- Placeholder Widget for the Care Log Tab ---
class _CareLogView extends StatelessWidget {
  final String plantId;
  const _CareLogView({required this.plantId});

  @override
  Widget build(BuildContext context) {
    // TODO: Implement your Care Log UI here
    return const Center(
      child: Text(
        "Care Log feature coming soon!",
        style: TextStyle(color: Colors.grey),
      ),
    );
  }
}
