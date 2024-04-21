import 'package:flutter/material.dart';
import 'package:plantdemic/models/viewed_recently.dart';
import 'package:uuid/uuid.dart';

class ViewedRecentlyProvider with ChangeNotifier {
  final Map<String, ViewedProdModel> _viewedRecentlyItems = {};
  Map<String, ViewedProdModel> get getViewedRecentlyItems {
    return _viewedRecentlyItems;
  }

  void addProductToHistory({required String productId}) {
    _viewedRecentlyItems.putIfAbsent(
      productId,
      () => ViewedProdModel(
        viewedProdId: const Uuid().v4(),
        productId: productId,
      ),
    );
    notifyListeners();
  }

  void clearLocalWishlist() {
    _viewedRecentlyItems.clear();
    notifyListeners();
  }
}
