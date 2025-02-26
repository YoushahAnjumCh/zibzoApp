import 'package:flutter/material.dart';
import 'package:zibzo/features/zibzo/presentation/signup/widgets/attributes/text_input_form_field_attributes.dart';

class InputTextFormField extends StatelessWidget {
  final InputTextFormFieldAttributes attributes;
  const InputTextFormField({super.key, required this.attributes});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: Theme.of(context)
          .textTheme
          .labelMedium
          ?.copyWith(color: Colors.black),
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
        border: InputBorder.none,
        prefixIcon: attributes.prefixIcon,
        hintText: attributes.hint,
        hintStyle: TextStyle(
          color: attributes.hintColor,
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
            : attributes.suffixIcon,
      ),
      onChanged: attributes.onChanged,
    );
  }
}
