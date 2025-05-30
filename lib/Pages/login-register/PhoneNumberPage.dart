import 'package:flutter/material.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class PhoneNumberPage extends StatefulWidget {
  const PhoneNumberPage({super.key});

  @override
  PhoneNumberPageState createState() => PhoneNumberPageState();
}

class PhoneNumberPageState extends State<PhoneNumberPage> {
  final _formKey = GlobalKey<FormState>();
  final phoneNumberController = TextEditingController();
  late bool _isSubmitted = false;

  void _signIn() async {
    if (phoneNumberController.text.isNotEmpty &&
        _formKey.currentState!.validate()) {
      // ScaffoldMessenger.of(
      //   context,
      // ).showSnackBar(const SnackBar(content: Text('Processing Data')));
      print('Form is valid!');
      print('Full Phone Number: ${_formKey.currentState}');
    } else {
      setState(() {
        _isSubmitted = true;
      });
      print('Form is invalid! $_isSubmitted');
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
    phoneNumberController.dispose();
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
                              'Enter Phone Number',
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

                            // ==== 📥 Form input Phone number ====
                            Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  Theme(
                                    data: Theme.of(context).copyWith(
                                      dialogTheme: DialogTheme(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ), // 👈 Custom round dialog
                                        ),
                                      ),
                                    ),
                                    child: IntlPhoneField(
                                      disableAutoFillHints: true,
                                      controller: phoneNumberController,
                                      keyboardType: TextInputType.phone,
                                      decoration: InputDecoration(
                                        labelText: 'Phone Number',
                                        hintText: '65 158 4321',
                                        contentPadding: const EdgeInsets.all(
                                          20.0,
                                        ),
                                        enabledBorder: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(14),
                                          ),
                                          borderSide: BorderSide(
                                            color: Color(0xFFD6D6D6),
                                          ),
                                        ),
                                        focusedBorder: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(14),
                                          ),
                                          borderSide: BorderSide(
                                            color: Colors.indigo,
                                            width: 2,
                                          ),
                                        ),
                                        errorBorder: const OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(14),
                                          ),
                                          borderSide: BorderSide(
                                            color: Colors.red,
                                          ),
                                        ),
                                        focusedErrorBorder:
                                            const OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(14),
                                              ),
                                              borderSide: BorderSide(
                                                color: Colors.red,
                                                width: 2,
                                              ),
                                            ),
                                      ),
                                      initialCountryCode: 'US',
                                      languageCode: "en",
                                      onChanged: (phone) {
                                        print(phone.completeNumber);
                                      },
                                      autovalidateMode:
                                          _isSubmitted
                                              ? AutovalidateMode.always
                                              : AutovalidateMode.disabled,
                                      validator: (PhoneNumber? phone) {
                                        if (phone == null ||
                                            phone.number.isEmpty) {
                                          return 'Please enter your phone number';
                                        }

                                        if (phone.number.isNotEmpty is String) {
                                          final value = phone.number;
                                          print(value.runtimeType);
                                          return 'Please enter your phone number. No text required.';
                                        }
                                        return null;
                                      },
                                      dropdownIcon: Icon(
                                        PhosphorIconsBold.caretDown,
                                        size: 14.0,
                                      ), // Custom Icon 👈
                                      dropdownIconPosition:
                                          IconPosition
                                              .trailing, // Down Icon position left 👈
                                      flagsButtonPadding: EdgeInsets.only(
                                        left: 10.0, // Custom padding flags 👈
                                      ),
                                      pickerDialogStyle: PickerDialogStyle(
                                        backgroundColor: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 40),

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
                                        'Save',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
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
}
