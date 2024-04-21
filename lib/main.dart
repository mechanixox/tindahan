// ignore_for_file: unused_import

import 'package:firebase_core/firebase_core.dart';
import 'package:plantdemic/consts/app_constants.dart';
import 'package:plantdemic/consts/theme_data.dart';
import 'package:plantdemic/providers/cart_provider.dart';
import 'package:plantdemic/providers/products_provider.dart';
import 'package:plantdemic/providers/theme_provider.dart';
//import 'package:plantdemic/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:plantdemic/providers/user_provider.dart';
import 'package:plantdemic/providers/viewed_recently_provider.dart';
import 'package:plantdemic/providers/wishlist_provider.dart';
import 'package:plantdemic/root_screen.dart';
import 'package:plantdemic/screens/auth/forgot_password.dart';
import 'package:plantdemic/screens/auth/login.dart';
import 'package:plantdemic/screens/auth/register.dart';
import 'package:plantdemic/screens/inner_screen/product_details.dart';
import 'package:plantdemic/screens/inner_screen/viewed_recently.dart';
import 'package:plantdemic/screens/inner_screen/wishlist.dart';
import 'package:plantdemic/screens/search_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FirebaseApp>(
        future: Firebase.initializeApp(
            // name: "ecommerce-db",
            options: FirebaseOptions(
          apiKey: AppConstants.apiKey,
          appId: AppConstants.appId,
          messagingSenderId: AppConstants.messagingSenderId,
          projectId: AppConstants.projectId,
          storageBucket: AppConstants.storagebucket,
        )),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const MaterialApp(
                debugShowCheckedModeBanner: false,
                home: Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                ));
          } else if (snapshot.hasError) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                body: Center(
                  child: SelectableText(
                    snapshot.error.toString(),
                  ),
                ),
              ),
            );
          }

          return MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (context) => ThemeProvider(),
              ),
              ChangeNotifierProvider(
                create: (context) => ProductsProvider(),
              ),
              ChangeNotifierProvider(
                create: (context) => CartProvider(),
              ),
              ChangeNotifierProvider(
                create: (context) => WishlistProvider(),
              ),
              ChangeNotifierProvider(
                create: (context) => ViewedRecentlyProvider(),
              ),
              ChangeNotifierProvider(
                create: (context) => UserProvider(),
              ),
            ],
            child: Consumer<ThemeProvider>(
              builder: (context, themeProvider, child) {
                return MaterialApp(
                  title: 'Flutter Demo',
                  theme: Styles.themeData(
                      isDarkTheme: themeProvider.getIsDarkTheme,
                      context: context),
                  home: const RootScreen(),
                  routes: {
                    ProductDetails.routeName: (context) =>
                        const ProductDetails(),
                    WishlistScreen.routeName: (context) =>
                        const WishlistScreen(),
                    ViewedRecentlyScreen.routeName: (context) =>
                        const ViewedRecentlyScreen(),
                    RegisterScreen.routeName: (context) =>
                        const RegisterScreen(),
                    LoginScreen.routeName: (context) => const LoginScreen(),
                    ForgotPasswordScreen.routeName: (context) =>
                        const ForgotPasswordScreen(),
                    RootScreen.routeName: (context) => const RootScreen(),
                    SearchScreen.routeName: (context) => const SearchScreen(),
                  },
                );
              },
            ),
          );
        });
  }
}
