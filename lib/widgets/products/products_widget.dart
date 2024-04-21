// ignore_for_file: unused_import, unnecessary_import

import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:plantdemic/models/cart_model.dart';
import 'package:plantdemic/providers/cart_provider.dart';
import 'package:plantdemic/providers/products_provider.dart';
import 'package:plantdemic/screens/inner_screen/product_details.dart';
import 'package:plantdemic/widgets/products/heart_btn.dart';
import 'package:plantdemic/widgets/subtitle_text.dart';
import 'package:plantdemic/widgets/title_text.dart';
import 'package:provider/provider.dart';

class ProductWidget extends StatefulWidget {
  final String productId;
  const ProductWidget({super.key, required this.productId});

  @override
  State<ProductWidget> createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final productProvider = Provider.of<ProductsProvider>(context);
    final getCurrentProduct = productProvider.findByProdId(widget.productId);
    final cartProvider = Provider.of<CartProvider>(context);
    //
    return getCurrentProduct == null
        ? SizedBox.shrink()
        : Padding(
            padding: const EdgeInsets.all(3.0),
            child: GestureDetector(
              onTap: () async {
                await Navigator.pushNamed(
                  context,
                  ProductDetails.routeName,
                  arguments: getCurrentProduct.productId,
                );
              },
              child: Column(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: FancyShimmerImage(
                      imageUrl: getCurrentProduct.productImage,
                      height: size.height * 0.22,
                      width: double.infinity,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        flex: 8,
                        child: TitlesTextWidget(
                          label: getCurrentProduct.productTitle,
                          fontSize: 16,
                        ),
                      ),
                      Flexible(
                        flex: 2,
                        child: HeartButtonWidget(
                          productId: getCurrentProduct.productId,
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color.fromARGB(255, 163, 101, 207),
                        ),
                        child: IconButton(
                          splashColor: Colors.red,
                          splashRadius: 27,
                          onPressed: () {
                            if (cartProvider.isProductInCart(
                                productId: getCurrentProduct.productId)) {
                              return;
                            }
                            cartProvider.addProductToCart(
                                productId: getCurrentProduct.productId);
                          },
                          icon: Icon(
                            cartProvider.isProductInCart(
                                    productId: getCurrentProduct.productId)
                                ? Icons.check
                                : Icons.add_shopping_cart_rounded,
                            size: 15,
                            color: Colors.white, // Optionally set icon color
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      SubtitleTextWidget(
                        label: "${getCurrentProduct.productPrice}\$",
                        fontSize: 15,
                      ),
                    ],
                  )
                ],
              ),
            ));
  }
}
