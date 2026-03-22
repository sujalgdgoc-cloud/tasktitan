import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../service/not in use/bid_fetching_system.dart';

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
    await FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL: "https://tasktitan-4942a-default-rtdb.firebaseio.com",
    ).ref('request').child(widget.requestId).update({
      "status": "closed",
      "acceptedBid": bid['bidId'],
      "acceptedSolver": bid['name'],
      "progress": "pending",
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Bid has been accepted")),
    );

    Navigator.pop(context);
  }

  Widget bidCard(Map bid) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Get.theme.cardColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: Get.theme.primaryColor,
                child: Text(
                  bid['name'][0].toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bid['name'],
                      style: GoogleFonts.dmSans(
                        color: Get.textTheme.bodyMedium?.color,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      "Bid: ₹${bid['bid']}",
                      style: GoogleFonts.dmSans(
                        color: Get.theme.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),

              InkWell(
                borderRadius: BorderRadius.circular(30),
                onTap: () {
                  acceptBid(bid);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Get.theme.colorScheme.secondary,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 20),
                ),
              ),

              const SizedBox(width: 10),

              InkWell(
                borderRadius: BorderRadius.circular(30),
                onTap: () {
                  deleteBid(bid['bidId']);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: const Icon(Icons.close, color: Colors.white, size: 20),
                ),
              ),
            ],
          ),
        ],
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
            return Center(
              child: Text(
                "No bids yet",
                style: GoogleFonts.dmSans(
                  color: Get.textTheme.bodyMedium?.color
                      ?.withValues(alpha: 0.7),
                ),
              ),
            );
          }

          final data = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;

          final List bids = data.entries.map((entry) {
            final value = Map<String, dynamic>.from(entry.value);
            value['bidId'] = entry.key;
            return value;
          }).toList();

          bids.sort(
                (a, b) => int.parse(a['bid']).compareTo(int.parse(b['bid'])),
          );

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: bids.length,
            itemBuilder: (context, index) {
              final bid = bids[index];
              return bidCard(bid);
            },
          );
        },
      ),
    );
  }
}