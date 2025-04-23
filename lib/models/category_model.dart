class Category {
  final String name;
  final String imageUrl;
  final String description;

  Category({
    required this.name,
    required this.imageUrl,
    required this.description,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      name: json['strCategory'],
      imageUrl: json['strCategoryThumb'],
      description: json['strCategoryDescription'],
    );
  }
}
