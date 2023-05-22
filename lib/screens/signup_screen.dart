// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_instagram/responsive/mobile_screen_layout.dart';
import 'package:flutter_instagram/responsive/responsive_layout_screen.dart';
import 'package:flutter_instagram/responsive/web_screen_layout.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';

import 'package:flutter_instagram/services/fire_auth.dart';
import 'package:flutter_instagram/screens/login_screen.dart';
import 'package:flutter_instagram/utils/utils.dart';
import 'package:flutter_instagram/widgets/blue_button.dart';
import 'package:flutter_instagram/utils/app_colors.dart';
import 'package:flutter_instagram/widgets/text_input_field.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  bool _isLoading = false;
  Uint8List? _profileImage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  void selectImage() async {
    Uint8List pickedImage = await Utils.pickImage(ImageSource.gallery);
    setState(() {
      _profileImage = pickedImage;
    });
  }

  void signUpUser() async {
    setState(() {
      _isLoading = true;
    });
    String result = await FireAuth().signUpUser(
        email: _emailController.text,
        password: _passwordController.text,
        username: _usernameController.text,
        bio: _bioController.text,
        profileImage: _profileImage!);
    _emailController.clear();
    _passwordController.clear();
    _usernameController.clear();
    _bioController.clear();
    Utils.showToast(result);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return const ResponsiveLayout(
          webLayout: WebScreenLayout(), mobileLayout: MobileScreenLayout());
    }));
    setState(() {
      _profileImage = null;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            width: double.infinity,
            height: 700,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    flex: 1,
                    child: Container(),
                  ),
                  SvgPicture.asset(
                    "assets/instagram_logo.svg",
                    color: AppColors.primaryColor,
                    height: 64,
                  ),
                  const SizedBox(height: 64),
                  InkWell(
                    onTap: selectImage,
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    child: Container(
                      padding: EdgeInsets.all(_profileImage == null ? 35 : 0),
                      decoration: BoxDecoration(
                          border: Border.all(
                            width: 4,
                            color: AppColors.secondaryColor,
                          ),
                          shape: BoxShape.circle),
                      child: _profileImage == null
                          ? const Icon(Icons.add_a_photo_outlined,
                              color: AppColors.secondaryColor, size: 35)
                          : CircleAvatar(
                              radius: 60,
                              backgroundImage: MemoryImage(_profileImage!),
                            ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextInputField(
                    textEditingController: _usernameController,
                    hintText: "Username",
                    textInputType: TextInputType.text,
                  ),
                  const SizedBox(height: 20),
                  TextInputField(
                    textEditingController: _bioController,
                    hintText: "Bio",
                    textInputType: TextInputType.text,
                  ),
                  const SizedBox(height: 20),
                  TextInputField(
                    textEditingController: _emailController,
                    hintText: "Email",
                    textInputType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 20),
                  TextInputField(
                    textEditingController: _passwordController,
                    hintText: "Password",
                    isPasswordField: true,
                    textInputType: TextInputType.text,
                  ),
                  const SizedBox(height: 20),
                  BlueButton(
                    text: "Sign up",
                    isLoading: _isLoading,
                    onPressed: signUpUser,
                  ),
                  Flexible(
                    flex: 1,
                    child: Container(),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already have an account?",
                        style: TextStyle(
                          color: AppColors.secondaryColor,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 4),
                      InkWell(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen())),
                        child: const Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  )
                ]),
          ),
        ),
      ),
    );
  }
}
