import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class FetchRequest {
  final DatabaseReference ref =
  FirebaseDatabase.instanceFor(app: Firebase.app(), databaseURL:"https://tasktitan-4942a-default-rtdb.firebaseio.com/").ref('request');

  Future<List<Map<String, dynamic>>> fetchDataToSolver() async {

    List<Map<String, dynamic>> requestList = [];

    try {

      DataSnapshot snapshot = await ref.get();

      if (snapshot.exists) {

        Map data = snapshot.value as Map;

        data.forEach((key, value) {

          Map<String, dynamic> request =
          Map<String, dynamic>.from(value);

          request['id'] = key;

          requestList.add(request);

        });

      }

    } catch (e) {
      print(e);
    }

    return requestList;
  }

  Future<Map<String, dynamic>?> fetchSingleRequest(String requestId) async {
    try {
      DataSnapshot snapshot = await ref.child(requestId).get();

      if (snapshot.exists) {
        Map<String, dynamic> data =
        Map<String, dynamic>.from(snapshot.value as Map);

        data['id'] = requestId;

        return data;
      }
    } catch (e) {
      print(e);
    }

    return null;
  }
}