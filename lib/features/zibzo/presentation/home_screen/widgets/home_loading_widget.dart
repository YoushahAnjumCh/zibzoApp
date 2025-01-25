import 'package:flutter/material.dart';
import 'package:zibzo/features/zibzo/presentation/widgets/custom_shimmer.dart';

class HomeLoadingWidget extends StatelessWidget {
  const HomeLoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: SizedBox(
                  height: 70,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: 6,
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 10),
                    itemBuilder: (context, index) {
                      return const CustomShimmer(
                        height: 60,
                        width: 60,
                        isCircular: true,
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: 16),
              CustomShimmer(height: 250, width: double.infinity),
              SizedBox(
                height: 20,
              ),
              CustomShimmer(height: 200, width: double.infinity),
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
