import 'package:flutter/material.dart'
    show
        BorderRadius,
        BorderSide,
        Colors,
        Icon,
        IconButton,
        Icons,
        InputDecoration,
        OutlineInputBorder,
        Radius,
        TextEditingController,
        TextFormField,
        TextSelection,
        TextStyle;

class CustomTextField {
  final String title;
  final String placeholder;
  late final bool ispass;
  String error;
  late TextEditingController controller;
 // late Function(bool) onTogglePassword;

  CustomTextField({
    required this.title,
    required this.placeholder,
    this.ispass = false,
    this.error = '',
   // required this.onTogglePassword,
  }) {
    controller = TextEditingController();
  }

  TextFormField textFormField() {
    return TextFormField(
      controller: controller,
      validator: (e) => e?.isEmpty ?? true ? error : null,
      obscureText: ispass,
      decoration: InputDecoration(
        hintText: placeholder,
        labelText: title,
        labelStyle: const TextStyle(color: Colors.redAccent),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(1)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.redAccent,
          ),
        ),
        /**suffixIcon: IconButton(
    icon: Icon(ispass ? Icons.visibility : Icons.visibility_off),
    onPressed: () {
    onTogglePassword(!ispass); // Appeler la fonction de rappel avec le nouvel état
    },
    ),**/
      ),
    );
  }

  String get value {
    return controller.text;
  }
}
