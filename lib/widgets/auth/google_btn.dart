// ignore_for_file: use_build_context_synchronously, unused_import, unnecessary_import, unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:plantdemic/root_screen.dart';
import 'package:plantdemic/services/assets_manager.dart';
import 'package:plantdemic/services/my_app_methods.dart';

class GoogleButton extends StatelessWidget {
  const GoogleButton({super.key});

  Future<void> _googleSignIn({required BuildContext context}) async {
    final googleSignIn = GoogleSignIn();
    final googleAccount = await googleSignIn.signIn();
    if (googleAccount != null) {
      final googleAuth = await googleAccount.authentication;
      if (googleAuth.accessToken != null && googleAuth.idToken != null) {
        try {
          final authResults = await FirebaseAuth.instance
              .signInWithCredential(GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          ));
          if (authResults.additionalUserInfo!.isNewUser) {
            await FirebaseFirestore.instance
                .collection("users")
                .doc(
                  authResults.user!.uid,
                )
                .set({
              'userId': authResults.user!.uid,
              'userName': authResults.user!.displayName,
              'userImage': authResults.user!.photoURL,
              'userEmail': authResults.user!.email,
              'createdAt': Timestamp.now(),
              'userWish': [],
              'userCart': [],
            });
          }
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            Navigator.pushReplacementNamed(context, RootScreen.routeName);
          });
        } on FirebaseException catch (error) {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            await MyAppFunctions.showErrorOrWarningDialog(
                context: context,
                subtitle: "An error has occured. ${error.message}",
                fct: () {});
          });
        } catch (error) {
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            await MyAppFunctions.showErrorOrWarningDialog(
                context: context,
                subtitle: "An error has occured. $error",
                fct: () {});
          });
        }
      }
    }
  }

  // Future<void> _googleSignIn({required BuildContext context}) async {
  //   try {
  //     final googleSignIn = GoogleSignIn();
  //     final googleAccount = await googleSignIn.signIn();
  //     if (googleAccount != null) {
  //       final googleAuth = await googleAccount.authentication;
  //       if (googleAuth.accessToken != null && googleAuth.idToken != null) {
  //         final authResults = await FirebaseAuth.instance
  //             .signInWithCredential(GoogleAuthProvider.credential(
  //           accessToken: googleAuth.accessToken,
  //           idToken: googleAuth.idToken,
  //         ));
  //         if (authResults.additionalUserInfo!.isNewUser) {
  //           await FirebaseFirestore.instance
  //               .collection("users")
  //               .doc(
  //                 authResults.user!.uid,
  //               )
  //               .set({
  //             'userId': authResults.user!.uid,
  //             'userName': authResults.user!.displayName,
  //             'userImage': authResults.user!.photoURL,
  //             'userEmail': authResults.user!.email,
  //             'createdAt': Timestamp.now(),
  //             'userWish': [],
  //             'userCart': [],
  //           });
  //         }
  //       }
  //     }
  //     WidgetsBinding.instance.addPostFrameCallback((_) {
  //       Navigator.pushReplacementNamed(context, RootScreen.routeName);
  //     });
  //   } on FirebaseException catch (error) {
  //     await MyAppFunctions.showErrorOrWarningDialog(
  //       context: context,
  //       subtitle: error.message.toString(),
  //       fct: () {},
  //     );
  //   } catch (error) {
  //     await MyAppFunctions.showErrorOrWarningDialog(
  //       context: context,
  //       subtitle: error.toString(),
  //       fct: () {},
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(12),
        backgroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      onPressed: () {
        _googleSignIn(context: context);
      },
      icon: Image.asset(
        AssetsManager.google,
        width: 22,
        height: 22,
      ),
      label: Padding(
        padding: const EdgeInsets.only(left: 2.0),
        child: Text(
          "Sign in with Google",
          style: TextStyle(
            color: Colors.black,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}
