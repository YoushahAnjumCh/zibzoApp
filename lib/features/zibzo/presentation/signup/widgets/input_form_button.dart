import 'package:flutter/material.dart';
import 'package:zibzo_app/features/zibzo/presentation/signup/widgets/attributes/text_form_button_attributes.dart';

class InputFormButton extends StatelessWidget {
  final TextFormButtonAttributes attributes;
  const InputFormButton({super.key, required this.attributes});
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: attributes.onClick,
        style: ButtonStyle(
          padding: MaterialStateProperty.all<EdgeInsets>(attributes.padding),
          minimumSize:
              MaterialStateProperty.all<Size?>(attributes.buttonWidthHeight),
          backgroundColor: MaterialStateProperty.all<Color>(
              attributes.color ?? Theme.of(context).primaryColor),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(attributes.cornerRadius ?? 12.0)),
          ),
        ),
        child: attributes.titleText != null
            ? Text(
                attributes.titleText!,
                style: TextStyle(color: attributes.titleColor),
              )
            : Container());
  }
}
