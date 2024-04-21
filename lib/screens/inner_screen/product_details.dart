import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:plantdemic/providers/cart_provider.dart';
import 'package:plantdemic/providers/products_provider.dart';
import 'package:plantdemic/widgets/app_name_text.dart';
import 'package:plantdemic/widgets/products/heart_btn.dart';
import 'package:plantdemic/widgets/subtitle_text.dart';
import 'package:plantdemic/widgets/title_text.dart';
import 'package:provider/provider.dart';

class ProductDetails extends StatefulWidget {
  static const routeName = "/ProductDetails";
  const ProductDetails({super.key});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final productProvider =
        Provider.of<ProductsProvider>(context, listen: false);
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final getCurrentProduct = productProvider.findByProdId(productId);
    final cartProvider = Provider.of<CartProvider>(context);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: AppNameTextWidget(
            fontSize: 20,
          ),
          leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                  onPressed: () {
                    Navigator.canPop(context) ? Navigator.pop(context) : null;
                  },
                  icon: Icon(
                    Icons.arrow_back_ios,
                    size: 20,
                  ))),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              FancyShimmerImage(
                imageUrl: getCurrentProduct!.productImage,
                height: size.height * 0.38,
                width: double.infinity,
                boxFit: BoxFit.contain,
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Text(
                            getCurrentProduct.productTitle,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        SubtitleTextWidget(
                          label: "${getCurrentProduct.productPrice}\$",
                          color: Colors.blue,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          HeartButtonWidget(
                            productId: getCurrentProduct.productId,
                            colors: Colors.blue.shade400,
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          Expanded(
                            child: SizedBox(
                              height: kBottomNavigationBarHeight - 10,
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  backgroundColor: Colors.lightBlue,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
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
                                          productId:
                                              getCurrentProduct.productId)
                                      ? Icons.check
                                      : Icons.add_shopping_cart_rounded,
                                  color:
                                      Colors.white, // Set icon color to white
                                ),
                                label: Text(
                                  cartProvider.isProductInCart(
                                          productId:
                                              getCurrentProduct.productId)
                                      ? "Already in cart"
                                      : "Add to cart",
                                  style: TextStyle(
                                    color:
                                        Colors.white, // Set text color to white
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TitlesTextWidget(label: "About this item"),
                        SubtitleTextWidget(
                          label: getCurrentProduct.productCategory,
                          fontSize: 15,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    SubtitleTextWidget(
                      label: getCurrentProduct.productDescription,
                      fontSize: 14,
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
