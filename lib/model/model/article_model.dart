class Article {
  final String newsSourceName;
  final String title;
  final String description;
  final String url;
  final String imageUrl;
  final String publishedAt;

  Article(
      {required this.newsSourceName,
      required this.title,
      required this.description,
      required this.url,
      required this.imageUrl,
      required this.publishedAt});

  factory Article.fromJson(Map<String, dynamic> jsonData) {
    Map<String, dynamic> source = jsonData['source'];

    return Article(
        newsSourceName: source['name'] == null ? 'undefined' : source['name'],
        title: jsonData['title'] == null ? 'undefined' : jsonData['title'],
        description: jsonData['description'] == null
            ? 'undefined'
            : jsonData['description'],
        url: jsonData['url'] == null ? 'undefined' : jsonData['url'],
        imageUrl: jsonData['urlToImage'] == null
            ? 'undefined'
            : jsonData['urlToImage'],
        publishedAt: jsonData['publishedAt'] == null
            ? 'undefined'
            : jsonData['publishedAt']);
  }
}
