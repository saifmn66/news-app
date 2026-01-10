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

  factory TechCDetailsModel.fromJson(Map<String, dynamic> json) {
    return TechCDetailsModel(
      id: json['id'] ?? 0,
      date: json['date'] ?? "",
      slug: json['slug'] ?? "",
      link: json['link'] ?? "",
      // Parsing nested 'rendered' objects
      title: json['title']?['rendered'] ?? "No Title",
      content: json['content']?['rendered'] ?? "",
      excerpt: json['excerpt']?['rendered'] ?? "",
      // Jetpack provides the direct high-res image URL here
      imageUrl: json['jetpack_featured_media_url'] ?? "https://via.placeholder.com/600",
      // Author name is usually inside yoast_head_json for easy access
      authorName: json['yoast_head_json']?['author'] ?? "TechCrunch Staff",
      // Extracting category names from class_list or looking them up
      categories: (json['class_list'] as List?)
              ?.where((c) => c.toString().startsWith('category-'))
              .map((c) => c.toString().replaceFirst('category-', ''))
              .toList() ?? [],
    );
  }
}