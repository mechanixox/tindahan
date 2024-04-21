// ignore_for_file: unused_import, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:plantdemic/models/user_model.dart';
import 'package:plantdemic/providers/theme_provider.dart';
import 'package:plantdemic/providers/user_provider.dart';
import 'package:plantdemic/screens/auth/login.dart';
import 'package:plantdemic/screens/auth/register.dart';
import 'package:plantdemic/screens/inner_screen/viewed_recently.dart';
import 'package:plantdemic/screens/inner_screen/wishlist.dart';
import 'package:plantdemic/screens/loading_manager.dart';
import 'package:plantdemic/services/assets_manager.dart';
import 'package:plantdemic/services/my_app_methods.dart';
import 'package:plantdemic/widgets/app_name_text.dart';
import 'package:plantdemic/widgets/custom_list_tile.dart';
import 'package:plantdemic/widgets/subtitle_text.dart';
import 'package:plantdemic/widgets/title_text.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  bool isLoading = false;
  UserModel? userModel;

  Future<void> fetchUserInfo() async {
    if (user == null) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      userModel = await userProvider.fetchUserInfo();
    } catch (error) {
      await MyAppFunctions.showErrorOrWarningDialog(
        context: context,
        subtitle: "An error has occured. $error",
        fct: () {},
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    fetchUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: AppNameTextWidget(),
          leading: Image.asset(AssetsManager.shoppingCart),
        ),
        body: LoadingManager(
          isLoading: isLoading,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Visibility(
                  visible: user == null ? true : false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: Center(
                        child:
                            SubtitleTextWidget(label: "You must login first!")),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                userModel == null
                    ? const SizedBox.shrink()
                    : Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10.0,
                        ),
                        child: Row(
                          children: [
                            Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Theme.of(context).cardColor,
                                border: Border.all(
                                  color:
                                      Theme.of(context).colorScheme.background,
                                  width: 3,
                                ),
                                image: DecorationImage(
                                  image: NetworkImage(userModel!.userImage),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TitlesTextWidget(label: userModel!.userName),
                                SubtitleTextWidget(label: userModel!.userEmail)
                              ],
                            ),
                          ],
                        ),
                      ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TitlesTextWidget(label: "General"),
                      CustomListTile(
                        imagePath: AssetsManager.orderSvg,
                        text: "All orders",
                        function: () {},
                      ),
                      CustomListTile(
                        imagePath: AssetsManager.wishlistSvg,
                        text: "Wishlist",
                        function: () {
                          Navigator.of(context)
                              .pushNamed(WishlistScreen.routeName);
                        },
                      ),
                      CustomListTile(
                        imagePath: AssetsManager.recent,
                        text: "Viewed recently",
                        function: () {
                          Navigator.of(context)
                              .pushNamed(ViewedRecentlyScreen.routeName);
                        },
                      ),
                      CustomListTile(
                        imagePath: AssetsManager.address,
                        text: "Address",
                        function: () {},
                      ),
                      Divider(
                        thickness: 0.5,
                        color: Color.fromARGB(255, 205, 206, 207),
                      ),
                      TitlesTextWidget(label: "Settings"),
                      SwitchListTile(
                        title: Text(
                            themeProvider.getIsDarkTheme ? "Dark" : "Light"),
                        value: themeProvider.getIsDarkTheme,
                        onChanged: (value) {
                          themeProvider.setDarkTheme(themevalue: value);
                        },
                      ),
                      Divider(
                        thickness: 0.5,
                        color: Color.fromARGB(255, 205, 206, 207),
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 21.0),
                          child: SizedBox(
                            width: 140.0, // Adjust width as needed
                            height: 50.0, // Adjust height as needed
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  backgroundColor: Colors.lightBlue.shade100
                                      .withOpacity(0.8)),
                              onPressed: () async {
                                if (user == null) {
                                  Navigator.pushNamed(
                                      context, LoginScreen.routeName);
                                } else {
                                  await MyAppFunctions.showErrorOrWarningDialog(
                                      context: context,
                                      subtitle: "Are you sure?",
                                      isError: false,
                                      fct: () async {
                                        await FirebaseAuth.instance.signOut();
                                        if (!mounted) return;
                                        Navigator.pushNamed(
                                            context, LoginScreen.routeName);
                                      });
                                }
                              },
                              icon: Icon(
                                user == null ? Icons.login : Icons.logout,
                                size: 20.0,
                                color: user == null
                                    ? Colors.blue.shade700
                                    : Colors.red,
                              ),
                              label: Text(
                                user == null ? "Login" : "Logout",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: user == null
                                      ? Colors.blue.shade700
                                      : Colors
                                          .red, // Set color to red if logged out
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
