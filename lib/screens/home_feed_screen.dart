// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_instagram/utils/app_colors.dart';
import 'package:flutter_instagram/widgets/post_Card.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeFeedScreen extends StatelessWidget {
  const HomeFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.mobileBackgroundColor,
        title: SvgPicture.asset(
          "assets/svgs/InstagramLogo.svg",
          color: AppColors.primaryColor,
          height: 40,
        ),
        actions: [
          SvgPicture.asset(
            "assets/svgs/Messenger.svg",
            color: AppColors.primaryColor,
            height: 28,
          ),
          const SizedBox(
            width: 10,
          )
        ],
      ),
      body: const PostCard(),
    );
  }
}
