import 'package:get/get.dart';
import 'package:ppb_fp_9/screens/home_item/encyclopedia_item.dart';
import 'package:ppb_fp_9/screens/home_item/home_item.dart';
import 'package:ppb_fp_9/screens/home_item/plants_item.dart';
import 'package:ppb_fp_9/screens/home_item/schedules_item.dart';
import 'package:ppb_fp_9/repository/authentication_repository.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final navController = Get.put(NavigationController());
    final authRepository = Get.find<AuthenticationRepository>();

    List<Widget> pages = [
      HomeItem(onLogout: () => authRepository.logout()),
      const PlantsItem(),
      const SchedulesItem(),
      const EncyclopediaItem(),
    ];

    return Obx(() => Scaffold(
      backgroundColor: const Color(0xFFEDFFF1),
      appBar: AppBar(
        backgroundColor: const Color(0xFF046526),
        title: Row(
          children: [
            Image.asset(
              'assets/appbar-logo.png',
              height: 24,
            ),
            const SizedBox(width: 12),
            const Text(
              'Leafy',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: pages[navController.selectedIndex.value],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF046526),
        currentIndex: navController.selectedIndex.value,
        onTap: navController.changeScreen,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withAlpha(150),
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 12,
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.energy_savings_leaf_outlined),
            activeIcon: Icon(Icons.energy_savings_leaf),
            label: 'Plants',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timer_outlined),
            activeIcon: Icon(Icons.timer),
            label: 'Schedules',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_books_outlined),
            activeIcon: Icon(Icons.library_books),
            label: 'Encyclopedia',
          ),
        ],
      ),
    ));
  }
}

class NavigationController extends GetxController {
  final RxInt selectedIndex = 0.obs;

  void changeScreen(int index) {
    selectedIndex.value = index;
  }
}