import 'package:plantdemic/models/category_models.dart';
import 'package:plantdemic/services/assets_manager.dart';

class AppConstants {
  static String productImageUrl1 =
      "https://i.ibb.co/8r1Ny2n/20-Nike-Air-Force-1-07.png";
  static String productImageUrl2 =
      "https://th.bing.com/th/id/R.cd418e086eea6e39ebb3225202794a07?rik=dPSyhxgvuYQtaQ&riu=http%3a%2f%2fcdn.shopify.com%2fs%2ffiles%2f1%2f1752%2f4567%2fproducts%2fmonstera_10_crescent_white_21bd7c3e-c557-49d0-a757-6daa8e6c4ead_1200x1200.png%3fv%3d1536161889&ehk=p2eQT6rGfH3VdSxiFbGpcHo2orPlxEMNCwR0aplRNzU%3d&risl=&pid=ImgRaw&r=0";

  static List<String> bannersImages = [
    AssetsManager.banner1,
    AssetsManager.banner2
  ];
  static List<CategoriesModel> categoriesList = [
    CategoriesModel(
      id: "Phones",
      images: AssetsManager.mobiles,
      name: "Phones",
    ),
    CategoriesModel(
      id: "Laptops",
      images: AssetsManager.pc,
      name: "Laptops",
    ),
    CategoriesModel(
      id: "Electronics",
      images: AssetsManager.electronics,
      name: "Electronics",
    ),
    CategoriesModel(
      id: "Watches",
      images: AssetsManager.watch,
      name: "Watches",
    ),
    CategoriesModel(
      id: "Clothes",
      images: AssetsManager.fashion,
      name: "Clothes",
    ),
    CategoriesModel(
      id: "Shoes",
      images: AssetsManager.shoes,
      name: "Shoes",
    ),
    CategoriesModel(
      id: "Books",
      images: AssetsManager.book,
      name: "Books",
    ),
    CategoriesModel(
      id: "Cosmetics",
      images: AssetsManager.cosmetics,
      name: "Cosmetics",
    ),
  ];

  static String apiKey = "AIzaSyATdWQWr2brxPvT29TO7UZPNmaezQpDRPQ";
  static String appId = "1:536518632058:android:7a08049dec1742318a11c3";
  static String messagingSenderId = "536518632058";
  static String projectId = "ecommerce-db-6882d";
  static String storagebucket = "gs://ecommerce-db-6882d.appspot.com";
}
  

// import 'package:plantdemic/models/categories_model.dart';

// import '../services/assets_manager.dart';

// class AppConstants {
//   static const String imageUrl =
//       'https://i.ibb.co/8r1Ny2n/20-Nike-Air-Force-1-07.png';

//   static List<String> bannersImages = [
//     AssetsManager.banner1,
//     AssetsManager.banner2
//   ];

//   static List<CategoriesModel> categoriesList = [
//     CategoriesModel(
//       id: "Phones",
//       image: AssetsManager.mobiles,
//       name: "Phones",
//     ),
//     CategoriesModel(
//       id: "Laptops",
//       image: AssetsManager.pc,
//       name: "Laptops",
//     ),
//     CategoriesModel(
//       id: "Electronics",
//       image: AssetsManager.electronics,
//       name: "Electronics",
//     ),
//     CategoriesModel(
//       id: "Watches",
//       image: AssetsManager.watch,
//       name: "Watches",
//     ),
//     CategoriesModel(
//       id: "Clothes",
//       image: AssetsManager.fashion,
//       name: "Clothes",
//     ),
//     CategoriesModel(
//       id: "Shoes",
//       image: AssetsManager.shoes,
//       name: "Shoes",
//     ),
//     CategoriesModel(
//       id: "Books",
//       image: AssetsManager.book,
//       name: "Books",
//     ),
//     CategoriesModel(
//       id: "Cosmetics",
//       image: AssetsManager.cosmetics,
//       name: "Cosmetics",
//     ),
//   ];
// }