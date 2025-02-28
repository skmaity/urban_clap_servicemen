class ServiceMan {
  final String name;
  final String imageUrl;
  final String rating;
  final String specialty;
  final String id;


  ServiceMan({
    required this.name,
    required this.imageUrl,
    required this.rating,
    required this.specialty,
    required this.id,
  });
    factory ServiceMan.fromJson(Map<String, dynamic> json) {
    return ServiceMan(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      rating: json['rating'] ?? '',
      specialty: json['specialty'] ?? '',
    );
  }
}