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
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
      image: json['image'],
    );
  }
}
