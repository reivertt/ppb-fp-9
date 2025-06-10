import 'package:flutter/material.dart';
import 'package:ppb_fp_9/screens/home_item/temp_plant.dart';

class PlantsItem extends StatefulWidget {
  const PlantsItem({super.key});

  @override
  State<PlantsItem> createState() => _PlantsItemState();
}

class _PlantsItemState extends State<PlantsItem> {
  List<Plants> plants = [
    Plants(userId: "user1", commonName: "kedelai", imageUrl: "https://picsum.photos/id/18/200/300"),
    Plants(userId: "user2", commonName: "kacang tanah", imageUrl: "https://picsum.photos/200"),
    Plants(userId: "user2", commonName: "daun bawang", imageUrl: "https://picsum.photos/200"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEDFFF1),
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        backgroundColor: Color(0xFF046526),
        child: Icon(Icons.add, color: Colors.white, size: 32,),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20), // Padding untuk keseluruhan list
        itemCount: plants.length, // sinkron ListView berapa banyak item yang akan dibuat
        itemBuilder: (context, index) {
          // Ambil satu tanaman berdasarkan posisinya (index)
          final plant = plants[index];

          // Kembalikan widget Card untuk tanaman tersebut
          return Card(
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
                  plant.imageUrl,
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
          );
        },
      ),
    );
  }
}
