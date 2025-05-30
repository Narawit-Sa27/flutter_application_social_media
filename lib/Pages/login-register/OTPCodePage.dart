import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OtpScreen extends StatefulWidget {
  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _formKey = GlobalKey<FormState>();
  RxString otpErrorMessage = ''.obs;
  //create text editing controllers for all text fields
  List<TextEditingController> _controllers = List.generate(
    4,
    (_) => TextEditingController(),
  );

  void _signIn() async {
    bool allFilled = _controllers.every((c) => c.text.isNotEmpty);
    if (!allFilled) {
      otpErrorMessage.value = 'Please enter a 4-digit OTP.';
    } else {
      otpErrorMessage.value = '';
      final otp = _controllers.map((c) => c.text).join();
      // ส่ง OTP ไปตรวจสอบ backend
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
        // otpErrorMessage.value = 'Incorrect verification code.';
      // }
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Processing Data')));
    }
  }
  // create focus nodes for all controllers
  //Use FocusNode to move focus between text fields when a user enters or deletes a digit.

  List<FocusNode> _focusNodes = List.generate(4, (_) => FocusNode());

  //dispose method is used to clean up resources when a widget is removed from the widget tree permanently
  @override
  void dispose() {
    _controllers.forEach((controller) => controller.dispose());
    _focusNodes.forEach((node) => node.dispose());
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // ==== 👉 Top content ====
                        Column(
                          children: [
                            const SizedBox(height: 50),
                            const Text(
                              'OTP Code',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 10),
                            Column(
                              children: [
                                const Text(
                                  'Please enter the 4 digit OTP sent to your device.',
                                  style: TextStyle(color: Color(0xFF757575)),
                                  textAlign: TextAlign.center,
                                ),
                                const Text(
                                  'We have sent the code verification to +1*****5241',
                                  style: TextStyle(color: Color(0xFF757575)),
                                  textAlign: TextAlign.center,
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text(
                                    'Change phone number?',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.indigo,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 50),

                            // ==== 📥 Form input Phone number ====
                            Form(
                              key: _formKey,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    spacing: 14.0,
                                    children: List.generate(4, (index) {
                                      return buildOtpField(index);
                                    }),
                                  ),
                                  Obx(
                                    () =>
                                        otpErrorMessage.value.isNotEmpty
                                            ? Padding(
                                              padding: const EdgeInsets.only(
                                                top: 8.0,
                                              ),
                                              child: Text(
                                                otpErrorMessage.value,
                                                style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 16.0
                                                ),
                                              ),
                                            )
                                            : SizedBox.shrink(),
                                  ),
                                  const SizedBox(height: 36),

                                  // ==== 👉 Tap button send form data ====
                                  SizedBox(
                                    width: double.infinity,
                                    height: 60,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        _signIn();
                                      },
                                      // ==== 👆 Tap button function ====
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.indigo[600],
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(14),
                                          ),
                                        ),
                                      ),
                                      child: const Text(
                                        'Confirm',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 36),

                                  // ==== 👉 Bottom content ====
                                  Wrap(
                                    direction: Axis.horizontal,
                                    alignment: WrapAlignment.center,
                                    crossAxisAlignment: WrapCrossAlignment.center,
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text(
                                          'Resend',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: Colors.indigo,
                                          ),
                                        ),
                                      ),
                                      Text(
                                        'OTP in 60 seconds.',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFF757575),
                                        ),
                                      ),
                                    ],
                                  ),
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

  Widget buildOtpField(int index) {
    return Expanded(
      child: SizedBox(
        height: 70,
        child: TextFormField(
          controller: _controllers[index],
          focusNode: _focusNodes[index],
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          textAlignVertical: TextAlignVertical.center,
          maxLength: 1,
          onChanged: (value) {
            //This condition ensures that the current TextField is not the last one in the sequence.
            //The check index < 5 prevents trying to move focus to a non-existent next field.
            if (value.isNotEmpty && index < 3) {
              FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
            }
            //managing focus in an OTP input field where the user may need to move backward when correcting an entry
            else if (value.isEmpty && index > 0) {
              FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
            }
          },
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600),
          decoration: InputDecoration(
            isDense: true,
            counterText: '',
            contentPadding: EdgeInsets.symmetric(vertical: 14.0),
            enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(14)),
              borderSide: BorderSide(color: Color(0xFFD6D6D6)),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(14)),
              borderSide: BorderSide(color: Colors.indigo, width: 2),
            ),
          ),
        ),
      ),
    );
  }
}
