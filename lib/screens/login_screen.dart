// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_instagram/responsive/mobile_screen_layout.dart';
import 'package:flutter_instagram/responsive/responsive_layout_screen.dart';
import 'package:flutter_instagram/responsive/web_screen_layout.dart';
import 'package:flutter_instagram/screens/signup_screen.dart';
import 'package:flutter_instagram/services/fire_auth.dart';
import 'package:flutter_instagram/utils/utils.dart';
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
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void loginUser() async {
    setState(() {
      _isLoading = true;
    });
    String result = await FireAuthService().loginUser(
        email: _emailController.text, password: _passwordController.text);
    _emailController.clear();
    _passwordController.clear();
    if (result == "success") {
      Utils.showToast("Logged in successfully!");
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return const ResponsiveLayout(
            webLayout: WebScreenLayout(), mobileLayout: MobileScreenLayout());
      }));
    } else {
      Utils.showToast(result);
    }
    setState(() {
      _isLoading = false;
    });
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
              "assets/svgs/InstagramLogo.svg",
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
              isLoading: _isLoading,
              onPressed: loginUser,
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
                const SizedBox(width: 4),
                InkWell(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignupScreen())),
                  child: const Text(
                    "Sign up",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20)
          ]),
        ),
      ),
    );
  }
}
