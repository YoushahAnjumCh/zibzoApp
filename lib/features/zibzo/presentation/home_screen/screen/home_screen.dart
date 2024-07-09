import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:zibzo_app/features/zibzo/domain/entities/products/products.dart';
import 'package:zibzo_app/features/zibzo/presentation/home_screen/bloc/product_bloc.dart';
import 'package:zibzo_app/features/zibzo/presentation/home_screen/widgets/widgets/home_page_title_text.dart';
import 'package:zibzo_app/features/zibzo/presentation/home_screen/widgets/widgets/rating_bar.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProductFail) {
            EasyLoading.showError(state.errorMessage);
            return Center(child: Text('Failed to load products'));
          } else if (state is ProductLoaded) {
            return _homeScreenView(state.product);
          } else {
            return Center(child: Text('Press button to load products'));
          }
        },
      ),
    );
  }

  Widget _homeScreenView(List<Products> product) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 20),
            GridView.builder(
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 5,
                  crossAxisSpacing: 5,
                  childAspectRatio: 0.9),
              shrinkWrap: true,
              itemCount: product.length,
              itemBuilder: (context, index) {
                final products = product[index];
                return Card(
                  color: Colors.white,
                  child: Column(
                    children: [
                      SizedBox(
                          child: Image.network(
                        products.image,
                        height: 100,
                      )),
                      const SizedBox(
                        height: 9,
                      ),
                      HomePageTitleText(
                        text: products.title,
                        maxLines: 2,
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(
                        height: 9,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          HomePageTitleText(
                            text: '₹${products.price.toStringAsFixed(0)}',
                            style: TextStyle(
                                fontSize: 14, color: Colors.orangeAccent),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Row(
                              children: [
                                AppRatingBar(
                                  rating: products.rating.rate,
                                  count: products.rating.count,
                                ),
                                const SizedBox(
                                  width: 2,
                                ),
                                Text(
                                  products.rating.count.toString(),
                                  style: TextStyle(color: Colors.amber),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
