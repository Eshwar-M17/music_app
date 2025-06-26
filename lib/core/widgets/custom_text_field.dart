import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final bool isObscure;
  final String hintText;
  final TextEditingController? controller;
  final bool readOnly;
  final Function? onTap;
  const CustomTextField({
    super.key,
    required this.hintText,
    required this.controller,
    this.isObscure = false,
    this.readOnly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: readOnly,
      controller: controller,
      onTap: () {
        if(onTap!=null){
        onTap!();
        }

       
      },
      validator: (value) {
        if (value!.trim().isEmpty) {
          return "$hintText can not be Empty";
        }
        return null;
      },
      obscureText: isObscure,
      decoration: InputDecoration(hintText: hintText),
    );
  }
}
