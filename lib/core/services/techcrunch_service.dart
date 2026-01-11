import 'package:http/http.dart' as http;
import 'package:dart_rss/dart_rss.dart';
import '../../models/techc_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

class TechCrunchService {
  final String _url = 'https://techcrunch.com/feed/';
  final _box = Hive.box<TechCModel>('tech_news_box');

  // Added: Helper to get local data for immediate UI display
  List<TechCModel> getCachedNews() => _box.values.toList();

  Future<List<TechCModel>> fetchNews({int page = 1}) async {
    try { // Added: Try block to handle offline/timeout errors
      final response = await http.get(Uri.parse('$_url?paged=$page'));

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

        // Added: Save to Hive. If page is 1, we overwrite the old cache.
        if (page == 1) await _box.clear(); 
        await _box.addAll(results); 

        return results;
      } else {
        throw Exception('Failed to fetch TechCrunch RSS: ${response.statusCode}');
      }
    } catch (e) {
      // Added: Fallback to cache if network request fails
      if (_box.isNotEmpty) return _box.values.toList();
      rethrow;
    }
  }
}