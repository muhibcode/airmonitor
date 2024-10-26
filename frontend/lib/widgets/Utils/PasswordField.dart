import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  final submitted;
  final String passLabel;
  final String conPassLabel;
  final TextEditingController passCtrl;
  final TextEditingController conPassCtrl;

  // final ValueChanged<String> onChanged;

  const PasswordField({
    super.key,
    required this.passLabel,
    required this.conPassLabel,
    required this.passCtrl,
    required this.conPassCtrl,
    required this.submitted,
  });
  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          obscureText: _obscure,
          autovalidateMode: widget.submitted
              ? AutovalidateMode.onUserInteraction
              : AutovalidateMode.disabled,
          controller: widget.passCtrl,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
              border: const OutlineInputBorder(),
              suffixIcon: Padding(
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
              ),
              labelText: widget.passLabel,
              labelStyle: const TextStyle(color: Colors.white)),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Required field';
            }

            if (value.length < 8) {
              return 'Password must be at least 8 characters';
            }

            if (value.isNotEmpty &&
                !RegExp(r'[\^$*.\[\]{}()?\-"!@#%&/\,><:;_~`+=' // <-- Notice the escaped symbols
                        "'" // <-- ' is added to the expression
                        ']')
                    .hasMatch(value)) {
              return 'Password must contain at least one special character ';
            }

            return null;
          },
        ),
        const SizedBox(
          height: 15,
        ),
        TextFormField(
          obscureText: _obscure,
          autovalidateMode: widget.submitted
              ? AutovalidateMode.onUserInteraction
              : AutovalidateMode.disabled,
          controller: widget.conPassCtrl,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
              border: const OutlineInputBorder(),
              suffixIcon: Padding(
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
              ),
              labelText: widget.conPassLabel,
              labelStyle: const TextStyle(color: Colors.white)),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Required field';
            }

            if (widget.passCtrl.text != widget.conPassCtrl.text) {
              return 'Password and confirm password do not match';
            }

            return null;
          },
        ),
      ],
    );
  }
}
