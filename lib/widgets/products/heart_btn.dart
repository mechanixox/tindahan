import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:plantdemic/providers/wishlist_provider.dart';
import 'package:provider/provider.dart';

class HeartButtonWidget extends StatefulWidget {
  final double size;
  final Color colors;
  final String productId;
  const HeartButtonWidget({
    super.key,
    this.size = 20,
    this.colors = Colors.transparent,
    required this.productId,
  });

  @override
  State<HeartButtonWidget> createState() => _HeartButtonWidgetState();
}

class _HeartButtonWidgetState extends State<HeartButtonWidget> {
  @override
  Widget build(BuildContext context) {
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: widget.colors,
      ),
      child: IconButton(
          style: IconButton.styleFrom(
            shape: CircleBorder(),
          ),
          onPressed: () {
            wishlistProvider.addOrRemoveFromWishlist(
                productId: widget.productId);
          },
          icon: Icon(
            wishlistProvider.isProductInWishlist(productId: widget.productId)
                ? IconlyBold.heart
                : IconlyLight.heart,
            size: widget.size,
            color: wishlistProvider.isProductInWishlist(
                    productId: widget.productId)
                ? Colors.red
                : const Color.fromARGB(255, 5, 56, 133),
          )),
    );
  }
}
