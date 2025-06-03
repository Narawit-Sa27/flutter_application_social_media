import 'package:flutter/material.dart';
import 'package:flutter_application_socail_media/Pages/login-register/SignInPage.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:flutter_application_socail_media/components/TextFieldInput.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();

  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void _signUP() async {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Processing Data')));
    }
    // try {
    //   final user = await _userService.login(
    //     _emailController.text,
    //     _passwordController.text,
    //   );
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(builder: (context) => HomePage(user: user)),
    //   );
    // } catch (e) {
    //   print(e);
    // }
  }

  // Exit page clear value
  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

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
                              'Create your free account in just a few simple steps.',
                              style: TextStyle(color: Color(0xFF757575)),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 30),

                            // ==== 📥 Form input Full Name, Email, Password & Confirm Password ====
                            Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  CustomTextField(
                                    label: 'Full Name',
                                    hintText: 'Jones Smith',
                                    prefixIcon: PhosphorIconsBold.user,
                                    controller: fullNameController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your full name';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 16),

                                  CustomTextField(
                                    label: 'Email Address',
                                    hintText: 'you@example.com',
                                    prefixIcon:
                                        PhosphorIconsBold.envelopeSimple,
                                    controller: emailController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your email';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 16),

                                  CustomTextField(
                                    label: 'Password',
                                    hintText: '********',
                                    prefixIcon: PhosphorIconsBold.lock,
                                    controller: passwordController,
                                    typePassword: true,
                                    validator: (value) {
                                      if (value == null || value.length < 6) {
                                        return 'Password must be at least 6 characters';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 16),

                                  CustomTextField(
                                    label: 'Confirm Password',
                                    hintText: '********',
                                    prefixIcon: PhosphorIconsBold.lock,
                                    controller: confirmPasswordController,
                                    typePassword: true,
                                    validator: (value) {
                                      if (value == null || value.length < 6) {
                                        return 'Password must be at least 6 characters';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 40),

                                  // ==== 👉 Tap button send form data ====
                                  SizedBox(
                                    width: double.infinity,
                                    height: 60,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        _signUP();
                                      },
                                      // ==== 👆 Tap button function ====
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
                                  "Already have an account?",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF757575),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    // Navigator.pushReplacement(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //     builder: (context) => const SignInPage(),
                                    //   ),
                                    // );
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
          ),
        );
      },
    );
  }
}
