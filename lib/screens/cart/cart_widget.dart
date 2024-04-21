// ignore_for_file: unused_import

import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:plantdemic/consts/app_constants.dart';
import 'package:plantdemic/models/cart_model.dart';
import 'package:plantdemic/providers/cart_provider.dart';
import 'package:plantdemic/providers/products_provider.dart';
import 'package:plantdemic/screens/cart/quantity_bottom_sheet.dart';
import 'package:plantdemic/widgets/subtitle_text.dart';
import 'package:plantdemic/widgets/title_text.dart';
import 'package:provider/provider.dart';

class CartWidget extends StatelessWidget {
  const CartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cartModelProvider = Provider.of<CartModel>(context);
    final productProvider = Provider.of<ProductsProvider>(context);
    final getCurrentProduct =
        productProvider.findByProdId(cartModelProvider.productId);
    Size size = MediaQuery.of(context).size;
    final cartProvider = Provider.of<CartProvider>(context);
    return getCurrentProduct == null
        ? SizedBox.shrink()
        : FittedBox(
            child: IntrinsicWidth(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: FancyShimmerImage(
                        imageUrl: getCurrentProduct.productImage,
                        height: size.height * 0.2,
                        width: size.height * 0.2,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    IntrinsicWidth(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: size.width * 0.7,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 70.0),
                                  child: TitlesTextWidget(
                                    label: getCurrentProduct.productTitle,
                                    maxLines: 1,
                                  ),
                                ),
                              ),
                              Column(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      cartProvider.removeOneItem(
                                          productId:
                                              getCurrentProduct.productId);
                                    },
                                    icon: Icon(
                                      IconlyLight.delete,
                                      color: Colors.red,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      IconlyLight.heart,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                          Row(
                            children: [
                              SubtitleTextWidget(
                                label: "${getCurrentProduct.productPrice}\$",
                                fontSize: 20,
                                color: Colors.blue,
                              ),
                              Spacer(),
                              OutlinedButton.icon(
                                style: OutlinedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    side: BorderSide(
                                      width: 1,
                                      color: Colors.blue,
                                    )),
                                onPressed: () async {
                                  await showModalBottomSheet(
                                    backgroundColor: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(16.0),
                                        topRight: Radius.circular(16),
                                      ),
                                    ),
                                    context: context,
                                    builder: (context) {
                                      return QuantityBottomSheetWidget(
                                        cartModel: cartModelProvider,
                                      );
                                    },
                                  );
                                },
                                icon: Icon(IconlyLight.arrowDown2),
                                label:
                                    Text("Qty: ${cartModelProvider.quantity}"),
                              )
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
  }
}
