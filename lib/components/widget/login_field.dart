import 'package:flutter/cupertino.dart';
import 'package:instagrume/import.dart';

class LoginField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool obscureText;
  final Widget? suffixIcon;

  const LoginField({
    super.key,
    required this.hintText,
    required this.controller,
    required this.obscureText,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          keyboardType: TextInputType.emailAddress,
          obscureText: obscureText,
          controller: controller,
          // keyboardType: keyboardtype,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(20.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            hintText: hintText,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: kLightGreyBG),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: kLightGreyBG),
              borderRadius: BorderRadius.circular(10.0),
            ),
            fillColor: kLightGreyBG,
            filled: true,
            hintStyle: const TextStyle(color: Colors.grey, fontSize: 15),
            suffixIcon: Padding(
              padding: EdgeInsets.only(right: 5),
              child: suffixIcon,
            ),
          ),
        ),
      ],
    );
  }
}
