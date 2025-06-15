import 'package:get/get.dart';
import 'package:ppb_fp_9/screens/home_item/encyclopedia_item.dart';
import 'package:ppb_fp_9/screens/home_item/home_item.dart';
import 'package:ppb_fp_9/screens/home_item/plants_item.dart';
import 'package:ppb_fp_9/screens/home_item/schedules_item.dart';
import 'package:ppb_fp_9/screens/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// Convert to a StatelessWidget
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Instantiate the controller. Get.put() handles its lifecycle.
    final navController = Get.put(NavigationController());

    void logout() async {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacementNamed(context, 'login');
    }

    List<Widget> pages(User? user) => [
      HomeItem(user: user, onLogout: logout),
      const PlantsItem(),
      const SchedulesItem(),
      const EncyclopediaItem(),
    ];

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final user = snapshot.data;
          final screenPages = pages(user);

          // Safety check untuk memastikan index tidak keluar batas
          if (navController.selectedIndex >= screenPages.length) {
            navController.selectedIndex.value = 0;
          }

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
            body: screenPages[navController.selectedIndex.value],
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
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}

class NavigationController extends GetxController {
  // 1. Make selectedIndex observable by adding .obs
  //    This creates an RxInt (Reactive Integer).
  final RxInt selectedIndex = 0.obs;

  // 2. The changeScreen method now updates the .value of the observable
  void changeScreen(int index) {
    selectedIndex.value = index;
  }
}