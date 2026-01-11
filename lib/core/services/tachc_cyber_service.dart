import 'package:http/http.dart' as http;
import 'package:dart_rss/dart_rss.dart';
import '../../models/techc_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class TechCrunchCyberService {
  final String _url = 'https://techcrunch.com/category/security/feed/';
  // Note: Ensure this box name matches the one you opened in main.dart
  final _box = Hive.box<TechCModel>('tech_cyber_news_box');

  List<TechCModel> getCachedNews() => _box.values.toList();

  Future<List<TechCModel>> fetchNews({int page = 1}) async {
    try {
      final response = await http.get(
        Uri.parse('$_url?paged=$page'),
        headers: {
          'User-Agent':
              'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
        },
      );

      if (response.statusCode == 200) {
        final rssFeed = RssFeed.parse(response.body);

        final futures = rssFeed.items.map((item) async {
          String? articleId;
          if (item.guid != null && item.guid!.contains('?p=')) {
            articleId = item.guid!.split('?p=').last;
          }
          var model = TechCModel.fromRss(item);
          if (model.imageUrl == "https://via.placeholder.com/300") {
            try {
              final articleResponse = await http.get(Uri.parse(model.link));
              if (articleResponse.statusCode == 200) {
                final regex = RegExp(
                  r'<meta property="og:image" content="([^">]+)"',
                );
                final match = regex.firstMatch(articleResponse.body);
                if (match != null) {
                  return TechCModel(
                    id: articleId != null ? int.parse(articleId) : 0,
                    title: model.title,
                    link: model.link,
                    author: model.author,
                    date: model.date,
                    imageUrl: match.group(1)!,
                  );
                }
              }
            } catch (_) {}
          }
          return model;
        });

        final results = await Future.wait(futures);

        // --- ADDED: SAVING LOGIC ---
        // If it's the first page, clear old cache to keep it fresh
        if (page == 1) {
          await _box.clear();
        }
        // Save new results to disk
        await _box.addAll(results);

        return results;
      } else {
        throw Exception('Failed to fetch TechCrunch RSS: ${response.statusCode}');
      }
    } catch (e) {
      // Return cache if network fails
      if (_box.isNotEmpty) {
        return _box.values.toList();
      }
      rethrow;
    }
  }
}