import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/news_model.dart';

class NewsService {
  final String _url =
      'https://newsapi.org/v2/everything?q=information technology&from=2025-12-09&sortBy=publishedAt&apiKey=844f985999d54fc280741675a7d142e6';

  Future<List<NewsModel>> fetchNews() async {
    final uri = Uri.parse(_url);

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      final List articles = jsonData['articles'];
      return articles.map((article) => NewsModel.fromJson(article)).toList();
    } else {
      throw Exception('Failed to fetch news: ${response.statusCode}');
    }
  }
}
