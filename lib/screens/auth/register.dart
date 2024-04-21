// ignore_for_file: unused_import

import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:image_picker/image_picker.dart';

// ignore: unused_importvs
import 'package:ionicons/ionicons.dart';
import 'package:plantdemic/consts/validator.dart';
import 'package:plantdemic/root_screen.dart';
import 'package:plantdemic/screens/auth/login.dart';
import 'package:plantdemic/screens/loading_manager.dart';
import 'package:plantdemic/services/my_app_methods.dart';
import 'package:plantdemic/widgets/app_name_text.dart';
import 'package:plantdemic/widgets/auth/google_btn.dart';
import 'package:plantdemic/widgets/auth/pick_image_widget.dart';
import 'package:plantdemic/widgets/subtitle_text.dart';
import 'package:plantdemic/widgets/title_text.dart';

class RegisterScreen extends StatefulWidget {
  static const routeName = "/RegisterScreen";
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  late final TextEditingController _nameController,
      _emailController,
      _passwordController,
      _repeatPasswordController;

  late final FocusNode _nameFocusNode,
      _emailFocusNode,
      _passwordFocusNode,
      _repeatPasswordFocusNode;

  final _formKey = GlobalKey<FormState>();

  bool obscureText = true;
  bool isLoading = false;
  XFile? _pickedImage;
  final auth = FirebaseAuth.instance;
  String? userImageUrl;

  @override
  void initState() {
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _repeatPasswordController = TextEditingController();
    // Focus Nodes
    _nameFocusNode = FocusNode();
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    _repeatPasswordFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    if (mounted) {
      _nameController.dispose();
      _emailController.dispose();
      _passwordController.dispose();
      _repeatPasswordController.dispose();
      // Focus Nodes
      _nameFocusNode.dispose();
      _emailFocusNode.dispose();
      _passwordFocusNode.dispose();
      _repeatPasswordFocusNode.dispose();
    }
    super.dispose();
  }

  Future<void> _registerFct() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (_pickedImage == null) {
      MyAppFunctions.showErrorOrWarningDialog(
          context: context,
          subtitle: "Make sure to select an image",
          fct: () {});
      return;
    }
    if (isValid) {
      _formKey.currentState!.save();
      try {
        setState(() {
          isLoading = true;
        });

        final ref = FirebaseStorage.instance
            .ref()
            .child("usersImages")
            .child("${_emailController.text.trim()}.jpg");
        await ref.putFile(File(_pickedImage!.path));
        userImageUrl = await ref.getDownloadURL();
        await auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        User? user = auth.currentUser;
        final uid = user!.uid;

        await FirebaseFirestore.instance.collection("users").doc(uid).set({
          'userId': uid,
          'userName': _nameController.text,
          'userImage': userImageUrl,
          'userEmail': _emailController.text.toLowerCase(),
          'createdAt': Timestamp.now(),
          'userWish': [],
          'userCart': [],
        });
        // Fluttertoast.showToast(
        //   msg: "An account has been created",
        //   textColor: Colors.white,
        // );
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, RootScreen.routeName);
      } on FirebaseException catch (error) {
        await MyAppFunctions.showErrorOrWarningDialog(
          context: context,
          subtitle: error.message.toString(),
          fct: () {},
        );
      } catch (error) {
        await MyAppFunctions.showErrorOrWarningDialog(
          context: context,
          subtitle: error.toString(),
          fct: () {},
        );
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> localImagePicker() async {
    final ImagePicker imagePicker = ImagePicker();
    await MyAppFunctions.imagePickerDialog(
      context: context,
      cameraFCT: () async {
        _pickedImage = await imagePicker.pickImage(source: ImageSource.camera);
        setState(() {});
      },
      galleryFCT: () async {
        _pickedImage = await imagePicker.pickImage(source: ImageSource.gallery);
        setState(() {});
      },
      removeFCT: () {
        setState(() {
          _pickedImage = null;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: LoadingManager(
          isLoading: isLoading,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  AppNameTextWidget(
                    fontSize: 30,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TitlesTextWidget(
                      label: "Welcome,",
                      fontSize: 24,
                    ),
                  ),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                          "Enter your account information to get started.")),
                  SizedBox(
                    height: 24,
                  ),
                  SizedBox(
                    height: size.width * 0.5,
                    width: size.width * 0.5,
                    child: PickImageWidget(
                      pickedImage: _pickedImage,
                      function: () async {
                        await localImagePicker();
                      },
                    ),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          //
                          //name field
                          //
                          TextFormField(
                            controller: _nameController,
                            focusNode: _nameFocusNode,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                              hintText: "Name",
                              prefixIcon: Icon(IconlyLight.profile),
                            ),
                            validator: (value) {
                              return MyValidators.displayNamevalidator(value);
                            },
                            onFieldSubmitted: (value) {
                              FocusScope.of(context)
                                  .requestFocus(_emailFocusNode);
                            },
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          //
                          // email field
                          //
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
                            height: 12,
                          ),
                          //
                          // password field
                          //
                          TextFormField(
                            controller: _passwordController,
                            focusNode: _passwordFocusNode,
                            textInputAction: TextInputAction.next,
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
                              FocusScope.of(context)
                                  .requestFocus(_repeatPasswordFocusNode);
                            },
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          //
                          // repeat password field
                          //
                          TextFormField(
                            controller: _repeatPasswordController,
                            focusNode: _repeatPasswordFocusNode,
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: obscureText,
                            decoration: InputDecoration(
                              hintText: "Repeat password",
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
                            onFieldSubmitted: (value) {
                              _registerFct();
                            },
                            validator: (value) {
                              return MyValidators.repeatPasswordValidator(
                                  value: value,
                                  password: _passwordController.text);
                            },
                          ),

                          SizedBox(
                            height: 50,
                          ),
                          //
                          //
                          //Sign up Button
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
                              icon: Icon(
                                IconlyLight.addUser,
                                color: Colors.white,
                                size: 20,
                              ),
                              label: Text(
                                "Sign up",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                              onPressed: () async {
                                _registerFct();
                              },
                            ),
                          ),
                          SizedBox(height: 30),
                          SubtitleTextWidget(
                            label: "Other ways to Sign up",
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
                                            fontSize: 15, color: Colors.white),
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
                                label: "Have an account?",
                                fontSize: 15,
                              ),
                              TextButton(
                                child: const SubtitleTextWidget(
                                  label: "Log in",
                                  fontSize: 15,
                                  //fontStyle: FontStyle.italic,
                                  textDecoration: TextDecoration.underline,
                                ),
                                onPressed: () {
                                  Navigator.of(context)
                                      .pushNamed(LoginScreen.routeName);
                                },
                              ),
                            ],
                          )
                        ],
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
