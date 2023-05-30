// ignore_for_file: deprecated_member_use

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram/providers/user_provider.dart';
import 'package:flutter_instagram/screens/add_post_screen.dart';
import 'package:flutter_instagram/screens/home_feed_screen.dart';
import 'package:flutter_instagram/screens/profile_screen.dart';
import 'package:flutter_instagram/screens/search_screen.dart';
import 'package:flutter_instagram/utils/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({super.key});

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  int _page = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    getUserDetails();
  }

  getUserDetails() {
    UserProvider userProvider = Provider.of(context, listen: false);
    userProvider.refreshUser();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void navigationTapped(int page) {
    _pageController.jumpToPage(page);
  }

  void pageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: pageChanged,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          const HomeFeedScreen(),
          const SearchScreen(),
          const AddPostScreen(),
          const Center(
            child: Text("TODO: to be implemented!"),
          ),
          ProfileScreen(
            uid: FirebaseAuth.instance.currentUser!.uid,
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.mobileBackgroundColor,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(
              icon: SvgPicture.asset(
                "assets/svgs/Home.svg",
                color: _page == 0
                    ? AppColors.primaryColor
                    : AppColors.secondaryColor,
                height: 30,
              ),
              label: 'Home'),
          BottomNavigationBarItem(
              icon: SvgPicture.asset(
                "assets/svgs/Search.svg",
                color: _page == 1
                    ? AppColors.primaryColor
                    : AppColors.secondaryColor,
                height: 30,
              ),
              label: 'Search'),
          BottomNavigationBarItem(
              icon: SvgPicture.asset(
                "assets/svgs/Add.svg",
                color: _page == 2
                    ? AppColors.primaryColor
                    : AppColors.secondaryColor,
                height: 30,
              ),
              label: 'Add'),
          BottomNavigationBarItem(
              icon: SvgPicture.asset(
                "assets/svgs/Like.svg",
                color: _page == 3
                    ? AppColors.primaryColor
                    : AppColors.secondaryColor,
                height: 30,
              ),
              label: 'Notifications'),
          BottomNavigationBarItem(
              icon: SvgPicture.asset(
                "assets/svgs/User.svg",
                color: _page == 4
                    ? AppColors.primaryColor
                    : AppColors.secondaryColor,
                height: 30,
              ),
              label: 'User'),
        ],
        onTap: navigationTapped,
        currentIndex: _page,
      ),
    );
  }
}
