import 'package:flutter/material.dart';
import 'package:flutter_application_socail_media/Pages/login-register/SignUpPage.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});
  // visibility_off
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, viewportConstraints) {
        return Scaffold(
          backgroundColor: const Color(0xFFFFFFFF),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Center(
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: viewportConstraints.maxHeight,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // ==== 👉 Top content ====
                        Column(
                          children: [
                            const SizedBox(height: 50),
                            const Text(
                              'Sign In Now',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Please enter your information below in order to login to your account.',
                              style: TextStyle(color: Color(0xFF757575)),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 50),

                            // ==== 📥 input Email & Password ====
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Email Address',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF757575),
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10.0),
                                  child: TextField(
                                    decoration: InputDecoration(
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
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(14),
                                        ),
                                        borderSide: BorderSide(
                                          color: Color(0xFFD6D6D6),
                                          // width: 1.5
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(14),
                                        ),
                                        borderSide: BorderSide(
                                          color: Colors.indigo,
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Password',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF757575),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {},
                                      child: const Text('Forgot Password?'),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: 0,
                                    bottom: 10.0,
                                  ),
                                  child: TextField(
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      hintText: '************',
                                      prefixIcon: const Padding(
                                        padding: EdgeInsets.only(
                                          left: 20,
                                          right: 10,
                                        ),
                                        child: Icon(PhosphorIconsBold.lock),
                                      ),
                                      contentPadding: const EdgeInsets.all(
                                        20.0,
                                      ),
                                      border: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(14),
                                        ),
                                      ),
                                      suffixIcon: Padding(
                                        padding: const EdgeInsets.only(
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
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(14),
                                    ),
                                  ),
                                ),
                                child: const Text(
                                  'Sign In',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),

                        // ==== 👉 Bottom content ====
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Don't have an account?",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF757575),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => const SignUpPage(),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    'Create Now',
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
          ),
        );
      },
    );
  }
}
