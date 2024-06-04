// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:zibzo_app/features/zibzo/presentation/signup/widgets/attributes/text_input_form_field_attributes.dart';

bool _passwordVisible = false;

class InputTextFormField extends StatefulWidget {
  final InputTextFormFieldAttributes attributes;
  const InputTextFormField({super.key, required this.attributes});

  @override
  State<InputTextFormField> createState() => _InputTextFormFieldState();
}

class _InputTextFormFieldState extends State<InputTextFormField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.attributes.controller,
      obscureText: widget.attributes.isSecureField && !_passwordVisible,
      enableSuggestions: !widget.attributes.isSecureField,
      autocorrect: widget.attributes.autoCorrect,
      validator: widget.attributes.validation,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      enabled: widget.attributes.enable,
      textInputAction: widget.attributes.textInputAction,
      onFieldSubmitted: widget.attributes.onFieldSubmitted,
      decoration: InputDecoration(
        filled: true,
        hintText: widget.attributes.hint,
        hintStyle: TextStyle(
          fontSize: widget.attributes.hintTextSize,
        ),
        contentPadding: widget.attributes.contentPadding,
        suffixIcon: widget.attributes.isSecureField
            ? IconButton(
                icon: Icon(
                  _passwordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.black87,
                ),
                onPressed: () {
                  setState(() {
                    _passwordVisible = !_passwordVisible;
                  });
                },
              )
            : null,
        border: OutlineInputBorder(borderSide: BorderSide.none),
      ),
    );
  }
}
