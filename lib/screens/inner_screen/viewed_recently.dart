// ignore_for_file: unused_import

import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:plantdemic/providers/viewed_recently_provider.dart';
import 'package:plantdemic/widgets/empty_widget_bag.dart';
import 'package:plantdemic/widgets/products/products_widget.dart';
import 'package:plantdemic/services/assets_manager.dart';
import 'package:plantdemic/widgets/title_text.dart';
import 'package:provider/provider.dart';

class ViewedRecentlyScreen extends StatelessWidget {
  static const routeName = "/ViewedRecentlyScreen";
  const ViewedRecentlyScreen({super.key});
  final bool isEmpty = false;
  @override
  Widget build(BuildContext context) {
    final viewedProdProvider = Provider.of<ViewedRecentlyProvider>(context);

    return viewedProdProvider.getViewedRecentlyItems.isEmpty
        ? Scaffold(
            body: EmptyBagWidget(
              imagePath: AssetsManager.orderBag,
              title: "No viewed products yet",
              subtitle: "Browse some products now.",
              buttonText: "Shop now",
            ),
          )
        : Scaffold(
            appBar: AppBar(
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  AssetsManager.shoppingCart,
                ),
              ),
              title: TitlesTextWidget(
                  label:
                      //(${viewedProdProvider.getViewedProds.length})
                      "Viewed recently (${viewedProdProvider.getViewedRecentlyItems.length})"),
              actions: [
                IconButton(
                  onPressed: () {
                    //  MyAppFunctions.showErrorOrWarningDialog(
                    //   isError: false,
                    //   context: context,
                    //   subtitle: "Clear cart?",
                    //   fct: () {
                    //   viewedProdProvider.clearLocalWishlist();
                    //   },
                    // );
                  },
                  icon: const Icon(
                    Icons.delete_forever_rounded,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Expanded(
                    child: DynamicHeightGridView(
                      builder: (context, index) {
                        return ProductWidget(
                            productId: viewedProdProvider
                                .getViewedRecentlyItems.values
                                .toList()[index]
                                .productId);
                      },
                      itemCount:
                          viewedProdProvider.getViewedRecentlyItems.length,
                      crossAxisCount: 2,
                    ),
                  )
                ],
              ),
            )

            // DynamicHeightGridView(
            //   mainAxisSpacing: 12,
            //   crossAxisSpacing: 12,
            //   builder: (context, index) {
            //     return Padding(
            //       padding: const EdgeInsets.all(8.0),
            //       child: ProductWidget(
            //           productId: viewedProdProvider.getViewedProds.values
            //               .toList()[index]
            //               .productId),
            //     );
            //   },
            //   itemCount: viewedProdProvider.getViewedProds.length,
            //   crossAxisCount: 2,
            // ),
            );
  }
}
