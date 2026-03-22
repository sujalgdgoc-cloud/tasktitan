import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';

class ProgressFetchService {

  final DatabaseReference ref = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL: "https://tasktitan-4942a-default-rtdb.firebaseio.com",
  ).ref('request');

  Future<String> fetchProgress(String requestId) async {

    try {

      final snapshot = await ref
          .child(requestId)
          .child("progress")
          .get();

      if (snapshot.exists) {
        return snapshot.value.toString();
      }

    } catch (e) {
      print(e);
    }

    return "pending";
  }

}