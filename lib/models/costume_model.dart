class Costume {
  final int id;
  final String name;
  final String description;
  final int price;
  final String image;

  Costume({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
  });

  factory Costume.fromJson(Map<String, dynamic> json) {
    return Costume(
      id: json['id'] as int,
      name: json['name'] as String,
      description: json['description'] as String,
      price: json['price'] as int,
      image: json['image'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'image': image,
    };
  }
}
