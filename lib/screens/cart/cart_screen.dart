// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:plantdemic/providers/cart_provider.dart';
import 'package:plantdemic/screens/cart/cart_bottom_checkout.dart';
import 'package:plantdemic/screens/cart/cart_widget.dart';
import 'package:plantdemic/services/assets_manager.dart';
import 'package:plantdemic/services/my_app_methods.dart';
import 'package:plantdemic/widgets/empty_widget_bag.dart';
import 'package:plantdemic/widgets/title_text.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});
  final bool isEmpty = false;

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    return cartProvider.getCartItems.isEmpty
        ? Scaffold(
            body: EmptyBagWidget(
                imagePath: AssetsManager.shoppingCart,
                title: "Oops!",
                subtitle: "Looks like your cart is empty.",
                buttonText: "Shop now"),
          )
        : Scaffold(
            appBar: AppBar(
              actions: [
                IconButton(
                  onPressed: () {
                    MyAppFunctions.showErrorOrWarningDialog(
                        context: context,
                        subtitle: "Remove all items in the cart",
                        isError: false,
                        fct: () {
                          cartProvider.clearLocalCart();
                        });
                  },
                  icon: Icon(
                    IconlyLight.delete,
                    color: Colors.red,
                  ),
                )
              ],
              backgroundColor: Colors.transparent,
              title: TitlesTextWidget(
                  label: "Cart (${cartProvider.getCartItems.length})"),
              leading: Image.asset(AssetsManager.shoppingCart),
            ),
            body: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cartProvider.getCartItems.length,
                    itemBuilder: (context, index) {
                      return ChangeNotifierProvider.value(
                          value: cartProvider.getCartItems.values
                              .toList()
                              .reversed
                              .toList()[index],
                          child: CartWidget());
                    },
                  ),
                ),
              ],
            ),
            bottomSheet: CartBottomCheckout(),
          );
  }
}
