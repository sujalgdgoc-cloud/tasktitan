import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';

class BidFetchService {

  final DatabaseReference ref = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL: "https://tasktitan-4942a-default-rtdb.firebaseio.com/",
  ).ref('request');

  Future<List<Map<String, dynamic>>> fetchBids(String requestId) async {

    List<Map<String, dynamic>> bidList = [];

    try {

      DataSnapshot snapshot = await ref
          .child(requestId)
          .child('bids')
          .get();

      if (snapshot.exists) {

        Map data = snapshot.value as Map;

        data.forEach((key, value) {

          Map<String, dynamic> bid =
          Map<String, dynamic>.from(value);

          bid['bidId'] = key;

          bidList.add(bid);
        });

      }

    } catch (e) {
      print(e);
    }

    return bidList;
  }
}