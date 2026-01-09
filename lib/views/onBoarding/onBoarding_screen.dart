import 'package:flutter/material.dart';
import 'package:flutter_overboard/flutter_overboard.dart';
import 'package:news_app/routes/app_routes.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  Widget build(BuildContext context) {
    return Scaffold(
      body: OverBoard(
        pages: _pages,
        showBullets: true,

        skipCallback: () {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text("Skip clicked")));
        },

        finishCallback: () {
          Navigator.pushReplacementNamed(context, AppRoutes.home);
        },
      ),
    );
  }

  final List<PageModel> _pages = [
    PageModel(
      color: Color(0xFF0097A7),
      imageAssetPath: 'assets/01.png',
      title: 'Welcome Dev',
      body: 'All tech news in one place',
      doAnimateImage: true,
    ),
    PageModel(
      color: Color(0xFF536DFE),
      imageAssetPath: 'assets/02.png',
      title: 'Languages',
      body: 'Flutter, Java, Python, JS updates',
      doAnimateImage: true,
    ),
    PageModel(
      color: Color(0xFF9B90BC),
      imageAssetPath: 'assets/03.png',
      title: 'Cloud & AI',
      body: 'AWS, Google, Huawei, AI news',
      doAnimateImage: true,
    ),
  ];
}
