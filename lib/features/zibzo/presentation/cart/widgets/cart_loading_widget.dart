import 'package:flutter/material.dart';
import 'package:zibzo/features/zibzo/presentation/widgets/custom_shimmer.dart';

class CartLoadingWidget extends StatelessWidget {
  const CartLoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Column(
            children: const [
              SizedBox(height: 16),
              CustomShimmer(height: 150, width: double.infinity),
              SizedBox(
                height: 20,
              ),
              CustomShimmer(height: 150, width: double.infinity),
              SizedBox(
                height: 20,
              ),
              CustomShimmer(height: 150, width: double.infinity),
              SizedBox(
                height: 20,
              ),
              CustomShimmer(height: 150, width: double.infinity),
              SizedBox(
                height: 20,
              ),
              CustomShimmer(height: 150, width: double.infinity),
              SizedBox(
                height: 20,
              ),
              CustomShimmer(height: 150, width: double.infinity),
            ],
          ),
        ),
      ),
    );
  }
}
