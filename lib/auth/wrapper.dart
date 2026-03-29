import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../view/requester/requestor_dashBoard.dart';
import '../view/solver/slover_dashBoard.dart';
import '../service/auth_service.dart';
import '../view/solver/solverprofilesetupscreen.dart';
import 'loginScreen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService();

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),

      builder: (context, snapshot) {

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (!snapshot.hasData) {
          return const LoginScreen();
        }

        return FutureBuilder<Map<String, dynamic>?>(
          future: authService.getUserData(),
          builder: (context, roleSnapshot) {

            if (!roleSnapshot.hasData) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            final data = roleSnapshot.data!;
            String role = data["role"];
            bool profileCompleted = data["profileCompleted"];

            if (role == "Solver") {
              if (!profileCompleted) {
                return SolverProfileSetupScreen();
              }
              return SloverDashboard();
            } else {
              return RequestorDashboard();
            }
          },
        );
      },
    );
  }
}