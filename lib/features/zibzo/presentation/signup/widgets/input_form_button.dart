import 'package:flutter/material.dart';
import 'package:zibzo/features/zibzo/presentation/signup/widgets/attributes/text_form_button_attributes.dart';

class InputFormButton extends StatelessWidget {
  final TextFormButtonAttributes attributes;
  const InputFormButton({super.key, required this.attributes});
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: attributes.onClick,
        // style: ButtonStyle(
        //   padding: MaterialStateProperty.all<EdgeInsets>(attributes.padding),
        //   minimumSize:
        //       MaterialStateProperty.all<Size?>(attributes.buttonWidthHeight),
        //   backgroundColor: MaterialStateProperty.all<Color>(
        //       attributes.color ?? Theme.of(context).primaryColor),
        //   shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        //     RoundedRectangleBorder(
        //         borderRadius:
        //             BorderRadius.circular(attributes.cornerRadius ?? 12.0)),
        //   ),
        // ),
        style: ElevatedButton.styleFrom(
          backgroundColor: attributes.color,
          padding: attributes.padding,
          minimumSize: attributes.buttonWidthHeight ??
              Size(100, 48), // Default size if null
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(attributes.cornerRadius ?? 12.0),
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
