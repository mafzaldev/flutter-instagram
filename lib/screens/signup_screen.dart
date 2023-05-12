// ignore_for_file: deprecated_member_use

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_instagram/screens/login_screen.dart';
import 'package:flutter_instagram/widgets/blue_button.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          width: double.infinity,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Flexible(
              flex: 2,
              child: Container(),
            ),
            SvgPicture.asset(
              "assets/instagram_logo.svg",
              color: AppColors.primaryColor,
              height: 64,
            ),
            const SizedBox(height: 64),
            Stack(
              children: [
                const CircleAvatar(
                  radius: 48,
                  backgroundImage: NetworkImage(
                      "https://upload.wikimedia.org/wikipedia/commons/c/ca/Osama_bin_Laden_portrait.jpg"),
                ),
                Positioned(
                  bottom: -5,
                  right: -5,
                  child: IconButton(
                    onPressed: () => log("Add profile picture"),
                    icon: const Icon(
                      Icons.add_a_photo,
                      size: 25,
                      color: AppColors.primaryColor,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 24),
            TextInputField(
              textEditingController: _usernameController,
              hintText: "Username",
              textInputType: TextInputType.text,
            ),
            const SizedBox(height: 24),
            TextInputField(
              textEditingController: _bioController,
              hintText: "Bio",
              isPasswordField: true,
              textInputType: TextInputType.text,
            ),
            const SizedBox(height: 24),
            TextInputField(
              textEditingController: _emailController,
              hintText: "Email",
              textInputType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 24),
            TextInputField(
              textEditingController: _passwordController,
              hintText: "Password",
              isPasswordField: true,
              textInputType: TextInputType.text,
            ),
            const SizedBox(height: 24),
            BlueButton(
              text: "Sign up",
              onTap: () => log("Sign up"),
            ),
            Flexible(
              flex: 2,
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
                const SizedBox(width: 8),
                InkWell(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen())),
                  child: const Text(
                    "Login.",
                    style: TextStyle(
                      color: AppColors.blueColor,
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
    );
  }
}
