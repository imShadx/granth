class Book {
  final String id;
  final String title;
  final String author;
  final int? coverId;
  final String? summary;

  const Book({
    required this.id,
    required this.title,
    required this.author,
    this.coverId,
    this.summary,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['key'] ?? '',
      title: json['title'] ?? 'Unknown Title',
      author: (json['author_name'] as List?)?.first ?? 'Unknown Author',
      coverId: json['cover_i'],
    );
  }

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'] ?? '',
      title: map['title'] ?? 'Unknown Title',
      author: map['author'] ?? 'Unknown Author',
      coverId: map['coverId'],
      summary: map['summary'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'coverId': coverId,
      'summary': summary,
    };
  }
}
