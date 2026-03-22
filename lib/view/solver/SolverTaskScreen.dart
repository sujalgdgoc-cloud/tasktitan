import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'post_progress_report_screen.dart';

class SolverTasksScreen extends StatefulWidget {
  const SolverTasksScreen({super.key});

  @override
  State<SolverTasksScreen> createState() => _SolverTasksScreenState();
}

class _SolverTasksScreenState extends State<SolverTasksScreen> {

  Widget progressBadge(String progress) {

    Color color;

    if (progress == "done") {
      color = Get.theme.colorScheme.secondary;
    } else if (progress == "processing") {
      color = Get.theme.primaryColor;
    } else {
      color = Colors.orange;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        progress.toUpperCase(),
        style: GoogleFonts.dmSans(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget taskCard(Map task) {

    String title = task['title'] ?? "No Title";
    String progress = task['progress'] ?? "pending";

    return InkWell(

      borderRadius: BorderRadius.circular(20),

      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PostProgressReportScreen(
              requestId: task['id'],
            ),
          ),
        );
      },

      child: Container(

        margin: const EdgeInsets.only(bottom: 18),

        padding: const EdgeInsets.all(18),

        decoration: BoxDecoration(
          color: Get.theme.cardColor,
          borderRadius: BorderRadius.circular(20),
        ),

        child: Row(
          children: [

            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Get.theme.primaryColor.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.task_alt,
                color: Get.theme.primaryColor,
                size: 24,
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    title,
                    style: GoogleFonts.dmSans(
                      color: Get.textTheme.bodyMedium?.color,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Row(
                    children: [

                      Text(
                        "Status: ",
                        style: GoogleFonts.dmSans(
                          color: Get.textTheme.bodyMedium?.color
                              ?.withValues(alpha: 0.7),
                        ),
                      ),

                      progressBadge(progress),

                    ],
                  )
                ],
              ),
            ),

            Icon(
              Icons.arrow_forward_ios,
              color: Get.textTheme.bodyMedium?.color,
              size: 16,
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
          "My Tasks",
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
            .ref('request')
            .orderByChild('acceptedSolver')
            .equalTo(FirebaseAuth.instance.currentUser!.email)
            .onValue,
        builder: (context, snapshot) {
          if (!snapshot.hasData ||
              snapshot.data!.snapshot.value == null) {
            return Center(
              child: Text(
                "No tasks assigned yet",
                style: GoogleFonts.dmSans(
                  color: Get.textTheme.bodyMedium?.color
                      ?.withValues(alpha: 0.7),
                ),
              ),
            );
          }

          final data =
          snapshot.data!.snapshot.value as Map<dynamic, dynamic>;

          final List tasks = data.entries.map((entry) {
            final value = Map<String, dynamic>.from(entry.value);
            value['id'] = entry.key;
            return value;
          }).toList();

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return taskCard(task);
            },
          );
        },
      ),
    );
  }
}