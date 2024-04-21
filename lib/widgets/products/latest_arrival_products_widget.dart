// ignore_for_file: unused_import

import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:plantdemic/consts/app_constants.dart';
import 'package:plantdemic/models/product_model.dart';
import 'package:plantdemic/providers/viewed_recently_provider.dart';
import 'package:plantdemic/screens/inner_screen/product_details.dart';
import 'package:plantdemic/widgets/products/heart_btn.dart';
import 'package:plantdemic/widgets/subtitle_text.dart';
import 'package:provider/provider.dart';

class LatestArrivalProductsWidget extends StatelessWidget {
  const LatestArrivalProductsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final productsModel = Provider.of<ProductModel>(context);
    final viewedProvider = Provider.of<ViewedRecentlyProvider>(context);
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: GestureDetector(
        onTap: () async {
          viewedProvider.addProductToHistory(
              productId: productsModel.productId);
          await Navigator.pushNamed(
            context,
            ProductDetails.routeName,
            arguments: productsModel.productId,
          );
        },
        child: SizedBox(
          width: size.width * 0.45,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: FancyShimmerImage(
                  imageUrl: productsModel.productImage,
                  width: size.width * 0.28,
                  height: size.width * 0.28,
                ),
              ),
              SizedBox(
                width: 7,
              ),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      productsModel.productTitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    FittedBox(
                      child: Row(
                        children: [
                          HeartButtonWidget(productId: productsModel.productId),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.add_shopping_cart_rounded,
                              size: 22,
                            ),
                          ),
                        ],
                      ),
                    ),
                    FittedBox(
                      child: SubtitleTextWidget(
                        label: "${productsModel.productPrice}\$",
                        fontSize: 14,
                        color: Colors.blue,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
