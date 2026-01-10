import 'package:flutter/material.dart';
import 'package:news_app/core/services/techc_ai_service.dart';
import '../../models/techc_model.dart';
import '../../widgets/news_card.dart';

class TechcAiScreen extends StatefulWidget {
  const TechcAiScreen({super.key});

  @override
  State<TechcAiScreen> createState() => _TechcAiScreenState();
}

class _TechcAiScreenState extends State<TechcAiScreen> {
  final TechCrunchAiService _newsAiService = TechCrunchAiService();
  final ScrollController _scrollController = ScrollController();
  final List<TechCModel> _articles = [];
  bool _isLoading = false;
  int _page = 1;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _fetchArticles();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoading &&
        _hasMore) {
      _fetchArticles();
    }
  }

  Future<void> _fetchArticles() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final newArticles = await _newsAiService.fetchNews(page: _page);
      if (newArticles.isEmpty) {
        setState(() {
          _hasMore = false;
        });
      } else {
        setState(() {
          _articles.addAll(newArticles);
          _page++;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading more news: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("TechCrunch News"),
      ),
      body: _articles.isEmpty
          ? (_isLoading
              ? const Center(child: CircularProgressIndicator())
              : const Center(child: Text("No news found. Check your connection.")))
          : ListView.builder(
              controller: _scrollController,
              itemCount: _articles.length + (_hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _articles.length) {
                  return const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                final article = _articles[index];

                return NewsCard(
                  title: article.title,
                  description: "By ${article.author}",
                  imageUrl: article.imageUrl,
                  date: article.date,
                );
              },
            ),
    );
  }
}
