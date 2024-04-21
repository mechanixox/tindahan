import 'package:flutter/material.dart';
import 'package:plantdemic/models/cart_model.dart';
import 'package:plantdemic/providers/cart_provider.dart';
import 'package:plantdemic/widgets/subtitle_text.dart';
import 'package:provider/provider.dart';

class QuantityBottomSheetWidget extends StatelessWidget {
  final CartModel cartModel;
  const QuantityBottomSheetWidget({super.key, required this.cartModel});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        Container(
          height: 6,
          width: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey,
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Expanded(
          child: ListView.builder(
            itemCount: 30,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: GestureDetector(
                    onTap: () {
                      cartProvider.updateQuantity(
                        productId: cartModel.productId,
                        quantity: index + 1,
                      );
                      Navigator.pop(context);
                    },
                    child: SubtitleTextWidget(label: "${index + 1}")),
              );
            },
          ),
        ),
      ],
    );
  }
}
