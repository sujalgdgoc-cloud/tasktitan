import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_titan/view/solver/slover_dashBoard.dart';

import '../../controller/solverprofile_controller.dart';


const Color backgroundColor = Color(0xFF0F172A);
const Color primaryColor = Color(0xFF38BDF8);
const Color textColor = Color(0xFFE2E8F0);

class SolverProfileSetupScreen extends StatefulWidget {
  const SolverProfileSetupScreen({super.key});

  @override
  State<SolverProfileSetupScreen> createState() =>
      _SolverProfileSetupScreenState();
}

class _SolverProfileSetupScreenState
    extends State<SolverProfileSetupScreen> {

  final formKey = GlobalKey<FormState>();

  final bio = TextEditingController();
  final techStack = TextEditingController();
  final experience = TextEditingController();
  final linkedIn = TextEditingController();
  final skills = TextEditingController();

  final controller = Get.put(SolverProfileController());

  void saveProfile() async {
    if (!formKey.currentState!.validate()) return;

    final controller = Get.put(SolverProfileController());

    final uid = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance
        .collection("solver_profiles")
        .doc(uid)
        .set({
      "bio": bio.text,
      "techStack": techStack.text.split(","),
      "experience": experience.text,
      "linkedIn": linkedIn.text,
      "skills": skills.text.split(","),
      "rating": 0,
      "completedTasks": 0,
      "createdAt": DateTime.now().toString(),
    });


    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .update({
      "profileCompleted": true
    });

    controller.stopLoading();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => SloverDashboard(),
      ),
    );
  }

  Widget input({
    required String label,
    required IconData icon,
    required TextEditingController controller,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        style: const TextStyle(color: textColor),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: primaryColor),
          labelText: label,
          labelStyle: const TextStyle(color: textColor),
          filled: true,
          fillColor: const Color(0xFF1E293B),
          contentPadding:
          const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
        ),
        validator: (value) =>
        value == null || value.isEmpty ? "Enter $label" : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,

      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        title: Text(
          "Setup Your Profile",
          style: GoogleFonts.dmSans(
            color: textColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Form(
          key: formKey,

          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(
                  "Tell clients about yourself",
                  style: GoogleFonts.dmSans(
                    color: textColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  "This helps requesters choose you for tasks",
                  style: GoogleFonts.dmSans(
                    color: textColor.withValues(alpha: 0.6),
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 25),

                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [

                      input(
                        label: "Short Bio",
                        icon: Icons.person_outline,
                        controller: bio,
                        maxLines: 3,
                      ),

                      input(
                        label: "Tech Stack",
                        icon: Icons.code,
                        controller: techStack,
                      ),

                      input(
                        label: "Skills",
                        icon: Icons.psychology_outlined,
                        controller: skills,
                      ),

                      input(
                        label: "Experience",
                        icon: Icons.work_outline,
                        controller: experience,
                      ),

                      input(
                        label: "LinkedIn Profile",
                        icon: Icons.link,
                        controller: linkedIn,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                Obx(() => SizedBox(
                  width: double.infinity,
                  height: 55,

                  child: ElevatedButton(
                    onPressed: controller.isLoading.value ? null : saveProfile,

                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 3,
                    ),

                    child: controller.isLoading.value
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                      "Complete Setup",
                      style: GoogleFonts.dmSans(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                )),

                const SizedBox(height: 10),

              ],
            ),
          ),
        ),
      ),
    );
  }
}