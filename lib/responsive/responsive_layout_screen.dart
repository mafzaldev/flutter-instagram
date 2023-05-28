import 'package:flutter/material.dart';
import 'package:flutter_instagram/providers/user_provider.dart';
import 'package:flutter_instagram/utils/app_dimensions.dart';
import 'package:provider/provider.dart';

class ResponsiveLayout extends StatefulWidget {
  final Widget webLayout;
  final Widget mobileLayout;
  const ResponsiveLayout(
      {super.key, required this.webLayout, required this.mobileLayout});

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {
  @override
  void initState() {
    super.initState();
    getUserDetails();
  }

  getUserDetails() {
    UserProvider userProvider = Provider.of(context, listen: false);
    userProvider.refreshUser();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= AppDimensions.webScreenSize) {
          return widget.webLayout;
        } else {
          return widget.mobileLayout;
        }
      },
    );
  }
}
