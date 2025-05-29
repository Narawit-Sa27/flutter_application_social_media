import 'package:flutter/material.dart';

class OtpScreen extends StatefulWidget {
  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  //create text editing controllers for all text fields

  List<TextEditingController> _controllers = List.generate(
    4,
    (_) => TextEditingController(),
  );

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
    return Scaffold(
      appBar: AppBar(title: Text('OTP Screen')),
      body: Column(
        children: [
          SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Enter the 4 digit OTP sent to your device",
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(4, (index) {
                return buildOtpField(index);
              }),
            ),
          ),
          ElevatedButton(
            onPressed: () {},
            child: Text("Submit"),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget buildOtpField(int index) {
    return SizedBox(
      width: 50,
      height: 50,
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
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
        decoration: InputDecoration(
          counterText: '',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
