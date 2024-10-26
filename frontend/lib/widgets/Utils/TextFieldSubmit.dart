import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

class TextFieldSubmit extends StatefulWidget {
  final submitted;
  final String label;
  final TextEditingController controller;
  final rOnly;

  // final ValueChanged<String> onChanged;

  const TextFieldSubmit({
    super.key,
    this.rOnly,
    required this.controller,
    required this.submitted,
    required this.label,
  });
  @override
  State<TextFieldSubmit> createState() => _TextFieldSubmitState();
}

class _TextFieldSubmitState extends State<TextFieldSubmit> {
  bool _obscure = true;
  String pass = '';
  String cpass = '';

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: widget.label == 'OTP'
          ? TextInputType.number
          : widget.label == 'Email' || widget.label.contains('Password')
              ? TextInputType.emailAddress
              : TextInputType.text,
      readOnly: widget.rOnly == true ? widget.rOnly : false,
      obscureText: widget.label.contains('Password') ? _obscure : false,
      autovalidateMode: widget.submitted
          ? AutovalidateMode.onUserInteraction
          : AutovalidateMode.disabled,
      controller: widget.controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
          border: const OutlineInputBorder(),
          suffixIcon: widget.label.contains('Password')
              ? Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _obscure = !_obscure;
                      });
                    },
                    child: Icon(
                      _obscure ? Icons.visibility : Icons.visibility_off,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                )
              : null,
          labelText: widget.label,
          labelStyle: const TextStyle(color: Colors.white)),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Required field';
        }

        if (widget.label == 'OTP') {
          if (value.isNotEmpty && RegExp(r'^[a-z]+$').hasMatch(value)) {
            return 'Please Enter Valid OTP in digits';
          }
        }
        if (widget.label == 'Email') {
          var isValid = EmailValidator.validate(value);
          if (!isValid && value.isNotEmpty) {
            return 'Invalid Email';
          }
        }

        return null;
      },
    );
  }
}
