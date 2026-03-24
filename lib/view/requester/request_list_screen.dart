import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../service/firebaseDatabase_fetch.dart';
import 'onGoing_biding.dart';
import 'fetch_progress_screen.dart';

class RequestListScreen extends StatefulWidget {
  const RequestListScreen({super.key});

  @override
  State<RequestListScreen> createState() => _RequestListScreenState();
}

class _RequestListScreenState extends State<RequestListScreen> {

  Widget statusBadge(bool isClosed) {

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: isClosed
            ? Get.theme.colorScheme.secondary
            : Colors.orange,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        isClosed ? "In Progress" : "Open",
        style: GoogleFonts.dmSans(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget requestCard(Map request) {

    bool isClosed = request['status'] == "closed";

    String title = request['title'] ?? "No Title";
    String description = request['description'] ?? "No description";
    String bid = "0";
    String? image = request['imageUrl'];

    if (request['bids'] != null) {
      final bidsMap = Map<String, dynamic>.from(request['bids']);

      List<int> bidValues = bidsMap.values
          .map((e) => int.tryParse(e['bid'].toString()) ?? 999999)
          .toList();

      bidValues.sort();
      bid = bidValues.first.toString();
    } else {
      bid = request['bid']?.toString() ?? "0";
    }

    return InkWell(

      borderRadius: BorderRadius.circular(20),

      onTap: () {
        if (isClosed) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FetchProgressScreen(
                requestId: request['id'],
              ),
            ),
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ViewBidsScreen(
                requestId: request['id'],
              ),
            ),
          );
        }
      },

      child: Container(

        margin: const EdgeInsets.only(bottom: 20),

        decoration: BoxDecoration(
          color: Get.theme.cardColor,
          borderRadius: BorderRadius.circular(20),
        ),

        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            if (image != null)
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                child: Image.network(
                  image,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

            Padding(

              padding: const EdgeInsets.all(18),

              child: Column(

                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    title,
                    style: GoogleFonts.dmSans(
                      color: Get.textTheme.bodyMedium?.color,
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.dmSans(
                      color: Get.textTheme.bodyMedium?.color
                          ?.withValues(alpha: 0.75),
                      height: 1.4,
                    ),
                  ),

                  const SizedBox(height: 14),

                  Row(

                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Get.theme.primaryColor
                              .withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          "₹$bid",
                          style: GoogleFonts.dmSans(
                            color: Get.theme.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      statusBadge(isClosed),

                    ],
                  )
                ],
              ),
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
          "Your Requests",
          style: GoogleFonts.dmSans(
            color: Get.textTheme.bodyMedium?.color,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),

      body: StreamBuilder(
        stream: FirebaseDatabase.instanceFor(
          app: Firebase.app(),
          databaseURL: "https://tasktitan-4942a-default-rtdb.firebaseio.com/",
        )
            .ref('request')
            .onValue,
        builder: (context, snapshot) {
          if (!snapshot.hasData ||
              snapshot.data!.snapshot.value == null) {
            return Center(
              child: Text(
                "No requests yet",
                style: GoogleFonts.dmSans(
                  color: Get.textTheme.bodyMedium?.color
                      ?.withValues(alpha: 0.7),
                  fontSize: 16,
                ),
              ),
            );
          }

          final data =
          snapshot.data!.snapshot.value as Map<dynamic, dynamic>;
          final currentUid = FirebaseAuth.instance.currentUser!.uid;
          final List requests = data.entries.map((entry) {
            final value = Map<String, dynamic>.from(entry.value);
            value['id'] = entry.key;
            return value;
          }).where((req) => req['uid'] == currentUid).toList();

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final request = requests[index];
              return requestCard(request);
            },
          );
        },
      ),
    );
  }
}