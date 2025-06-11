import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreService{
  //get collection reference from firestore
  final CollectionReference plants = FirebaseFirestore.instance.collection("plants");

  // create log for specific plant
  Future<void> addLogToPlant(String docID, String logTitle, String logDescription, Timestamp logDate){
    return  plants.doc(docID).collection("care-logs").add({
      'title': logTitle,
      'desc': logDescription,
      'plantdate': logDate,
      'timestamp': Timestamp.now(),
    });
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