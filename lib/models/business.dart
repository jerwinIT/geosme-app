class Business {
  final String name;
  final String address;
  final String priceRange;
  final double rating;
  final String category;
  final String? imageUrl; // Optional image URL

  Business({
    required this.name,
    required this.address,
    required this.priceRange,
    required this.rating,
    required this.category,
    this.imageUrl, // Optional parameter
  });
}
