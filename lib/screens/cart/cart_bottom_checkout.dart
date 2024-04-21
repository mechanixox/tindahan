import 'package:flutter/material.dart';
import 'package:plantdemic/providers/cart_provider.dart';
import 'package:plantdemic/providers/products_provider.dart';
import 'package:plantdemic/widgets/subtitle_text.dart';
import 'package:plantdemic/widgets/title_text.dart';
import 'package:provider/provider.dart';

class CartBottomCheckout extends StatelessWidget {
  const CartBottomCheckout({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final productsProvider = Provider.of<ProductsProvider>(context);
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          border: Border(
            top: BorderSide(width: 2, color: Colors.grey.shade300),
          )),
      child: SizedBox(
        height: kBottomNavigationBarHeight + 25,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FittedBox(
                      child: TitlesTextWidget(
                        label:
                            "Total (${cartProvider.getQty()} ${cartProvider.getQty() == 1 ? 'item' : 'items'})",
                        fontSize: 18,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SubtitleTextWidget(
                          label:
                              "${cartProvider.getTotal(productsProvider: productsProvider)} \$",
                          color: Colors.blue,
                          fontSize: 15,
                        ),
                      ],
                    )
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                child: Text(
                  "Checkout",
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
