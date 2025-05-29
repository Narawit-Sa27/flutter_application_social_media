import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, viewportConstraints) {
        return Scaffold(
          backgroundColor: const Color(0xFFFFFFFF),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Center(
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: viewportConstraints.maxHeight,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // ==== 👉 Top content ====
                      Column(
                        children: [
                          const SizedBox(height: 50),
                          const Text(
                            'Sign Up',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Please enter your information below in order to login to your account.',
                            style: TextStyle(color: Color(0xFF757575)),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 30),

                          // ==== 📥 input Full Name, Email, Password & Confirm Password ====
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Full Name',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF757575),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 10.0),
                                child: const TextField(
                                  decoration: InputDecoration(
                                    // labelText: 'Full Name',
                                    hintText: 'Full Name',
                                    prefixIcon: Padding(
                                      padding: EdgeInsets.only(
                                        left: 20,
                                        right: 10,
                                      ),
                                      child: Icon(PhosphorIconsBold.user),
                                    ),
                                    contentPadding: EdgeInsets.all(20.0),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(14),
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 16),

                              const Text(
                                'Email Address',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF757575),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 10.0),
                                child: const TextField(
                                  decoration: InputDecoration(
                                    // labelText: 'Email Address',
                                    hintText: 'Email Address',
                                    prefixIcon: Padding(
                                      padding: EdgeInsets.only(
                                        left: 20,
                                        right: 10,
                                      ),
                                      child: Icon(
                                        PhosphorIconsBold.envelopeSimple,
                                      ),
                                    ),
                                    contentPadding: EdgeInsets.all(20.0),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(14),
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 16),

                              const Text(
                                'Password',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF757575),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 10.0),
                                child: TextField(
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    // labelText: 'Password',
                                    hintText: '************',
                                    prefixIcon: Padding(
                                      padding: EdgeInsets.only(
                                        left: 20,
                                        right: 10,
                                      ),
                                      child: const Icon(PhosphorIconsBold.lock),
                                    ),
                                    contentPadding: EdgeInsets.all(20.0),
                                    border: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(14),
                                      ),
                                    ),
                                    suffixIcon: Padding(
                                      padding: EdgeInsets.only(
                                        left: 6,
                                        right: 16,
                                      ),
                                      child: IconButton(
                                        icon: const Icon(
                                          PhosphorIconsBold.eyeSlash,
                                        ),
                                        onPressed:
                                            () {}, // handle toggle visibility
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 16),

                              const Text(
                                'Confirm Password',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF757575),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 10.0),
                                child: TextField(
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    // labelText: 'Confirm Password',
                                    hintText: '************',
                                    prefixIcon: Padding(
                                      padding: EdgeInsets.only(
                                        left: 20,
                                        right: 10,
                                      ),
                                      child: const Icon(PhosphorIconsBold.lock),
                                    ),
                                    contentPadding: EdgeInsets.all(20.0),
                                    border: const OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(14),
                                      ),
                                    ),
                                    suffixIcon: Padding(
                                      padding: EdgeInsets.only(
                                        left: 6,
                                        right: 16,
                                      ),
                                      child: IconButton(
                                        icon: const Icon(
                                          PhosphorIconsBold.eyeSlash,
                                        ),
                                        onPressed:
                                            () {}, // handle toggle visibility
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 40),
                          SizedBox(
                            width: double.infinity,
                            height: 60,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.indigo[600],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(14),
                                  ),
                                ),
                              ),
                              child: const Text(
                                'Sign Up',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                      
                      // ==== 👉 Bottom content ====
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Already have an account?",
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF757575),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  'Sign In',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.indigo,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 36),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
