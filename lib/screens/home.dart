import 'package:ppb_fp_9/screens/home_item/encyclopedia_item.dart';
import 'package:ppb_fp_9/screens/home_item/home_item.dart';
import 'package:ppb_fp_9/screens/home_item/plants_item.dart';
import 'package:ppb_fp_9/screens/home_item/schedules_item.dart';
import 'package:ppb_fp_9/screens/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void logout(context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, 'login');
  }

  // Daftar tampilan konten per tab
  List<Widget> _pages(User? user) => [
    HomeItem(user: user, onLogout: () => logout(context)),
    PlantsItem(),
    SchedulesItem(),
    EncyclopediaItem(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        final user = snapshot.data;
        final pages = _pages(user);

        // Safety check untuk memastikan index tidak keluar batas
        if (_selectedIndex >= pages.length) {
          _selectedIndex = 0;
        }
        if (snapshot.hasData) {
          return Scaffold(
            backgroundColor: Color(0xFFEDFFF1),
            appBar: AppBar(
              backgroundColor: Color(0xFF046526),
              title: Row(
                children: [
                  Image.asset(
                    'assets/appbar-logo.png',
                    height: 24,
                  ),
                  SizedBox(width: 12,),
                  Text(
                    'Leafy',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ],
              )
            ),
            body: _pages(snapshot.data)[_selectedIndex], // Ganti berdasarkan tab
            bottomNavigationBar: BottomNavigationBar(
              // backgroundColor: Color(0xFFFCFDFC),
              backgroundColor: const Color(0xFF046526),
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
              type: BottomNavigationBarType.fixed,

              // Warna ikon & label saat aktif & tidak aktif
              // selectedItemColor: const Color(0xFF046526),
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.white.withAlpha(150),

              // Style teks
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
                  activeIcon: Icon(Icons.home,),
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
          );
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
