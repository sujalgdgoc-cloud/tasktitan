import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import '../../auth/loginScreen.dart';
import '../../controller/pageChanger_controller.dart';
import '../../controller/theme_controller.dart';
import 'request_list_screen.dart';
import 'detailed_post_screen.dart';


class RequestorDashboard extends StatelessWidget {
  RequestorDashboard({super.key});

  final tabController = Get.put(DashboardTabController());

  void _signOut() {
    FirebaseAuth.instance.signOut();
    Get.offAll(() => const LoginScreen());
  }

  final List<Widget> screens = [
    HomeContent(),
    DetailedPostScreen(),
    RequestListScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    Color backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    return Scaffold(
      backgroundColor: backgroundColor,

      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        title: Text(
          "Dashboard",
          style: GoogleFonts.dmSans(
            color:  Get.textTheme.bodyMedium?.color,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Get.theme.colorScheme.secondary),
            onPressed: _signOut,
          ),
          IconButton(
            icon: const Icon(Icons.dark_mode),
            onPressed: () {
              Get.find<ThemeController>().toggleTheme();
            },
          )
        ],
      ),

      body: Obx(() => screens[tabController.selectedIndex.value]),

      bottomNavigationBar: Container(
        color: Get.theme.navigationBarTheme.backgroundColor,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),

        child: Obx(
              () => GNav(
            gap: 8,
            activeColor: Get.theme.navigationBarTheme.indicatorColor,
                color: Get.textTheme.bodyMedium?.color?.withValues(alpha: 0.6),
            iconSize: 24,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            duration: const Duration(milliseconds: 300),
            tabBackgroundColor: Get.theme.primaryColor.withValues(alpha: 0.2),

            selectedIndex: tabController.selectedIndex.value,
            onTabChange: tabController.changeTab,

            tabs: const [
              GButton(icon: Icons.home, text: "Home"),
              GButton(icon: Icons.add_circle_outline, text: "Post"),
              GButton(icon: Icons.list_alt, text: "Requests"),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseDatabase.instanceFor(
        app: Firebase.app(),
        databaseURL: "https://tasktitan-4942a-default-rtdb.firebaseio.com/",
      ).ref('request').onValue,
      builder: (context, snapshot) {
        if (!snapshot.hasData ||
            snapshot.data!.snapshot.value == null ||
            snapshot.data!.snapshot.value is! Map) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = snapshot.data!.snapshot.value as Map<dynamic, dynamic>;

        final requests = data.entries.map((e) {
          final value = Map<String, dynamic>.from(e.value);
          value['id'] = e.key;
          return value;
        }).toList();

        int total = requests.length;
        int inProgress = 0;
        int completed = 0;
        int pending = 0;

        List<Map<String, dynamic>> pendingList = [];

        for (var r in requests) {
          String progress = r['progress'] ?? "pending";

          if (progress == "processing") {
            inProgress++;
          } else if (progress == "done") {
            completed++;
          } else {
            pending++;
            pendingList.add(r);
          }
        }

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  physics: const NeverScrollableScrollPhysics(),

                  children: [
                    statCard("My Tasks", total.toString(), Get.theme.primaryColor, Icons.task_alt),
                    statCard("In Progress", inProgress.toString(), Colors.orange, Icons.autorenew),
                    statCard("Completed", completed.toString(), Colors.purpleAccent, Icons.check_circle),
                    statCard("Pending", pending.toString(), Colors.red, Icons.pending),
                  ],
                ),

                const SizedBox(height: 25),

                Text(
                  "Pending Requests",
                  style: GoogleFonts.dmSans(
                    color: Get.textTheme.bodyMedium?.color,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                if (pendingList.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        "No pending requests ",
                        style: GoogleFonts.dmSans(
                          color: Get.textTheme.bodyMedium?.color?.withValues(alpha: 0.6),
                        ),
                      ),
                    ),
                  )
                else
                  ListView.builder(
                    itemCount: pendingList.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {

                      final req = pendingList[index];

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Get.theme.cardColor,
                          borderRadius: BorderRadius.circular(16),
                        ),

                        child: Row(
                          children: [

                            const Icon(Icons.pending, color: Colors.orange),

                            const SizedBox(width: 12),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  Text(
                                    req['title'] ?? "No Title",
                                    style: GoogleFonts.dmSans(
                                      color: Get.textTheme.bodyMedium?.color,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),

                                  const SizedBox(height: 4),

                                  Text(
                                    "Waiting for bids...",
                                    style: GoogleFonts.dmSans(
                                      color: Get.textTheme.bodyMedium?.color?.withValues(alpha: 0.6),
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget statCard(String title, String count, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Get.theme.cardColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            count,
            style: GoogleFonts.dmSans(
              color: color,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            title,
            style: GoogleFonts.dmSans(
              color: Get.textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}