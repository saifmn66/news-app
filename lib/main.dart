import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:news_app/models/techc_model.dart';
import 'package:news_app/routes/app_routes.dart';
import 'package:news_app/routes/route_generator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(TechCModelAdapter());
  await Hive.openBox<TechCModel>('tech_news_box');
  await Hive.openBox<TechCModel>('tech_cyber_news_box');
  await Hive.openBox<TechCModel>('tech_ai_news_box');
  await Hive.openBox<TechCModel>('tech_crypto_news_box');
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: AppRoutes.onboarding, 
      onGenerateRoute: RouteGenerator.generateRoute, 
    );
  }
}

