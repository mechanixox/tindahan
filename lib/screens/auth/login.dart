// ignore_for_file: unused_field

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:plantdemic/consts/validator.dart';
import 'package:plantdemic/root_screen.dart';
import 'package:plantdemic/screens/auth/forgot_password.dart';
import 'package:plantdemic/screens/auth/register.dart';
import 'package:plantdemic/screens/loading_manager.dart';
import 'package:plantdemic/services/assets_manager.dart';
import 'package:plantdemic/services/my_app_methods.dart';
import 'package:plantdemic/widgets/app_name_text.dart';
import 'package:plantdemic/widgets/auth/google_btn.dart';
import 'package:plantdemic/widgets/subtitle_text.dart';
import 'package:plantdemic/widgets/title_text.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = "/LoginScreen";
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final FocusNode _emailFocusNode;
  late final FocusNode _passwordFocusNode;
  late final _formKey = GlobalKey<FormState>();

  bool obscureText = true;
  bool isLoading = false;
  final auth = FirebaseAuth.instance;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    //Focus nodes
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _loginFct() async {
    //final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    // if (isValid) {
    //   _formKey.currentState!.save();
    // }
    try {
      setState(() {
        isLoading = true;
      });
      await auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, RootScreen.routeName);

      // Fluttertoast.showToast(
      //     msg: "Account has been created",
      //     toastLength: Toast.LENGTH_SHORT,
      //     gravity: ToastGravity.CENTER,
      //     timeInSecForIosWeb: 1,
      //     backgroundColor: Colors.red,
      //     textColor: Colors.white,
      //     fontSize: 16.0);
    } on FirebaseAuthException catch (error) {
      if (!mounted) return;
      await MyAppFunctions.showErrorOrWarningDialog(
        context: context,
        subtitle: "An error occured. ${error.message}",
        fct: () {},
      );
    } catch (error) {
      if (!mounted) return;
      await MyAppFunctions.showErrorOrWarningDialog(
        context: context,
        subtitle: "An error occured. $error",
        fct: () {},
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: LoadingManager(
          isLoading: isLoading,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  AppNameTextWidget(
                    fontSize: 25,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  //insert app logo here
                  Image.asset(
                    AssetsManager.appLogo,
                    width: size.width * 0.4,
                    height: size.width * 0.4,
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TitlesTextWidget(label: "Welcome back"),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Form(
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _emailController,
                          focusNode: _emailFocusNode,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: "Email address",
                            prefixIcon: Icon(IconlyLight.message),
                          ),
                          validator: (value) {
                            return MyValidators.emailValidator(value);
                          },
                          onFieldSubmitted: (value) {
                            FocusScope.of(context)
                                .requestFocus(_passwordFocusNode);
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: _passwordController,
                          focusNode: _passwordFocusNode,
                          textInputAction: TextInputAction.done,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: obscureText,
                          decoration: InputDecoration(
                            hintText: "Password",
                            prefixIcon: Icon(IconlyLight.lock),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  obscureText = !obscureText;
                                });
                              },
                              icon: Icon(
                                size: 18,
                                obscureText
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                            ),
                          ),
                          validator: (value) {
                            return MyValidators.passwordValidator(value);
                          },
                          onFieldSubmitted: (value) {
                            _loginFct();
                          },
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        //
                        // forgot password
                        //
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context)
                                    .pushNamed(ForgotPasswordScreen.routeName);
                              },
                              child: SubtitleTextWidget(
                                label: "Forgot password",
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        //
                        //
                        //Login Button
                        //
                        //
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purple.shade600,
                              padding: EdgeInsets.all(12),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            onPressed: () async {
                              _loginFct();
                            },
                            icon: Icon(
                              Icons.login,
                              color: Colors.white,
                              size: 20,
                            ),
                            label: Text(
                              "Login",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 30),
                        SubtitleTextWidget(
                          label: "Other ways to Login",
                          fontSize: 15,
                        ),
                        //
                        //
                        //Google Sign in
                        //
                        //
                        const SizedBox(
                          height: 16.0,
                        ),
                        SizedBox(
                          height: kBottomNavigationBarHeight + 10,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              const Expanded(
                                flex: 2,
                                child: SizedBox(
                                  height: kBottomNavigationBarHeight,
                                  child: GoogleButton(),
                                ),
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              //
                              //
                              // Guest
                              //
                              //
                              Expanded(
                                child: SizedBox(
                                  height: kBottomNavigationBarHeight,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.purple.shade600,
                                      padding: const EdgeInsets.all(12.0),
                                      // backgroundColor: Colors.red,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          12.0,
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      "Guest",
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                      ),
                                    ),
                                    onPressed: () async {
                                      Navigator.of(context)
                                          .pushNamed(RootScreen.routeName);
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SubtitleTextWidget(
                              label: "New here?",
                              fontSize: 15,
                            ),
                            TextButton(
                              child: const SubtitleTextWidget(
                                label: "Sign up",
                                fontSize: 15,
                                //fontStyle: FontStyle.italic,
                                textDecoration: TextDecoration.underline,
                              ),
                              onPressed: () {
                                Navigator.of(context)
                                    .pushNamed(RegisterScreen.routeName);
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
