import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_titan/service/firebaseDatabase_fetch.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';
import '../../service/progress_update_service.dart';

class PostProgressReportScreen extends StatefulWidget {
  final String requestId;

  const PostProgressReportScreen({
    super.key,
    required this.requestId,
  });

  @override
  State<PostProgressReportScreen> createState() =>
      _PostProgressReportScreenState();
}

class _PostProgressReportScreenState
    extends State<PostProgressReportScreen> {
  final FetchRequest fetchRequest = FetchRequest();

  String currentProgress = "pending";
  String title = "";
  String description = "";
  String imageUrl = "";
  String githubLink = "";

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    final data = await fetchRequest.fetchSingleRequest(widget.requestId);
    setState(() {
      currentProgress = data!["progress"] ?? "pending";
      title = data["title"] ?? "No Title";
      description = data["description"] ?? "No Description";
      imageUrl = data["image"] ?? "";
      githubLink = data["gitlink"] ?? "";
    });
  }

  void update(String progress) {
    if (currentProgress == "done") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Task already completed")),
      );
      return;
    }

    if (currentProgress == "processing" &&
        progress == "processing") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Work already started")),
      );
      return;
    }

    ProgressUpdateService().updateProgress(
      requestId: widget.requestId,
      progress: progress,
    );

    setState(() {
      currentProgress = progress;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Progress updated to $progress")),
    );
  }

  Widget progressCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Get.theme.cardColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 26),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.dmSans(
                      color: Get.textTheme.bodyMedium?.color,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.dmSans(
                      color: Get.textTheme.bodyMedium?.color
                          ?.withValues(alpha: 0.7),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios,
                size: 16,
                color: Get.textTheme.bodyMedium?.color)
          ],
        ),
      ),
    );
  }

  Widget taskDetailsCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Get.theme.cardColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (imageUrl.isNotEmpty)
            ClipRRect(
              borderRadius:
              const BorderRadius.vertical(top: Radius.circular(24)),
              child: Image.network(
                imageUrl,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                const SizedBox(height: 180),
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
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  description,
                  style: GoogleFonts.dmSans(
                    color: Get.textTheme.bodyMedium?.color
                        ?.withValues(alpha: 0.7),
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 14),

                InkWell(
                  onTap: () async {
                    if (githubLink.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("No GitHub link provided")),
                      );
                      return;
                    }

                    final uri = Uri.tryParse(githubLink);

                    if (uri == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Invalid URL")),
                      );
                      return;
                    }

                    try {
                      final success = await launchUrl(
                        uri,
                        mode: LaunchMode.externalApplication,
                      );

                      if (!success) {
                        throw "Could not launch";
                      }
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Cannot open link")),
                      );
                    }
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: Get.theme.primaryColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.code,
                            color: Get.theme.primaryColor),
                        const SizedBox(width: 10),
                        Text(
                          "View GitHub Repo",
                          style: GoogleFonts.dmSans(
                            color: Get.theme.primaryColor,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
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
          "Update Progress",
          style: GoogleFonts.dmSans(
            color: Get.textTheme.bodyMedium?.color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: SingleChildScrollView(
          child: Column(
            children: [
              taskDetailsCard(),

              progressCard(
                title: "Start Work",
                subtitle:
                "Mark that you started working on this task",
                icon: Icons.play_arrow,
                color: Get.theme.primaryColor,
                onTap: () => update("processing"),
              ),

              const SizedBox(height: 18),

              progressCard(
                title: "Mark as Completed",
                subtitle: "Confirm the task is finished",
                icon: Icons.check_circle,
                color: Get.theme.colorScheme.secondary,
                onTap: () => update("done"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}