// ignore_for_file: deprecated_member_use

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_instagram/screens/signup_screen.dart';
import 'package:flutter_instagram/widgets/blue_button.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_instagram/utils/app_colors.dart';
import 'package:flutter_instagram/widgets/text_input_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
              text: "Login",
              onPressed: () => log("Login"),
            ),
            Flexible(
              flex: 2,
              child: Container(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Don't have an account?",
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
                          builder: (context) => const SignupScreen())),
                  child: const Text(
                    "Sign up.",
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
