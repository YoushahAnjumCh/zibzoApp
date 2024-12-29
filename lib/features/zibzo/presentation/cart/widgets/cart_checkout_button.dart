import 'package:flutter/material.dart';
import 'package:zibzo_app/core/constant/string_constant.dart';
import 'package:zibzo_app/features/zibzo/presentation/signup/widgets/attributes/text_form_button_attributes.dart';
import 'package:zibzo_app/features/zibzo/presentation/signup/widgets/input_form_button.dart';

class CartCheckoutButton extends StatelessWidget {
  const CartCheckoutButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InputFormButton(
      attributes: TextFormButtonAttributes(
        onClick: () {},
        color: Theme.of(context).colorScheme.primary,
        titleColor: Colors.white,
        buttonWidthHeight: const Size(double.maxFinite, 50),
        titleText: StringConstant.checkout,
        cornerRadius: 8,
      ),
    );
  }
}
