import 'package:flutter/material.dart';
import 'package:news_app/widgets/navbar.dart';
import 'package:news_app/widgets/news_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
          NewsCard(title: "test", description: "lorem ipsum drip sold for me can do nothing holy top of this content", imageUrl: "https://storage.googleapis.com/gweb-developer-goog-blog-assets/images/GCLI005-Conductor-Blog-Header.original.png", date: "04-12-2024",),
          Text("page2"),
          Text("page3"),
          Text("page4"),
        ],
      ),
      bottomNavigationBar: CustomNavBar(pageController: pageController), 
    );
  }
}
