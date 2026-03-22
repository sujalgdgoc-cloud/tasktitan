import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class BidingRequest {

  Future<void> addBid({
    required String requestId,
    required String name,
    required String bid,
  }) async {

    final DatabaseReference ref = FirebaseDatabase.instanceFor(app: Firebase.app(), databaseURL: "https://tasktitan-4942a-default-rtdb.firebaseio.com")
        .ref('request')
        .child(requestId)
        .child('bids');

    final newBid = ref.push();

    await newBid.set({
      "name": name,
      "bid": bid
    });
  }
}