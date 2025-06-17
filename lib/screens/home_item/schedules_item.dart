import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';
import 'package:ppb_fp_9/controller/plants_controller.dart';
import 'package:ppb_fp_9/controller/scheduled_tasks_controller.dart';
import 'package:ppb_fp_9/models/plants_model.dart';
import 'package:ppb_fp_9/models/scheduled_tasks_model.dart';

import '../plants/add_scheduled_task.dart';

class SchedulesItem extends StatefulWidget {
  const SchedulesItem({super.key});

  @override
  State<SchedulesItem> createState() => _SchedulesItemScreenState();
}

class _SchedulesItemScreenState extends State<SchedulesItem> {
  final ScheduledTasksController _tasksController = Get.put(ScheduledTasksController());
  final PlantsController _plantsController = Get.find();

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    await Future.wait([
      _tasksController.fetchAllTasksForUser(),
      _plantsController.fetchAllPlants(),
    ]);
  }

  String _formatDateHeader(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final dateToCompare = DateTime(date.year, date.month, date.day);

    if (dateToCompare == today) {
      return 'Today';
    } else if (dateToCompare == tomorrow) {
      return 'Tomorrow';
    } else {
      return DateFormat('EEE, MMM d').format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5FBF6),
      body: Obx(() {
        if (_tasksController.isLoading.value || _plantsController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (_tasksController.allUserTasks.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.calendar_today_outlined, size: 80, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                const Text(
                  'No Scheduled Tasks',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black54),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Pull down to refresh.',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          );
        }

        final plantsMap = {for (var plant in _plantsController.allPlants) plant.id: plant};

        final groupedTasks = groupBy<ScheduledTasksModel, DateTime>(
          _tasksController.allUserTasks,
              (task) => DateTime(
            task.scheduledAt.toDate().year,
            task.scheduledAt.toDate().month,
            task.scheduledAt.toDate().day,
          ),
        );

        // Sort the dates
        final sortedKeys = groupedTasks.keys.toList()..sort((a, b) => b.compareTo(a));

        return RefreshIndicator(
          onRefresh: _fetchData,
          child: ListView.builder(
            itemCount: sortedKeys.length,
            itemBuilder: (context, index) {
              final date = sortedKeys[index];
              final tasksForDay = groupedTasks[date]!;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date Header
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0, top: 16.0, bottom: 8.0),
                      child: Text(
                        _formatDateHeader(date),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF046526),
                        ),
                      ),
                    ),
                    ...tasksForDay.map((task) {
                      final plant = plantsMap[task.plantId];
                      return _TaskCard(task: task, plant: plant);
                    }).toList(),
                  ],
                ),
              );
            },
          ),
        );
      }),
    );
  }
}

class _TaskCard extends StatelessWidget {
  const _TaskCard({required this.task, this.plant});

  final ScheduledTasksModel task;
  final PlantsModel? plant;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.green.shade50,
          backgroundImage: plant?.imgUrl != null ? NetworkImage(plant!.imgUrl!) : null,
          child: plant?.imgUrl == null
              ? const Icon(Icons.grass, color: Color(0xFF046526))
              : null,
        ),
        title: Text(task.title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(
          plant?.commonName ?? 'A plant', // Show plant name if available
          style: TextStyle(color: Colors.grey.shade600),
        ),
        trailing: Text(
          DateFormat.jm().format(task.scheduledAt.toDate()), // Show time, e.g., "9:00 AM"
          style: const TextStyle(fontWeight: FontWeight.w500, color: Color(0xFF046526)),
        ),
        onTap: () => {
          Get.to(() => AddScheduledTaskScreen(
            plantId: task.plantId,
            task: task,
          ))
        },
      ),
    );
  }
}
