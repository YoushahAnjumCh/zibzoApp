// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:zibzo_app/features/zibzo/presentation/signup/widgets/attributes/text_input_form_field_attributes.dart';

class InputTextFormField extends StatelessWidget {
  final InputTextFormFieldAttributes attributes;
  const InputTextFormField({super.key, required this.attributes});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: attributes.controller,
      obscureText: attributes.isSecureField &&
          !(attributes.passwordVisibilityNotifier?.passwordVisible ?? false),
      enableSuggestions: !attributes.isSecureField,
      autocorrect: attributes.autoCorrect,
      validator: attributes.validation,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      enabled: attributes.enable,
      textInputAction: attributes.textInputAction,
      onFieldSubmitted: attributes.onFieldSubmitted,
      decoration: InputDecoration(
        filled: true,
        hintText: attributes.hint,
        hintStyle: TextStyle(
          fontSize: attributes.hintTextSize,
        ),
        contentPadding: attributes.contentPadding,
        suffixIcon: attributes.isSecureField
            ? IconButton(
                icon: Icon(
                  attributes.passwordVisibilityNotifier?.passwordVisible ??
                          false
                      ? Icons.visibility
                      : Icons.visibility_off,
                  color: Colors.black87,
                ),
                onPressed: () {
                  attributes.passwordVisibilityNotifier?.changeVisibility();
                },
              )
            : null,
        border: OutlineInputBorder(borderSide: BorderSide.none),
      ),
    );
  }
}
