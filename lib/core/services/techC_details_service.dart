import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:news_app/models/tec_details_model.dart';

class TechCrunchDetailsService {
  final String _baseUrl = 'https://techcrunch.com/wp-json/wp/v2/posts/';

  Future<TechCDetailsModel> fetchArticleById(int id) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl$id'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return TechCDetailsModel.fromJson(data);
      } else {
        throw Exception(
          'Failed to fetch article details: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching article details: $e');
    }
  }
}
