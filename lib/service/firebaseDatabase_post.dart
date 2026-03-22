import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class RequestService {
  final DatabaseReference ref = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL: "https://tasktitan-4942a-default-rtdb.firebaseio.com/",
  ).ref('request');

  Future<String?> getDataFromUser({
    required String title,
    required String description,
    required String url,
    required String gitlink,
    required String status,
    required String bid,
  }) async {
    try {
      final newRequest = ref.push();

      await newRequest.set({
        "title": title,
        "description": description,
        "imageUrl": url,
        "gitlink": gitlink,
        "timestamp": DateTime.now().toString(),
        "status": status,
        "bid": bid,
      });

      return newRequest.key;
    } catch (e) {
      print("Error uploading request: $e");
      return null;
    }
  }

  Future<void> updateBid({
    required String requestId,
    required String newBid,
  }) async {
    try {
      await ref.child(requestId).update({"bid": newBid});
    } catch (e) {
      print("Error updating bid: $e");
    }
  }
}
