import 'package:flutter/material.dart';
import 'package:news_app/views/home/techC_ai_screen.dart';
import 'package:news_app/views/home/techC_cyber_screen.dart';
import 'package:news_app/views/home/techC_screen.dart';
import 'package:news_app/widgets/navbar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: const [
          TechcScreen(),
          TechcCyberScreen(),
          TechcAiScreen(),
          Text("page4"),
        ],
      ),
      bottomNavigationBar: CustomNavBar(pageController: pageController), 
    );
  }
}
