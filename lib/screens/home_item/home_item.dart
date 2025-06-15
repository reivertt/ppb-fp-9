import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeItem extends StatelessWidget {
  final User? user;
  final VoidCallback onLogout;

  const HomeItem({super.key, this.user, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return Card(
      // Memberi sedikit jarak di luar card
      margin: const EdgeInsets.all(16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 4.0,
      color: Color(0xFFA5DA23),
      child: Padding(
        // Memberi jarak di dalam card agar konten tidak menempel di tepi
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Membuat tinggi card sesuai konten
          children: [
            Row(
              children: [
                // 1. Avatar Pengguna
                const CircleAvatar(
                  radius: 30.0,
                  backgroundImage: AssetImage('assets/Icon.png'),
                  backgroundColor: Colors.transparent,
                ),
                // Spasi antara avatar dan teks
                const SizedBox(width: 16.0),
                // Kolom untuk menata teks secara vertikal
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // Rata kiri
                    children: [
                      // 2. Nama Pengguna
                      const Text(
                        'Nama Pengguna',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      // 3. Jumlah Tanaman
                      const Text(
                        'Jumlah tanaman: 10', // Contoh jumlah
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.white
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            // Spasi antara informasi profil dan tombol logout
            const SizedBox(height: 24.0),
            // 4. Tombol Logout
            SizedBox(
              width: double.infinity, // Membuat tombol selebar card
              child: ElevatedButton.icon(
                onPressed: onLogout,
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
