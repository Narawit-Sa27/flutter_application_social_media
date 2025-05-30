// import 'package:flutter/material.dart';
// import 'package:intl_phone_field/phone_number.dart';
// import 'package:phosphor_flutter/phosphor_flutter.dart';
// import 'package:intl_phone_field/intl_phone_field.dart';

// class PhoneNumberPage extends StatefulWidget {
//   const PhoneNumberPage({super.key});

//   @override
//   PhoneNumberPageState createState() => PhoneNumberPageState();
// }

// class PhoneNumberPageState extends State<PhoneNumberPage> {
//   final _formKey = GlobalKey<FormState>();
//   final phoneNumberController = TextEditingController();

//   void _signIn() async {
//     if (phoneNumberController.text.isNotEmpty &&
//         _formKey.currentState!.validate()) {
//       // ScaffoldMessenger.of(
//       //   context,
//       // ).showSnackBar(const SnackBar(content: Text('Processing Data')));
//       print('Form is valid!');
//       print('Full Phone Number: ${_formKey.currentState}');
//     } else {
//       print('Form is invalid!');
//     }
//     // try {
//     //   final user = await _userService.login(
//     //     _emailController.text,
//     //     _passwordController.text,
//     //   );
//     //   Navigator.push(
//     //     context,
//     //     MaterialPageRoute(builder: (context) => HomePage(user: user)),
//     //   );
//     // } catch (e) {
//     //   print(e);
//     // }
//   }

//   @override
//   void dispose() {
//     phoneNumberController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//       builder: (context, viewportConstraints) {
//         return Scaffold(
//           backgroundColor: const Color(0xFFFFFFFF),
//           body: SafeArea(
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 24),
//               child: Center(
//                 child: SingleChildScrollView(
//                   child: ConstrainedBox(
//                     constraints: BoxConstraints(
//                       minHeight: viewportConstraints.maxHeight,
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         // ==== 👉 Top content ====
//                         Column(
//                           children: [
//                             const SizedBox(height: 50),
//                             const Text(
//                               'Sign In Now',
//                               style: TextStyle(
//                                 fontSize: 28,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                               textAlign: TextAlign.center,
//                             ),
//                             const SizedBox(height: 10),
//                             const Text(
//                               'Please enter the 4 digit OTP sent to your device.',
//                               style: TextStyle(color: Color(0xFF757575)),
//                               textAlign: TextAlign.center,
//                             ),
//                             const SizedBox(height: 50),

//                             // ==== 📥 Form input Phone number ====
//                             Form(
//                               key: _formKey,
//                               autovalidateMode:
//                                   AutovalidateMode.onUserInteraction,
//                               child: Column(
//                                 children: [
//                                   Row(
//                                     mainAxisAlignment:
//                                         MainAxisAlignment.spaceAround,
//                                     children: List.generate(4, (index) {
//                                       return buildOtpField(index);
//                                     }),
//                                   ),
//                                   const SizedBox(height: 40),

//                                   // ==== 👆 Tap button send form data ====
//                                   SizedBox(
//                                     width: double.infinity,
//                                     height: 60,
//                                     child: ElevatedButton(
//                                       onPressed: () {
//                                         _signIn();
//                                       },
//                                       style: ElevatedButton.styleFrom(
//                                         backgroundColor: Colors.indigo[600],
//                                         shape: const RoundedRectangleBorder(
//                                           borderRadius: BorderRadius.all(
//                                             Radius.circular(14),
//                                           ),
//                                         ),
//                                       ),
//                                       child: const Text(
//                                         'Save',
//                                         style: TextStyle(color: Colors.white),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

// Widget buildOtpField(int index) {
//   return SizedBox(
//     width: 50,
//     height: 50,
//     child: TextField(
//       controller: _controllers[index],
//       focusNode: _focusNodes[index],
//       keyboardType: TextInputType.number,
//       textAlign: TextAlign.center,
//       maxLength: 1,
//       onChanged: (value) {
//         //This condition ensures that the current TextField is not the last one in the sequence.
//         //The check index < 5 prevents trying to move focus to a non-existent next field.
//         if (value.isNotEmpty && index < 3) {
//           FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
//         }
//         //managing focus in an OTP input field where the user may need to move backward when correcting an entry
//         else if (value.isEmpty && index > 0) {
//           FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
//         }
//       },
//       decoration: InputDecoration(
//         counterText: '',
//         border: OutlineInputBorder(),
//       ),
//     ),
//   );
// }
