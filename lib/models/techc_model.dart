import 'package:dart_rss/dart_rss.dart';

class TechCModel {
  final String title;
  final String link;
  final String author;
  final String date;
  final String imageUrl;

  TechCModel({
    required this.title,
    required this.link,
    required this.author,
    required this.date,
    required this.imageUrl,
  });

  factory TechCModel.fromRss(RssItem item) {
    String imageUrl = "https://via.placeholder.com/300";

    // ✅ TechCrunch images are mainly here
    if (item.enclosure?.url != null &&
        item.enclosure!.type?.startsWith('image') == true) {
      imageUrl = item.enclosure!.url!;
    }

    // 🔁 Fallback: media:content
    else if (item.media?.contents.isNotEmpty ?? false) {
      imageUrl = item.media!.contents.first.url ?? imageUrl;
    }

    // 🔁 Fallback: extract from description HTML
    else if (item.description != null) {
      final regex = RegExp(r'<img[^>]+src="([^">]+)"');
      final match = regex.firstMatch(item.description!);
      if (match != null) {
        imageUrl = match.group(1)!;
      }
    }

    return TechCModel(
      title: item.title ?? "No Title",
      link: item.link ?? "",
      author: item.dc?.creator ?? "TechCrunch",
      date: item.pubDate ?? "",
      imageUrl: imageUrl,
    );
  }
}
