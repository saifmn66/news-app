
import 'package:news_app/core/services/tachc_cyber_service.dart';

void main() async {
  final service = TechCrunchCyberService();
  try {
    print('Fetching cyber news page 1...');
    final news = await service.fetchNews(page: 1);
    print('Fetched ${news.length} items.');
    for (var item in news) {
      print('Item: ${item.title}');
      print('Image: ${item.imageUrl}');
    }
  } catch (e) {
    print('FATAL ERROR: $e');
  }
}
