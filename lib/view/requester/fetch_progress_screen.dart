import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class FetchProgressScreen extends StatefulWidget {

  final String requestId;

  const FetchProgressScreen({super.key, required this.requestId});

  @override
  State<FetchProgressScreen> createState() => _FetchProgressScreenState();
}

class _FetchProgressScreenState extends State<FetchProgressScreen> {

  Widget progressCard(String progress) {

    IconData icon;
    Color color;
    String label;

    if (progress == "processing") {
      icon = Icons.build_circle;
      color = Get.theme.primaryColor;
      label = "Work in Progress";
    }
    else if (progress == "done") {
      icon = Icons.check_circle;
      color = Get.theme.colorScheme.secondary;
      label = "Task Completed";
    }
    else {
      icon = Icons.hourglass_empty;
      color = Colors.orange;
      label = "Waiting for Solver";
    }

    return Container(

      padding: const EdgeInsets.all(28),

      decoration: BoxDecoration(
        color: Get.theme.cardColor,
        borderRadius: BorderRadius.circular(24),
      ),

      child: Column(

        mainAxisSize: MainAxisSize.min,

        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 42,
            ),
          ),

          const SizedBox(height: 20),

          Text(
            label,
            style: GoogleFonts.dmSans(
              color: Get.textTheme.bodyMedium?.color,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            "Status: $progress",
            style: GoogleFonts.dmSans(
              color: Get.textTheme.bodyMedium?.color
                  ?.withValues(alpha: 0.7),
            ),
          )
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
          "Task Progress",
          style: GoogleFonts.dmSans(
            color: Get.textTheme.bodyMedium?.color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: StreamBuilder(

        stream: FirebaseDatabase.instanceFor(
          app: Firebase.app(),
          databaseURL: "https://tasktitan-4942a-default-rtdb.firebaseio.com/",
        )
            .ref('request/${widget.requestId}/progress')
            .onValue,

        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final event = snapshot.data as DatabaseEvent;
          final progress = (event.snapshot.value ?? "pending").toString();

          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: progressCard(progress),
            ),
          );
        },
      ),
    );
  }
}