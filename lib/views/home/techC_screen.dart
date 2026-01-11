import 'package:flutter/material.dart';
import 'package:news_app/core/services/techC_details_service.dart';
import 'package:news_app/core/services/techcrunch_service.dart';
import 'package:news_app/views/detail/detail_screen.dart';
import '../../models/techc_model.dart';
import '../../widgets/news_card.dart';

class TechcScreen extends StatefulWidget {
  const TechcScreen({super.key});

  @override
  State<TechcScreen> createState() => _TechcScreenState();
}

class _TechcScreenState extends State<TechcScreen> {
  final TechCrunchService _newsService = TechCrunchService();
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

    // 1. Show cache immediately if we are starting fresh
    if (_page == 1 && _articles.isEmpty) {
      final cachedData = _newsService.getCachedNews();
      if (cachedData.isNotEmpty) {
        setState(() {
          _articles.addAll(cachedData);
        });
      }
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final newArticles = await _newsService.fetchNews(page: _page);

      setState(() {
        if (_page == 1) _articles.clear(); // Replace cache with fresh API data
        _articles.addAll(newArticles);
        _page++;
        if (newArticles.isEmpty) _hasMore = false;
      });
    } catch (e) {
      // 2. EMERGENCY FALLBACK: If network fails and UI is empty, try cache again
      if (_articles.isEmpty) {
        final fallbackCache = _newsService.getCachedNews();
        if (fallbackCache.isNotEmpty) {
          setState(() {
            _articles.addAll(fallbackCache);
          });
        }
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Working Offline: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("TechCrunch News")),
      body: _articles.isEmpty && _isLoading
          ? const Center(child: CircularProgressIndicator())
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
                  onTap: () async {
                    final service = TechCrunchDetailsService();

                    // Show a loading dialog while fetching
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) =>
                          const Center(child: CircularProgressIndicator()),
                    );

                    try {
                      final articleDetails = await service.fetchArticleById(
                        article.id,
                      );

                      Navigator.pop(context); // Close the loading dialog

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              NewsDetailsScreen(article: articleDetails),
                        ),
                      );
                    } catch (e) {
                      Navigator.pop(context); // Close the loading dialog
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to load article: $e')),
                      );
                    }
                  },
                );
              },
            ),
    );
  }
}
