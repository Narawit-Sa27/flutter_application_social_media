import 'package:flutter/material.dart';
import 'package:flutter_application_socail_media/Pages/login-register/ForgotPasswordPage.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class CustomTextField extends StatefulWidget {
  final String label;
  final String hintText;
  final IconData prefixIcon;
  final bool haveForgotPassword;
  final bool typePassword;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    required this.label,
    required this.hintText,
    required this.prefixIcon,
    this.haveForgotPassword = false,
    this.typePassword = false,
    required this.controller,
    this.validator,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool visibilityOff;

  @override
  void initState() {
    super.initState();
    visibilityOff = widget.typePassword; // ตั้งค่าเริ่มต้น
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.haveForgotPassword
            ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.label,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF757575),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ForgotPasswordPage(),
                      ),
                    );
                  },
                  child: const Text('Forgot Password?'),
                ),
              ],
            )
            : Text(
              widget.label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Color(0xFF757575),
              ),
            ),
        Padding(
          padding:
              widget.haveForgotPassword
                  ? const EdgeInsets.only(top: 0, bottom: 10.0)
                  : const EdgeInsets.symmetric(vertical: 10.0),
          child: TextFormField(
            controller: widget.controller,
            obscureText: widget.typePassword ? visibilityOff : false,
            validator: widget.validator,
            decoration: InputDecoration(
              hintText: widget.hintText,
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 20, right: 10),
                child: Icon(widget.prefixIcon),
              ),
              suffixIcon:
                  widget.typePassword
                      ? Padding(
                        padding: const EdgeInsets.only(left: 6, right: 16),
                        child: IconButton(
                          icon: Icon(
                            visibilityOff
                                ? PhosphorIconsBold.eyeSlash
                                : PhosphorIconsBold.eye,
                          ),
                          onPressed:
                              () => setState(
                                () => visibilityOff = !visibilityOff,
                              ),
                        ),
                      )
                      : null,
              isDense: true,        
              contentPadding: const EdgeInsets.all(20.0),
              enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(14)),
                borderSide: BorderSide(color: Color(0xFFD6D6D6)),
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(14)),
                borderSide: BorderSide(color: Colors.indigo, width: 2),
              ),
              errorBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(14)),
                borderSide: BorderSide(color: Colors.red),
              ),
              focusedErrorBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(14)),
                borderSide: BorderSide(color: Colors.red, width: 2),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
