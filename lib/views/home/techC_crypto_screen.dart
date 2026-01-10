import 'package:flutter/material.dart';
import 'package:news_app/core/services/techc_crypto_service.dart';
import 'package:news_app/views/detail/detail_screen.dart';
import '../../models/techc_model.dart';
import '../../widgets/news_card.dart';

class TechcCryptoScreen extends StatefulWidget {
  const TechcCryptoScreen({super.key});

  @override
  State<TechcCryptoScreen> createState() => _TechcCryptoScreenState();
}

class _TechcCryptoScreenState extends State<TechcCryptoScreen> {
  final TechCrunchCryptoService _newsCryptoService = TechCrunchCryptoService();
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
      final newArticles = await _newsCryptoService.fetchNews(page: _page);
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error loading more news: $e')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("TechCrunch News")),
      body: _articles.isEmpty
          ? (_isLoading
                ? const Center(child: CircularProgressIndicator())
                : const Center(
                    child: Text("No news found. Check your connection."),
                  ))
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
                  onTap: () {
                    print(article.id);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NewsDetailsScreen(
                          article: TechCDetailsModel(
                            id: 1,
                            date: '2026-01-08',
                            slug: 'future-of-ai',
                            link: 'https://example.com',
                            title:
                                'The Future of Artificial Intelligence: What to Expect in 2026',
                            content:
                                'Artificial intelligence continues to reshape our world in unprecedented ways. From healthcare to transportation, AI technologies are becoming increasingly sophisticated and integrated into our daily lives.\n\nMachine learning algorithms are now capable of processing vast amounts of data with remarkable accuracy, enabling breakthroughs in fields ranging from drug discovery to climate modeling. The latest developments in neural networks have opened new possibilities for natural language processing and computer vision.\n\nAs we move forward, the ethical implications of AI development remain a crucial consideration. Researchers and policymakers are working together to ensure that AI technologies are developed responsibly and benefit society as a whole.\n\nThe intersection of AI with other emerging technologies like quantum computing and biotechnology promises even more transformative changes in the years ahead. Organizations worldwide are investing heavily in AI research and development, recognizing its potential to solve some of humanity\'s most pressing challenges.',
                            excerpt:
                                'Exploring the latest developments in AI technology and their impact on society in the coming years.',
                            imageUrl:
                                'https://images.unsplash.com/photo-1677442136019-21780ecad995?w=800',
                            authorName: 'Sarah Mitchell',
                            categories: ['Technology', 'AI', 'Future'],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
