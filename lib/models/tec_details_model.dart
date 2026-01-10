import 'package:html_unescape/html_unescape.dart';

class TechCDetailsModel {
  final int id;
  final String date;
  final String slug;
  final String link;
  final String title;
  final String content;
  final String excerpt;
  final String imageUrl;
  final String authorName;
  final List<String> categories;

  TechCDetailsModel({
    required this.id,
    required this.date,
    required this.slug,
    required this.link,
    required this.title,
    required this.content,
    required this.excerpt,
    required this.imageUrl,
    required this.authorName,
    required this.categories,
  });

  /// Helper to strip HTML tags and decode HTML entities
  static String _cleanHtml(String htmlString) {
    final regex = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: true);
    final unescape = HtmlUnescape();
    return unescape.convert(htmlString.replaceAll(regex, ''));
  }

  factory TechCDetailsModel.fromJson(Map<String, dynamic> json) {
    return TechCDetailsModel(
      id: json['id'] ?? 0,
      date: json['date'] ?? "",
      slug: json['slug'] ?? "",
      link: json['link'] ?? "",
      title: _cleanHtml(json['title']?['rendered'] ?? "No Title"),
      content: _cleanHtml(json['content']?['rendered'] ?? ""),
      excerpt: _cleanHtml(json['excerpt']?['rendered'] ?? ""),
      imageUrl: json['jetpack_featured_media_url'] ?? "https://via.placeholder.com/600",
      authorName: json['yoast_head_json']?['author'] ?? "TechCrunch Staff",
      categories: (json['class_list'] as List?)
              ?.where((c) => c.toString().startsWith('category-'))
              .map((c) => c.toString().replaceFirst('category-', ''))
              .toList() ?? [],
    );
  }
}
