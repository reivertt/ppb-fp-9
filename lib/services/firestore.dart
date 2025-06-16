import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FireStoreService{
  //get collection reference from firestore
  final CollectionReference plants = FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser?.uid).collection("plants");

  // create log for specific plant
  Future<void> addLogToPlant(String docID, String logTitle, String logDescription, Timestamp logDate) async{

    print("DEBUG firestore.dart now inside addLogToPlant()");

    final addedplant = await plants.doc(docID).collection("care-logs").add({
      'title': logTitle,
      'desc': logDescription,
      'plantdate': logDate,
      'timestamp': Timestamp.now(),
    });

    print("DEBUG firestore.dart Log successfully added!");
    print("DEBUG firestore.dart Log saved at path: ${addedplant.path}");
    print("DEBUG firestore.dart Log ID: ${addedplant.id}");

    return;
  }

  // read logs documents for specific plant documents
  Stream<QuerySnapshot> getLogsStream(String docID){
    final logsStream = plants.doc(docID).collection("care-logs").orderBy('timestamp', descending: false).snapshots();
    return logsStream;
  }

  // edit log document for specific plant document
  Future<void> updateLog(String docID, String docLogID, String newLogTitle, String newLogDescription, Timestamp newLogDate){
    return plants.doc(docID).collection('care-logs').doc(docLogID).update({
      'title': newLogTitle,
      'desc': newLogDescription,
      'plantdate': newLogDate,
      'timestamp': Timestamp.now(),
    });
  }

  // delete log document for specific plant document
  Future<void> deleteLog(String docID, String docLogID){
    return plants.doc(docID).collection('care-logs').doc(docLogID).delete();
  }
}