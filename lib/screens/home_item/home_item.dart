import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeItem extends StatelessWidget {
  final User? user;
  final VoidCallback onLogout;

  const HomeItem({super.key, this.user, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Text('Home - Logged in as ${user?.email ?? "Unknown"}')),
          Center(
            child: OutlinedButton(
              onPressed: onLogout,
              child: const Text('Logout'),
            ),
          ),
        ],
      ),
    );
  }
}
