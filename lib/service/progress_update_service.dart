import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class ProgressUpdateService {
  final DatabaseReference ref = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL:
    "https://tasktitan-4942a-default-rtdb.firebaseio.com",
  ).ref('request');

  Future<void> updateProgress({
    required String requestId,
    required String progress,
    String? submittedLink,
  }) async {
    Map<String, dynamic> data = {
      "progress": progress,
    };

    if (submittedLink != null && submittedLink.isNotEmpty) {
      data["submittedLink"] = submittedLink;
    }

    await ref.child(requestId).update(data);
  }
}