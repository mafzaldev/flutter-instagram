import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_instagram/responsive/web_screen_layout.dart';
import 'package:flutter_instagram/utils/app_colors.dart';
import 'package:flutter_instagram/responsive/responsive_layout_screen.dart';
import 'package:flutter_instagram/responsive/mobile_screen_layout.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  kIsWeb
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
          projectId: "instagram-clone-13f77",
          appId: "1:180168720453:web:36226e70a39674f4b5e32c",
          apiKey: "AIzaSyD99IPVfJAkj03L8O_afH7mg_aOgd5MRgo",
          messagingSenderId: "180168720453",
          storageBucket: "instagram-clone-13f77.appspot.com",
        ))
      : await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Instagram Clone',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true)
          .copyWith(scaffoldBackgroundColor: AppColors.mobileBackgroundColor),
      home: const ResponsiveLayout(
          webLayout: WebScreenLayout(), mobileLayout: MobileScreenLayout()),
    );
  }
}
