import 'package:flutter/material.dart';
import 'package:zibzo/features/zibzo/presentation/signup/widgets/attributes/text_form_button_attributes.dart';
import 'package:zibzo/features/zibzo/presentation/widgets/attributes/custom_text_attributes.dart';
import 'package:zibzo/features/zibzo/presentation/widgets/custom_text.dart';

class InputFormButton extends StatelessWidget {
  final TextFormButtonAttributes attributes;
  const InputFormButton({super.key, required this.attributes});
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: attributes.onClick,
        style: ElevatedButton.styleFrom(
          backgroundColor: attributes.color,
          padding: attributes.padding,
          minimumSize: attributes.buttonWidthHeight ?? Size(100, 48),
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(attributes.cornerRadius ?? 12.0),
          ),
        ),
        child: attributes.titleText != null
            ? CustomText(
                attributes: CustomTextAttributes(
                  title: attributes.titleText!,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              )
            : Container());
  }
}
