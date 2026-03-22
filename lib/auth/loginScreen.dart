import 'package:flutter/material.dart';
import 'package:get/get_utils/src/get_utils/get_utils.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:task_titan/auth/signInScreen.dart';
import 'package:task_titan/view/requester/requestor_dashBoard.dart';
import 'package:task_titan/view/solver/slover_dashBoard.dart';
import '../service/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

const Color backgroundColor = Color(0xFF0F172A);
const Color primaryColor = Color(0xFF38BDF8);
const Color accentColor = Color(0xFF22C55E);
const Color textColor = Color(0xFFE2E8F0);

class _LoginScreenState extends State<LoginScreen> {

  final AuthService _authService = AuthService();

  final formKey = GlobalKey<FormState>();
  bool isObscure = true;

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  void login() async {

    String? result = await _authService.login(
        email: email.text,
        password: password.text
    );

    if (result == "Solver") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>  SloverDashboard(),
        ),
      );
    }
    else if (result == "Requester") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>  RequestorDashboard(),
        ),
      );
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login failed: $result")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: backgroundColor,

      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [

                const SizedBox(height: 30),

                Center(
                  child: Text(
                    "TaskTitan",
                    style: GoogleFonts.dmSans(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                Center(
                  child: Image.network(
                    "https://cdn-icons-png.flaticon.com/512/1055/1055687.png",
                    height: 170,
                  ),
                ),

                const SizedBox(height: 35),

                Text(
                  "Welcome Back",
                  style: GoogleFonts.dmSans(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  "Login to continue solving tasks",
                  style: GoogleFonts.dmSans(
                    fontSize: 14,
                    color: textColor.withOpacity(0.7),
                  ),
                ),

                const SizedBox(height: 30),

                Container(
                  padding: const EdgeInsets.all(22),

                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(20),
                  ),

                  child: Form(
                    key: formKey,

                    child: Column(
                      children: [

                        TextFormField(
                          controller: email,

                          style: const TextStyle(color: textColor),

                          decoration: InputDecoration(
                            hintText: "Email",
                            hintStyle: TextStyle(
                              color: textColor.withOpacity(0.5),
                            ),

                            prefixIcon: const Icon(
                              Icons.mail_outline,
                              color: primaryColor,
                            ),

                            filled: true,
                            fillColor: const Color(0xFF0F172A),

                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                          ),

                          validator: (value) {
                            if (value!.isEmpty) {
                              return "please enter email";
                            }

                            if (!GetUtils.isEmail(value)) {
                              return "please enter valid email";
                            }

                            return null;
                          },
                        ),

                        const SizedBox(height: 18),

                        TextFormField(
                          controller: password,
                          obscureText: isObscure,

                          style: const TextStyle(color: textColor),

                          decoration: InputDecoration(
                            hintText: "Password",
                            hintStyle: TextStyle(
                              color: textColor.withOpacity(0.5),
                            ),

                            prefixIcon: const Icon(
                              Icons.lock_outline,
                              color: primaryColor,
                            ),

                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  isObscure = !isObscure;
                                });
                              },

                              icon: Icon(
                                isObscure
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: primaryColor,
                              ),
                            ),

                            filled: true,
                            fillColor: const Color(0xFF0F172A),

                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                          ),

                          validator: (value) {
                            if (value!.isEmpty) {
                              return "please enter password";
                            }

                            if (value.length <= 6) {
                              return "password too short";
                            }

                            return null;
                          },
                        ),

                        const SizedBox(height: 12),

                        Align(
                          alignment: Alignment.centerRight,

                          child: TextButton(
                            onPressed: () {},

                            child: Text(
                              "Forgot Password?",
                              style: GoogleFonts.dmSans(
                                color: accentColor,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        SizedBox(
                          width: double.infinity,
                          height: 50,

                          child: ElevatedButton(
                            onPressed: () {

                              if (formKey.currentState!.validate()) {
                                login();
                              }

                            },

                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,

                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),

                            child: Text(
                              "Login",

                              style: GoogleFonts.dmSans(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,

                          children: [

                            Text(
                              "Don't have an account?",

                              style: GoogleFonts.dmSans(
                                color: textColor.withOpacity(0.8),
                              ),
                            ),

                            TextButton(
                              onPressed: () {

                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SignInScreen(),
                                  ),
                                );

                              },

                              child: Text(
                                "Sign Up",

                                style: GoogleFonts.dmSans(
                                  color: accentColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          ],
                        )

                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}