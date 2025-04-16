class Article {
  final String title;
  final String description;
  final String imageUrl;
  final String url;

  Article({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.url,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'] ?? 'Không có tiêu đề',
      description: json['description'] ?? 'Không có mô tả',
      imageUrl: json['urlToImage'] ?? 'https://via.placeholder.com/150',
      url: json['url'] ?? '', // Gán url từ JSON
    );
  }
}