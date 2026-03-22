import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../service/biding_system_post.dart';

class DetailedFetchScreen extends StatefulWidget {
  final Map request;

  const DetailedFetchScreen({super.key, required this.request});

  @override
  State<DetailedFetchScreen> createState() => _DetailedFetchScreenState();
}

class _DetailedFetchScreenState extends State<DetailedFetchScreen> {

  final bidController = TextEditingController();

  Future<void> removeBid(String bidId) async {
    await FirebaseDatabase.instanceFor(
      app: Firebase.app(),
      databaseURL: "https://tasktitan-4942a-default-rtdb.firebaseio.com",
    )
        .ref("request/${widget.request['id']}/bids/$bidId")
        .remove();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Bid removed")),
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
          "Request Details",
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
        )
            .ref("request/${widget.request['id']}")
            .onValue,
        builder: (context, snapshot) {

          if (!snapshot.hasData ||
              snapshot.data!.snapshot.value == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final data =
          snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
          String currentBid = "N/A";

          if (data['bids'] != null) {
            final bidsMap = Map<String, dynamic>.from(data['bids']);

            List<int> bidValues = bidsMap.values
                .map((e) => int.tryParse(e['bid'].toString()) ?? 999999)
                .toList();

            bidValues.sort();
            currentBid = bidValues.first.toString();
          } else {
            currentBid = data['bid']?.toString() ?? "N/A";
          }

          String? myBidId;
          final user = FirebaseAuth.instance.currentUser;

          if (data['bids'] != null && user != null) {
            final bidsMap = Map<String, dynamic>.from(data['bids']);

            bidsMap.forEach((key, value) {
              if (value['name'] ==
                  (user.displayName ?? user.email)) {
                myBidId = key;
              }
            });
          }

          bool isClosed = data['status'] == "closed";

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(20),
                  ),
                  child: data['imageUrl'] != null
                      ? Image.network(
                    data['imageUrl'],
                    height: 220,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                      : Container(
                    height: 220,
                    width: double.infinity,
                    color: Get.theme.cardColor,
                    child: Center(
                      child: Icon(
                        Icons.image_not_supported,
                        size: 50,
                        color: Get.iconColor,
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text(
                        data['title'] ?? "No Title",
                        style: GoogleFonts.dmSans(
                          color: Get.textTheme.bodyMedium?.color,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Text(
                        data['description'] ?? "No Description",
                        style: GoogleFonts.dmSans(
                          color: Get.textTheme.bodyMedium?.color
                              ?.withValues(alpha: 0.85),
                          height: 1.4,
                        ),
                      ),

                      const SizedBox(height: 18),

                      Text(
                        "Current Bid: ₹$currentBid",
                        style: GoogleFonts.dmSans(
                          color: Get.theme.primaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 25),

                      if (isClosed)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.red.shade700,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              "This request is closed. No more bids allowed.",
                              style: GoogleFonts.dmSans(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),

                      if (!isClosed) ...[

                        TextField(
                          controller: bidController,
                          keyboardType: TextInputType.number,
                          style: TextStyle(
                            color: Get.textTheme.bodyMedium?.color,
                          ),
                          decoration: InputDecoration(
                            labelText: "Enter your bid",
                            labelStyle: TextStyle(
                              color: Get.textTheme.bodyMedium?.color,
                            ),
                            filled: true,
                            fillColor: Get.theme.cardColor,
                            border: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),

                        const SizedBox(height: 25),

                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Get.theme.primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(14),
                              ),
                            ),
                            onPressed: () async {

                              int currentBidInt =
                                  int.tryParse(currentBid) ?? 999999;

                              int? newBid =
                              int.tryParse(bidController.text);

                              if (newBid == null) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(
                                  const SnackBar(
                                    content:
                                    Text("Enter a valid number"),
                                  ),
                                );
                                return;
                              }

                              if (newBid >= currentBidInt) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        "Bid must be lower than ₹$currentBid"),
                                  ),
                                );
                                return;
                              }

                              await BidingRequest().addBid(
                                requestId: widget.request['id'],
                                name: user?.displayName ??
                                    user!.email!,
                                bid: newBid.toString(),
                              );

                              bidController.clear();

                              ScaffoldMessenger.of(context)
                                  .showSnackBar(
                                const SnackBar(
                                    content: Text("Bid Placed")),
                              );
                            },
                            child: Text(
                              "Place Bid",
                              style: GoogleFonts.dmSans(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),

                        if (myBidId != null) ...[
                          const SizedBox(height: 12),

                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(14),
                                ),
                              ),
                              onPressed: () {
                                removeBid(myBidId!);
                              },
                              child: Text(
                                "Remove My Bid",
                                style: GoogleFonts.dmSans(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ]
                      ]
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}