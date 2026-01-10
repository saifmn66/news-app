import 'package:http/http.dart' as http;
import 'package:dart_rss/dart_rss.dart';
import '../../models/techc_model.dart';

class TechCrunchService {
  final String _url = 'https://techcrunch.com/feed/';

  Future<List<TechCModel>> fetchNews({int page = 1}) async {
    final response = await http.get(Uri.parse('$_url?paged=$page'));

    if (response.statusCode == 200) {
      final rssFeed = RssFeed.parse(response.body);

      final futures = rssFeed.items.map((item) async {
        var model = TechCModel.fromRss(item);
        if (model.imageUrl == "https://via.placeholder.com/300") {
           try {
            final articleResponse = await http.get(Uri.parse(model.link));
             if (articleResponse.statusCode == 200) {
              final regex = RegExp(r'<meta property="og:image" content="([^">]+)"');
              final match = regex.firstMatch(articleResponse.body);
              if (match != null) {
                 return TechCModel(
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
      
      return Future.wait(futures);
    } else {
      throw Exception(
        'Failed to fetch TechCrunch RSS: ${response.statusCode}',
      );
    }
  }
}
