import 'package:flutter/material.dart';
import 'package:flutter_application_socail_media/Pages/login-register/SignInPage.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:flutter_application_socail_media/components/TextFieldInput.dart';

class ChangePassPage extends StatefulWidget {
  const ChangePassPage({super.key});

  @override
  State<ChangePassPage> createState() => _ChangePassPageState();
}

class _ChangePassPageState extends State<ChangePassPage> {
  final _formKey = GlobalKey<FormState>();

  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void _ChangePass() async {
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
                              'Change Password',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Please enter your current and new password to make changes.',
                              style: TextStyle(color: Color(0xFF757575)),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 30),

                            // ==== 📥 Form input New Password & Confirm New Password ====
                            Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  CustomTextField(
                                    label: 'New Password',
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
                                    label: 'Confirm New Password',
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
                                        _ChangePass();
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
                                        'Change Password',
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
