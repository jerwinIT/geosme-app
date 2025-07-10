class Business {
  final String id;
  final String name;
  final String address;
  final String municipality;
  final String priceRange;
  final double rating;
  final int reviewCount;
  final String category;
  final String? imageUrl;
  final double latitude;
  final double longitude;
  final String? phoneNumber;
  final String? email;
  final String? website;
  final String? description;
  final List<String> tags;
  final DateTime? establishedDate;
  final int employeeCount;
  final String businessSize; // Small, Medium
  final Map<String, dynamic>? operatingHours;
  bool isBookmarked;
  final List<Review> reviews;

  Business({
    required this.id,
    required this.name,
    required this.address,
    required this.municipality,
    required this.priceRange,
    required this.rating,
    this.reviewCount = 0,
    required this.category,
    this.imageUrl,
    required this.latitude,
    required this.longitude,
    this.phoneNumber,
    this.email,
    this.website,
    this.description,
    this.tags = const [],
    this.establishedDate,
    this.employeeCount = 0,
    this.businessSize = 'Small',
    this.operatingHours,
    this.isBookmarked = false,
    this.reviews = const [],
  });

  // Factory constructor for creating from JSON
  factory Business.fromJson(Map<String, dynamic> json) {
    return Business(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      municipality: json['municipality'] ?? '',
      priceRange: json['priceRange'] ?? '',
      rating: (json['rating'] ?? 0.0).toDouble(),
      reviewCount: json['reviewCount'] ?? 0,
      category: json['category'] ?? '',
      imageUrl: json['imageUrl'],
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      phoneNumber: json['phoneNumber'],
      email: json['email'],
      website: json['website'],
      description: json['description'],
      tags: List<String>.from(json['tags'] ?? []),
      establishedDate: json['establishedDate'] != null
          ? DateTime.parse(json['establishedDate'])
          : null,
      employeeCount: json['employeeCount'] ?? 0,
      businessSize: json['businessSize'] ?? 'Small',
      operatingHours: json['operatingHours'],
      isBookmarked: json['isBookmarked'] ?? false,
      reviews:
          (json['reviews'] as List<dynamic>?)
              ?.map((review) => Review.fromJson(review))
              .toList() ??
          [],
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'municipality': municipality,
      'priceRange': priceRange,
      'rating': rating,
      'reviewCount': reviewCount,
      'category': category,
      'imageUrl': imageUrl,
      'latitude': latitude,
      'longitude': longitude,
      'phoneNumber': phoneNumber,
      'email': email,
      'website': website,
      'description': description,
      'tags': tags,
      'establishedDate': establishedDate?.toIso8601String(),
      'employeeCount': employeeCount,
      'businessSize': businessSize,
      'operatingHours': operatingHours,
      'isBookmarked': isBookmarked,
      'reviews': reviews.map((review) => review.toJson()).toList(),
    };
  }

  // Copy with method
  Business copyWith({
    String? id,
    String? name,
    String? address,
    String? municipality,
    String? priceRange,
    double? rating,
    int? reviewCount,
    String? category,
    String? imageUrl,
    double? latitude,
    double? longitude,
    String? phoneNumber,
    String? email,
    String? website,
    String? description,
    List<String>? tags,
    DateTime? establishedDate,
    int? employeeCount,
    String? businessSize,
    Map<String, dynamic>? operatingHours,
    bool? isBookmarked,
    List<Review>? reviews,
  }) {
    return Business(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      municipality: municipality ?? this.municipality,
      priceRange: priceRange ?? this.priceRange,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      category: category ?? this.category,
      imageUrl: imageUrl ?? this.imageUrl,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      website: website ?? this.website,
      description: description ?? this.description,
      tags: tags ?? this.tags,
      establishedDate: establishedDate ?? this.establishedDate,
      employeeCount: employeeCount ?? this.employeeCount,
      businessSize: businessSize ?? this.businessSize,
      operatingHours: operatingHours ?? this.operatingHours,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      reviews: reviews ?? this.reviews,
    );
  }
}

class Review {
  final String id;
  final String userId;
  final String userName;
  final double rating;
  final String comment;
  final DateTime date;

  Review({
    required this.id,
    required this.userId,
    required this.userName,
    required this.rating,
    required this.comment,
    required this.date,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      userName: json['userName'] ?? '',
      rating: (json['rating'] ?? 0.0).toDouble(),
      comment: json['comment'] ?? '',
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'rating': rating,
      'comment': comment,
      'date': date.toIso8601String(),
    };
  }
}
