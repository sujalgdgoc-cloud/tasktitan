import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:task_titan/view/requester/solverprofilescreen.dart';


class ViewBidsScreen extends StatefulWidget {
  final String requestId;

  const ViewBidsScreen({super.key, required this.requestId});

  @override
  State<ViewBidsScreen> createState() => _ViewBidsScreenState();
}

class _ViewBidsScreenState extends State<ViewBidsScreen> {

  Future<void> deleteBid(String bidId) async {
    await FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL: "https://tasktitan-4942a-default-rtdb.firebaseio.com",
    )
        .ref('request')
        .child(widget.requestId)
        .child('bids')
        .child(bidId)
        .remove();
  }

  Future<void> acceptBid(Map bid) async {

    final db = FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL: "https://tasktitan-4942a-default-rtdb.firebaseio.com",
    );

    final requestRef = db.ref('request').child(widget.requestId);
    final bidsRef = requestRef.child('bids');


    final snapshot = await bidsRef.get();

    if (snapshot.exists) {
      final allBids = Map<String, dynamic>.from(snapshot.value as Map); // super simple version for converting data into Map<dynamic, dynamic>

      for (var entry in allBids.entries) {
        if (entry.key != bid['bidId']) {
          await bidsRef.child(entry.key).remove();
        }
      }
    }

    await requestRef.update({
      "status": "closed",
      "acceptedBid": bid['bidId'],
      "acceptedSolver": bid['name'],
      "progress": "pending",
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Bid accepted, others rejected")),
    );

    Navigator.pop(context);
  }

  Widget bidCard(Map bid) {
    return GestureDetector(
      onTap: () {
        Get.to(() => SolverProfileScreen(uid: bid['uid'], name: bid['name'],));

      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),

        decoration: BoxDecoration(
          color: Get.theme.cardColor,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),

        child: Row(
          children: [

            CircleAvatar(
              radius: 24,
              backgroundColor: Get.theme.primaryColor,
              child: Text(
                bid['name'][0].toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    bid['name'],
                    style: GoogleFonts.dmSans(
                      color: Get.textTheme.bodyMedium?.color,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    "Tap to view profile",
                    style: GoogleFonts.dmSans(
                      fontSize: 12,
                      color: Get.textTheme.bodyMedium?.color
                          ?.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [

                Text(
                  "₹${bid['bid']}",
                  style: GoogleFonts.dmSans(
                    color: Get.theme.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 8),

                Row(
                  children: [

                    InkWell(
                      onTap: () => acceptBid(bid),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Get.theme.colorScheme.secondary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.check, color: Colors.white, size: 18),
                      ),
                    ),

                    const SizedBox(width: 8),

                    InkWell(
                      onTap: () => deleteBid(bid['bidId']),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.close, color: Colors.white, size: 18),
                      ),
                    ),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.theme.scaffoldBackgroundColor,

      appBar: AppBar(
        backgroundColor: Get.theme.scaffoldBackgroundColor,
        elevation: 0,
        title: Text(
          "Bids",
          style: GoogleFonts.dmSans(
            color: Get.textTheme.bodyMedium?.color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: StreamBuilder(
        stream: FirebaseDatabase.instanceFor(
          app: Firebase.app(),
          databaseURL: "https://tasktitan-4942a-default-rtdb.firebaseio.com",
        ).ref('request').child(widget.requestId).child('bids').onValue,

        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
            return const Center(child: Text("No bids yet"));
          }

          final data = snapshot.data!.snapshot.value as Map; //simple for Map<dynamic,dynamic>

          final bids = data.entries.map((e) {

            final value = Map<String, dynamic>.from(e.value);
            value['bidId'] = e.key;
            return value;
          }).toList();

          bids.sort((a, b) => int.parse(a['bid']).compareTo(int.parse(b['bid'])));

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: bids.length,
            itemBuilder: (context, index) {
              return bidCard(bids[index]);
            },
          );
        },
      ),
    );
  }
}