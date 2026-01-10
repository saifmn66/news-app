import 'package:flutter/material.dart';
import 'package:news_app/core/services/news_service.dart';
import 'package:news_app/models/news_model.dart';
import 'package:news_app/widgets/news_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final NewsService _newsService = NewsService();
  late Future<List<NewsModel>> _newsFuture;

  @override
  void initState() {
    super.initState();
    // Fetch news when screen loads
    _newsFuture = _newsService.fetchNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tech News')),
      body: SafeArea(
        child: FutureBuilder<List<NewsModel>>(
          future: _newsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No news found.'));
            }

            final newsList = snapshot.data!;
            return ListView.builder(
              itemCount: newsList.length,
              itemBuilder: (context, index) {
                final news = newsList[index];
                return NewsCard(
                  title: news.title,
                  description: news.description ?? '',
                  imageUrl: news.urlToImage ??
                      'https://via.placeholder.com/150', // fallback image
                  date: news.publishedAt.toString().split('T')[0],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
