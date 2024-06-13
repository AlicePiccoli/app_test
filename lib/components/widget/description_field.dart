import 'package:flutter/cupertino.dart';
import 'package:instagrume/import.dart';

class DescriptionField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool obscureText;
  final Widget? suffixIcon;

  const DescriptionField({
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
          keyboardType: TextInputType.text,
          obscureText: obscureText,
          controller: controller,
          maxLines: 10,
          minLines: 6,
          // keyboardType: keyboardtype,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(
              top: 20,
              left: 20,
              right: 20,
              bottom: 20,
            ),
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
