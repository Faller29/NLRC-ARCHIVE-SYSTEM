import 'package:flutter/material.dart';

class TextFieldWidget extends StatefulWidget {
  final TextEditingController controller;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final VoidCallback? onSuffixPressed;
  final String? Function(String?)? validator;
  final String labelText;
  final bool obscureText;
  final ValueChanged<String>? onFieldSubmitted;
  final int? maxLine;

  const TextFieldWidget({
    Key? key,
    required this.controller,
    required this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixPressed,
    this.validator,
    this.obscureText = false,
    this.onFieldSubmitted,
    this.maxLine,
  }) : super(key: key);

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      maxLines: widget.maxLine,
      obscureText: widget.obscureText,
      decoration: InputDecoration(
        labelText: widget.labelText,
        border: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 50),
        labelStyle: TextStyle(
          fontWeight: FontWeight.bold,
        ),
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.controller.text.isNotEmpty
            ? IconButton(
                icon: widget.suffixIcon ?? Icon(Icons.clear),
                onPressed: widget.onSuffixPressed ??
                    () {
                      setState(() {
                        widget.controller.clear();
                      });
                    },
              )
            : null,
      ),
      onChanged: (_) {
        setState(() {});
      },
      validator: widget.validator,
      onFieldSubmitted: widget.onFieldSubmitted,
    );
  }
}
