import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:zibzo/core/constant/assets_path.dart';
import 'package:zibzo/core/constant/string_constant.dart';
import 'package:zibzo/features/zibzo/presentation/category_products/screen/category_products_view.dart';
import 'package:zibzo/features/zibzo/presentation/search/cubit/search_cubit.dart';
import 'package:zibzo/features/zibzo/presentation/search/cubit/search_state.dart';
import 'package:zibzo/features/zibzo/presentation/search/widgets/custom_image_widget.dart';
import 'package:zibzo/features/zibzo/presentation/signup/widgets/attributes/text_input_form_field_attributes.dart';
import 'package:zibzo/features/zibzo/presentation/signup/widgets/text_input_form_field.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  late TextEditingController searchController;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
    context.read<SearchCubit>().resetSearch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading:
            BackButton(color: Colors.black, onPressed: () => context.pop()),
        title: _buildSearchField(),
      ),
      body: BlocBuilder<SearchCubit, SearchState>(
        builder: (context, state) {
          return state is SearchLoading
              ? _buildLoadingWidget()
              : state is SearchLoaded
                  ? _buildSearchResults(state)
                  : state is SearchError
                      ? _buildErrorWidget(state.message)
                      : _buildInitialWidget();
        },
      ),
    );
  }

  Widget _buildSearchField() {
    return InputTextFormField(
        attributes: InputTextFormFieldAttributes(
      suffixIcon: ValueListenableBuilder<TextEditingValue>(
        valueListenable: searchController,
        builder: (context, value, child) {
          return value.text.isNotEmpty
              ? IconButton(
                  onPressed: () {
                    searchController.clear();
                    context.read<SearchCubit>().resetSearch();
                  },
                  icon: Icon(Icons.close),
                )
              : SizedBox();
        },
      ),
      hint: StringConstant.searchProducts,
      onChanged: (query) {
        if (query.length >= 2) {
          context.read<SearchCubit>().search(query);
        } else if (query.isEmpty || query.length == 1) {
          context.read<SearchCubit>().resetSearch();
        }
      },
      controller: searchController,
    ));
  }

  Widget _buildLoadingWidget() {
    return const Center(
      child: CustomImageWidget(
        path: AssetsPath.searchingIcon,
        height: 230,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildSearchResults(SearchLoaded state) {
    if (state.products.isEmpty) {
      return _buildNoResultsWidget();
    }
    return ProductList(products: state.products);
  }

  Widget _buildNoResultsWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomImageWidget(
            path: AssetsPath.notFound,
            height: 230,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 10),
          Text(
            StringConstant.searchNotFound,
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              StringConstant.searchKeywordNotFound,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(String message) {
    return Center(child: Text("Error: $message"));
  }

  Widget _buildInitialWidget() {
    return Center(
      child: Text(
        StringConstant.startTypingSearch,
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(),
      ),
    );
  }
}
