import 'package:flutter/material.dart';
import 'package:news_app/routes/app_routes.dart';
import 'package:news_app/routes/route_generator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: AppRoutes.onboarding, 
      onGenerateRoute: RouteGenerator.generateRoute, 
    );
  }
}

