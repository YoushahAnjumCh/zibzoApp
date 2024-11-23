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
          padding: MaterialStateProperty.resolveWith<EdgeInsets>(
              (Set<MaterialState> states) {
            return attributes.padding;
          }),
          minimumSize: MaterialStateProperty.resolveWith<Size?>(
            (Set<MaterialState> states) {
              return attributes.buttonWidthHeight; // Same value for all states
            },
          ),
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              return attributes.color ??
                  Theme.of(context)
                      .primaryColor; // Default color or theme color
            },
          ),
          shape: MaterialStateProperty.resolveWith<RoundedRectangleBorder>(
            (Set<MaterialState> states) {
              return RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(attributes.cornerRadius ?? 12.0),
              ); // Same shape for all states
            },
          ),
        ),
        child: attributes.titleText != null
            ? Text(
                attributes.titleText!,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(color: Colors.white),
              )
            : Container());
  }
}
