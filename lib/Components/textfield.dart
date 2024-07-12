import 'package:flutter/material.dart';
import 'package:garuda_industries/Components/colors.dart';

class InputField extends StatefulWidget {
  final String hint;
  final IconData icon;
  final TextEditingController controller;
  final bool isTextFieldNumber;
  const InputField({
    Key? key,
    required this.hint,
    required this.icon,
    required this.controller,
    this.isTextFieldNumber = false,
  }) : super(key: key);

  @override
  _InputFieldState createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  bool _passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      margin: EdgeInsets.symmetric(vertical: 6),
      width: size.width * .9,
      height: 55,
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: TextFormField(
          obscureText: widget.icon == Icons.lock && !_passwordVisible,
          controller: widget.controller,
          keyboardType: widget.isTextFieldNumber
              ? TextInputType.number
              : TextInputType.text,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: widget.hint,
            hintStyle: TextStyle(color: secondaryColor),
            icon: Icon(widget.icon, color: secondaryColor),
            suffixIcon: widget.icon == Icons.lock
                ? IconButton(
                    icon: Icon(
                      _passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: _passwordVisible ? secondaryColor : secondaryColor,
                    ),
                    onPressed: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                  )
                : null,
          ),
        ),
      ),
    );
  }
}
