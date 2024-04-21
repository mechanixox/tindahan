import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:plantdemic/services/my_app_methods.dart';
import 'package:plantdemic/widgets/empty_widget_bag.dart';
import 'package:plantdemic/widgets/products/products_widget.dart';
import 'package:provider/provider.dart';
import 'package:plantdemic/providers/wishlist_provider.dart';
import 'package:plantdemic/services/assets_manager.dart';
//import 'package:plantdemic/widgets/empty_bag.dart';
import 'package:plantdemic/widgets/title_text.dart';

//import '../../services/my_app_functions.dart';
//import '../../widgets/products/product_widget.dart';

class WishlistScreen extends StatelessWidget {
  static const routeName = "/WishlistScreen";
  const WishlistScreen({super.key});
  final bool isEmpty = true;
  @override
  Widget build(BuildContext context) {
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    return wishlistProvider.getWishlistItems.isEmpty
        ? Scaffold(
            body: EmptyBagWidget(
              imagePath: AssetsManager.bagWish,
              title: "Nothing in your wishlist yet",
              subtitle: "Oops! Looks like your wishlist is empty.",
              buttonText: "Shop now",
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: TitlesTextWidget(
                  label:
                      "Wishlist (${wishlistProvider.getWishlistItems.length})"),
              leading: Padding(
                padding: const EdgeInsets.all(8),
                child: Image.asset(AssetsManager.shoppingCart),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    MyAppFunctions.showErrorOrWarningDialog(
                      isError: false,
                      context: context,
                      subtitle: "Remove items?",
                      fct: () {
                        wishlistProvider.clearLocalWishlist();
                      },
                    );
                  },
                  icon: Icon(
                    Icons.delete_forever_rounded,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(15.0),
              child: DynamicHeightGridView(
                itemCount: wishlistProvider.getWishlistItems.length,
                builder: ((context, index) {
                  return ProductWidget(
                    productId: wishlistProvider.getWishlistItems.values
                        .toList()[index]
                        .productId,
                  );
                }),
                crossAxisCount: 2,
              ),
            ),
          );
  }
}
