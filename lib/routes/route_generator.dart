import 'package:flutter/material.dart';
import 'package:news_app/views/home/home_screen.dart';
import 'package:news_app/views/home/main_screen.dart';
import 'package:news_app/views/onBoarding/onBoarding_screen.dart';
import '../routes/app_routes.dart';
class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {

      case AppRoutes.onboarding:
        return MaterialPageRoute(
          builder: (_) => const OnboardingScreen(),
        );

      case AppRoutes.home:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        );
      case AppRoutes.mainScreen:
        return MaterialPageRoute(
          builder: (_) => const MainScreen(),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Route not found')),
          ),
        );
    }
  }
}
