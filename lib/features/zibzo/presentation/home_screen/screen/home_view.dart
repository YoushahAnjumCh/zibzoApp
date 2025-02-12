import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:zibzo/common/provider/cart_count_provider.dart';
import 'package:zibzo/core/constant/string_constant.dart';
import 'package:zibzo/core/routes/app_routes.dart';
import 'package:zibzo/features/zibzo/domain/entities/home/home_response_entity.dart';
import 'package:zibzo/features/zibzo/presentation/home_screen/bloc/product_bloc.dart';
import 'package:zibzo/features/zibzo/presentation/home_screen/cubit/add_cart/add_cart_cubit.dart';
import 'package:zibzo/features/zibzo/presentation/home_screen/widgets/carousel_slider.dart';
import 'package:zibzo/features/zibzo/presentation/home_screen/widgets/category_items.dart';
import 'package:zibzo/features/zibzo/presentation/home_screen/widgets/custom_appbar_widget.dart';
import 'package:zibzo/features/zibzo/presentation/home_screen/widgets/home_loading_widget.dart';
import 'package:zibzo/features/zibzo/presentation/home_screen/widgets/product_card_widget.dart';
import 'package:zibzo/features/zibzo/presentation/home_screen/widgets/section_title.dart';
import 'package:zibzo/features/zibzo/presentation/signup/widgets/attributes/text_input_form_field_attributes.dart';
import 'package:zibzo/features/zibzo/presentation/signup/widgets/text_input_form_field.dart';
import 'package:zibzo/firebase/analytics/firebase_analytics.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    AnalyticsService().logScreensView(
      'home_screen',
      'HomeScreen',
    );

    return Scaffold(
      appBar: CustomAppBar(),
      body: BlocListener<ProductBloc, ProductState>(
        listener: (context, state) {
          if (state is ProductFail) {
            EasyLoading.showError(state.errorMessage);
          }
        },
        child: BlocBuilder<ProductBloc, ProductState>(
          builder: (context, state) {
            if (state is ProductLoading) {
              return const HomeLoadingWidget();
            } else if (state is ProductLoaded) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _fetchCartCountAndStore(
                    context, state.product.cartProductCount);
              });
              return HomeContent(
                product: state.product,
                state: state,
              );
            } else {
              return const Center(child: Text(StringConstant.somethingWrong));
            }
          },
        ),
      ),
    );
  }

  _fetchCartCountAndStore(BuildContext context, int? cartCountAPI) async {
    int cartCount =
        Provider.of<CartCountProvider>(context, listen: false).cartCount;
    if (cartCountAPI != null && cartCountAPI >= cartCount) {
      Provider.of<CartCountProvider>(context, listen: false).saveCartCount(
        cartCountAPI,
      );
      return;
    } else {
      Provider.of<CartCountProvider>(context, listen: false).saveCartCount(
        cartCount,
      );
      return;
    }
  }
}

class HomeContent extends StatefulWidget {
  final HomeResponseEntity product;
  final ProductState state;
  const HomeContent({Key? key, required this.product, required this.state})
      : super(key: key);

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  final TextEditingController searchController = TextEditingController();
  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height,
      ),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            _buildSearchField(context),
            const SizedBox(height: 20),
            _buildOfferListText(context, widget.state),
            const SizedBox(height: 20),
            //Carousel Slider
            Visibility(
              visible: widget.product.homebanner.isNotEmpty,
              child: CarouselImageSlider(homebanner: widget.product.homebanner),
            ),
            const SizedBox(height: 16),
            CategoryItems(category: widget.product.category),

            const SizedBox(height: 10),

            SectionTitle(
              title: StringConstant.ourCollection,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: widget.product.products.length,
              itemBuilder: (context, index) {
                final products = widget.product.products[index];
                return BlocBuilder<AddCartCubit, AddCartState>(
                  builder: (context, state) {
                    return ProductCard(
                      products: products,
                      isLoading:
                          context.read<AddCartCubit>().isLoading(products.id),
                    );
                  },
                );
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _buildOfferListText(BuildContext context, ProductState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            StringConstant.specialOffers,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          GestureDetector(
            onTap: () {
              context.push(
                GoRouterPaths.offerListViewRoute,
                extra: {'product': widget.product, 'state': state},
              );
            },
            child: Text(
              StringConstant.seeAll,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: InputTextFormField(
        attributes: InputTextFormFieldAttributes(
          prefixIcon: Icon(Icons.search,
              color: Theme.of(context).colorScheme.onPrimaryContainer),
          contentPadding: EdgeInsets.all(18),
          controller: searchController,
          hint: StringConstant.search,
          hintColor: Theme.of(context).colorScheme.onPrimaryContainer,
          textInputAction: TextInputAction.next,
        ),
      ),
    );
  }
}
