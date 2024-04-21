import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:plantdemic/models/product_model.dart';
import 'package:plantdemic/providers/products_provider.dart';
import 'package:plantdemic/services/assets_manager.dart';
import 'package:plantdemic/widgets/products/products_widget.dart';
import 'package:plantdemic/widgets/title_text.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = '/SearchScreen';
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController searchTextController;
  List<ProductModel> productListSearch = [];
  @override
  void initState() {
    searchTextController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductsProvider>(context);
    String? passedCategory =
        ModalRoute.of(context)!.settings.arguments as String?;
    final List<ProductModel> productList = passedCategory == null
        ? productProvider.getProducts
        : productProvider.findByCategory(categoryName: passedCategory);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: TitlesTextWidget(label: passedCategory ?? "Search products"),
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset(AssetsManager.shoppingCart),
            ),
          ),
          body: productList.isEmpty
              ? Center(
                  child: Text("No products found"),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: searchTextController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(IconlyLight.search),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(
                                () {
                                  searchTextController.clear();
                                  FocusScope.of(context).unfocus();
                                },
                              );
                            },
                            icon: Icon(
                              IconlyLight.closeSquare,
                              color: Colors.red,
                            ),
                          ),
                        ),
                        onFieldSubmitted: (value) {
                          setState(() {
                            productListSearch = productProvider.searchQuery(
                                searchText: searchTextController.text,
                                passedList: productList);
                          });
                        },
                        onChanged: (value) {
                          setState(() {
                            productListSearch = productProvider.searchQuery(
                                searchText: searchTextController.text,
                                passedList: productList);
                          });
                        },
                      ),
                      if (searchTextController.text.isNotEmpty &&
                          productListSearch.isEmpty) ...[
                        Padding(
                          padding: const EdgeInsets.only(top: 200.0),
                          child: Center(
                            child: Text("No results found"),
                          ),
                        )
                      ],
                      Expanded(
                        child: DynamicHeightGridView(
                          builder: (context, index) {
                            // return ChangeNotifierProvider.value(
                            //   value: productProvider.getProducts[index],
                            //   child: ProductWidget(
                            //       productId: productProvider
                            //           .getProducts[index].productId),
                            // );

                            return ProductWidget(
                              productId: searchTextController.text.isNotEmpty
                                  ? productListSearch[index].productId
                                  : productList[index].productId,
                            );
                          },
                          itemCount: searchTextController.text.isNotEmpty
                              ? productListSearch.length
                              : productList.length,
                          crossAxisCount: 2,
                        ),
                      )
                    ],
                  ),
                )),
    );
  }
}
