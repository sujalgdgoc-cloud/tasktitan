import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:task_titan/view/solver/SolverTaskScreen.dart';
import 'package:task_titan/widget/reuseableCard.dart';
import '../../auth/loginScreen.dart';
import '../../controller/theme_controller.dart';
import 'detaiked_fetch_screen.dart';

class SloverDashboard extends StatefulWidget {
  const SloverDashboard({super.key});

  @override
  State<SloverDashboard> createState() => _SloverDashboardState();
}

class _SloverDashboardState extends State<SloverDashboard> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Get.theme.scaffoldBackgroundColor,

      appBar: AppBar(

        backgroundColor: Get.theme.scaffoldBackgroundColor,
        elevation: 0,
        title: Text(
          "Solver Dashboard",
          style: GoogleFonts.dmSans(
            color: Get.textTheme.bodyMedium?.color,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.dark_mode, color: Get.iconColor),
            onPressed: () {
              Get.find<ThemeController>().toggleTheme();
            },
          ),
          IconButton(
            icon: Icon(Icons.task_alt, color: Get.iconColor),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SolverTasksScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.logout, color: Get.iconColor),
            onPressed: () {
              FirebaseAuth.instance.signOut();

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
                    (route) => false,
              );
            },
          ),
        ],
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
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final data =
          snapshot.data!.snapshot.value as Map<dynamic, dynamic>;

          final List requests = data.entries.map((entry) {
            final value = Map<String, dynamic>.from(entry.value);
            value['id'] = entry.key;
            return value;
          }).toList();

          return ListView.builder(

            padding: const EdgeInsets.all(16),

            itemCount: requests.length,

            itemBuilder: (context, index) {

              final request = requests[index];

              final imageUrl = request['imageUrl'] ?? "";
              final title = request['title'] ?? "No Title";
              final description =
                  request['description'] ?? "No description available";
              final status = request['status'] ?? "open";
              String bid = "0";

              if (request['bids'] != null) {
                final bidsMap =
                Map<String, dynamic>.from(request['bids']);

                List<int> bidValues = bidsMap.values
                    .map((e) =>
                int.tryParse(e['bid'].toString()) ?? 999999)
                    .toList();

                bidValues.sort();

                bid = bidValues.first.toString();
              } else {
                bid = request['bid']?.toString() ?? "0";
              }

              return Padding(

                padding: const EdgeInsets.only(bottom: 16),

                child: InkWell(

                  borderRadius: BorderRadius.circular(18),

                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DetailedFetchScreen(request: request),
                      ),
                    );
                  },

                  child: ReusableCard(
                    imageUrl: imageUrl,
                    title: title,
                    description: description,
                    bid: bid,
                    timeStamp: status,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}