import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

class SolverProfileScreen extends StatelessWidget {
  final String uid;
  final String? name;
  const SolverProfileScreen({super.key, required this.uid, required this.name});

  String _format(dynamic value) {
    if (value == null) return "Not provided";
    if (value is List) return value.join(", ");
    return value.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.theme.scaffoldBackgroundColor,

      appBar: AppBar(
        backgroundColor: Get.theme.scaffoldBackgroundColor,
        elevation: 0,
        title: Text(
          "Solver Profile",
          style: GoogleFonts.dmSans(
            color: Get.textTheme.bodyMedium?.color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('solver_profiles')
            .doc(uid)
            .get(),
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(
              child: Text(
                "Profile not found",
                style: GoogleFonts.dmSans(),
              ),
            );
          }

          final data = snapshot.data!.data()!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),

            child: Column(
              children: [


                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),

                  decoration: BoxDecoration(
                    color: Get.theme.cardColor,
                    borderRadius: BorderRadius.circular(20),
                  ),

                  child: Column(
                    children: [

                      CircleAvatar(
                        radius: 45,
                        backgroundColor: Get.theme.primaryColor,
                        child: const Icon(
                          Icons.person,
                          size: 45,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(height: 14),

                      Text(
                        "$name",
                        style: GoogleFonts.dmSans(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Get.textTheme.bodyMedium?.color,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        "Solver",
                        style: GoogleFonts.dmSans(
                          fontSize: 13,
                          color: Get.textTheme.bodyMedium
                              ?.color
                              ?.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                _cardSection(
                  icon: Icons.description,
                  title: "Bio",
                  value: _format(data['bio']),
                ),

                _cardSection(
                  icon: Icons.code,
                  title: "Tech Stack",
                  value: _format(data['techStack']),
                ),

                _cardSection(
                  icon: Icons.work,
                  title: "Experience",
                  value: _format(data['experience']),
                ),
                _cardSection(
                  icon: Icons.link,
                  title: "LinkedIn",
                  value: _format(data['linkedin']),
                  isLink: true,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _cardSection({
    required IconData icon,
    required String title,
    required String value,
    bool isLink = false,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Get.theme.cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Get.theme.primaryColor.withValues(alpha: 0.15),
        ),
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Get.theme.primaryColor.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Get.theme.primaryColor, size: 20),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  title,
                  style: GoogleFonts.dmSans(
                    fontWeight: FontWeight.w600,
                    color: Get.textTheme.bodyMedium?.color,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  value,
                  style: GoogleFonts.dmSans(
                    color: isLink
                        ? Get.theme.primaryColor
                        : Get.textTheme.bodyMedium?.color
                        ?.withValues(alpha: 0.8),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}