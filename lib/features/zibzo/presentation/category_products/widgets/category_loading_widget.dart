import 'package:flutter/material.dart';
import 'package:zibzo/features/zibzo/presentation/widgets/custom_shimmer.dart';

class CategoryLoadingWidget extends StatelessWidget {
  const CategoryLoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Column(
            children: const [
              SizedBox(height: 16),
              CustomShimmer(height: 380, width: double.infinity),
              SizedBox(
                height: 20,
              ),
              CustomShimmer(height: 380, width: double.infinity),
              SizedBox(
                height: 20,
              ),
              CustomShimmer(height: 380, width: double.infinity),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
