class MunicipalityData {
  final String name;
  final int totalBusinesses;
  final Map<String, int> categoryDistribution;
  final double latitude;
  final double longitude;
  final double density; // businesses per km²
  final List<String> topCategories;
  final List<String> underservedCategories;
  final double areaKm2; // Municipality area in km²
  final int businessesNearHighway; // Within 5km of major roads
  final int businessesNearSchools; // Within 2km of schools
  final int businessesNearTouristZones; // Within 3km of tourist spots

  MunicipalityData({
    required this.name,
    required this.totalBusinesses,
    required this.categoryDistribution,
    required this.latitude,
    required this.longitude,
    required this.density,
    required this.topCategories,
    required this.underservedCategories,
    required this.areaKm2,
    required this.businessesNearHighway,
    required this.businessesNearSchools,
    required this.businessesNearTouristZones,
  });

  factory MunicipalityData.fromJson(Map<String, dynamic> json) {
    return MunicipalityData(
      name: json['name'] ?? '',
      totalBusinesses: json['totalBusinesses'] ?? 0,
      categoryDistribution: Map<String, int>.from(
        json['categoryDistribution'] ?? {},
      ),
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      density: (json['density'] ?? 0.0).toDouble(),
      topCategories: List<String>.from(json['topCategories'] ?? []),
      underservedCategories: List<String>.from(
        json['underservedCategories'] ?? [],
      ),
      areaKm2: (json['areaKm2'] ?? 100.0).toDouble(),
      businessesNearHighway: json['businessesNearHighway'] ?? 0,
      businessesNearSchools: json['businessesNearSchools'] ?? 0,
      businessesNearTouristZones: json['businessesNearTouristZones'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'totalBusinesses': totalBusinesses,
      'categoryDistribution': categoryDistribution,
      'latitude': latitude,
      'longitude': longitude,
      'density': density,
      'topCategories': topCategories,
      'underservedCategories': underservedCategories,
      'areaKm2': areaKm2,
      'businessesNearHighway': businessesNearHighway,
      'businessesNearSchools': businessesNearSchools,
      'businessesNearTouristZones': businessesNearTouristZones,
    };
  }
}

class BusinessAnalytics {
  final int totalBusinesses;
  final Map<String, int> categoryCount;
  final Map<String, double> averageRatingByCategory;
  final List<String> topCategories;
  final List<String> leastRepresentedCategories;
  final Map<String, MunicipalityData> municipalityData;
  final List<BusinessHotspot> hotspots;
  final List<OpportunityZone> opportunityZones;
  final UserEngagementMetrics userEngagement;
  final AccessibilityMetrics accessibility;
  final MarketSaturationData marketSaturation;
  final GrowthTrendsData growthTrends;
  final ComparativeAnalytics comparativeAnalytics;

  BusinessAnalytics({
    required this.totalBusinesses,
    required this.categoryCount,
    required this.averageRatingByCategory,
    required this.topCategories,
    required this.leastRepresentedCategories,
    required this.municipalityData,
    required this.hotspots,
    required this.opportunityZones,
    required this.userEngagement,
    required this.accessibility,
    required this.marketSaturation,
    required this.growthTrends,
    required this.comparativeAnalytics,
  });

  factory BusinessAnalytics.fromJson(Map<String, dynamic> json) {
    return BusinessAnalytics(
      totalBusinesses: json['totalBusinesses'] ?? 0,
      categoryCount: Map<String, int>.from(json['categoryCount'] ?? {}),
      averageRatingByCategory: Map<String, double>.from(
        json['averageRatingByCategory'] ?? {},
      ),
      topCategories: List<String>.from(json['topCategories'] ?? []),
      leastRepresentedCategories: List<String>.from(
        json['leastRepresentedCategories'] ?? [],
      ),
      municipalityData:
          (json['municipalityData'] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(key, MunicipalityData.fromJson(value)),
          ) ??
          {},
      hotspots:
          (json['hotspots'] as List<dynamic>?)
              ?.map((hotspot) => BusinessHotspot.fromJson(hotspot))
              .toList() ??
          [],
      opportunityZones:
          (json['opportunityZones'] as List<dynamic>?)
              ?.map((zone) => OpportunityZone.fromJson(zone))
              .toList() ??
          [],
      userEngagement: UserEngagementMetrics.fromJson(
        json['userEngagement'] ?? {},
      ),
      accessibility: AccessibilityMetrics.fromJson(json['accessibility'] ?? {}),
      marketSaturation: MarketSaturationData.fromJson(
        json['marketSaturation'] ?? {},
      ),
      growthTrends: GrowthTrendsData.fromJson(json['growthTrends'] ?? {}),
      comparativeAnalytics: ComparativeAnalytics.fromJson(
        json['comparativeAnalytics'] ?? {},
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalBusinesses': totalBusinesses,
      'categoryCount': categoryCount,
      'averageRatingByCategory': averageRatingByCategory,
      'topCategories': topCategories,
      'leastRepresentedCategories': leastRepresentedCategories,
      'municipalityData': municipalityData.map(
        (key, value) => MapEntry(key, value.toJson()),
      ),
      'hotspots': hotspots.map((hotspot) => hotspot.toJson()).toList(),
      'opportunityZones': opportunityZones
          .map((zone) => zone.toJson())
          .toList(),
      'userEngagement': userEngagement.toJson(),
      'accessibility': accessibility.toJson(),
      'marketSaturation': marketSaturation.toJson(),
      'growthTrends': growthTrends.toJson(),
      'comparativeAnalytics': comparativeAnalytics.toJson(),
    };
  }
}

class BusinessHotspot {
  final String name;
  final String category;
  final String municipality;
  final double latitude;
  final double longitude;
  final int businessCount;
  final double density;
  final String description;

  BusinessHotspot({
    required this.name,
    required this.category,
    required this.municipality,
    required this.latitude,
    required this.longitude,
    required this.businessCount,
    required this.density,
    required this.description,
  });

  factory BusinessHotspot.fromJson(Map<String, dynamic> json) {
    return BusinessHotspot(
      name: json['name'] ?? '',
      category: json['category'] ?? '',
      municipality: json['municipality'] ?? '',
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      businessCount: json['businessCount'] ?? 0,
      density: (json['density'] ?? 0.0).toDouble(),
      description: json['description'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'category': category,
      'municipality': municipality,
      'latitude': latitude,
      'longitude': longitude,
      'businessCount': businessCount,
      'density': density,
      'description': description,
    };
  }
}

class OpportunityZone {
  final String municipality;
  final String category;
  final String description;
  final double latitude;
  final double longitude;
  final int currentBusinesses;
  final int potentialDemand;
  final List<String> reasons;

  OpportunityZone({
    required this.municipality,
    required this.category,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.currentBusinesses,
    required this.potentialDemand,
    required this.reasons,
  });

  factory OpportunityZone.fromJson(Map<String, dynamic> json) {
    return OpportunityZone(
      municipality: json['municipality'] ?? '',
      category: json['category'] ?? '',
      description: json['description'] ?? '',
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      currentBusinesses: json['currentBusinesses'] ?? 0,
      potentialDemand: json['potentialDemand'] ?? 0,
      reasons: List<String>.from(json['reasons'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'municipality': municipality,
      'category': category,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'currentBusinesses': currentBusinesses,
      'potentialDemand': potentialDemand,
      'reasons': reasons,
    };
  }
}

class UserEngagementMetrics {
  final List<String> mostViewedCategories;
  final List<String> mostBookmarkedCategories;
  final List<String> mostRatedCategories;
  final List<String> highInteractionMunicipalities;
  final Map<String, int> categoryViewCount;
  final Map<String, int> categoryBookmarkCount;
  final Map<String, double> categoryAverageRating;

  UserEngagementMetrics({
    required this.mostViewedCategories,
    required this.mostBookmarkedCategories,
    required this.mostRatedCategories,
    required this.highInteractionMunicipalities,
    required this.categoryViewCount,
    required this.categoryBookmarkCount,
    required this.categoryAverageRating,
  });

  factory UserEngagementMetrics.fromJson(Map<String, dynamic> json) {
    return UserEngagementMetrics(
      mostViewedCategories: List<String>.from(
        json['mostViewedCategories'] ?? [],
      ),
      mostBookmarkedCategories: List<String>.from(
        json['mostBookmarkedCategories'] ?? [],
      ),
      mostRatedCategories: List<String>.from(json['mostRatedCategories'] ?? []),
      highInteractionMunicipalities: List<String>.from(
        json['highInteractionMunicipalities'] ?? [],
      ),
      categoryViewCount: Map<String, int>.from(json['categoryViewCount'] ?? {}),
      categoryBookmarkCount: Map<String, int>.from(
        json['categoryBookmarkCount'] ?? {},
      ),
      categoryAverageRating: Map<String, double>.from(
        json['categoryAverageRating'] ?? {},
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mostViewedCategories': mostViewedCategories,
      'mostBookmarkedCategories': mostBookmarkedCategories,
      'mostRatedCategories': mostRatedCategories,
      'highInteractionMunicipalities': highInteractionMunicipalities,
      'categoryViewCount': categoryViewCount,
      'categoryBookmarkCount': categoryBookmarkCount,
      'categoryAverageRating': categoryAverageRating,
    };
  }
}

class AccessibilityMetrics {
  final int totalBusinessesNearHighways;
  final int totalBusinessesNearSchools;
  final int totalBusinessesNearTouristZones;
  final int totalBusinessesNearTransportHubs;
  final Map<String, int> municipalityAccessibility;
  final List<String> mostAccessibleMunicipalities;
  final List<String> leastAccessibleMunicipalities;

  AccessibilityMetrics({
    required this.totalBusinessesNearHighways,
    required this.totalBusinessesNearSchools,
    required this.totalBusinessesNearTouristZones,
    required this.totalBusinessesNearTransportHubs,
    required this.municipalityAccessibility,
    required this.mostAccessibleMunicipalities,
    required this.leastAccessibleMunicipalities,
  });

  factory AccessibilityMetrics.fromJson(Map<String, dynamic> json) {
    return AccessibilityMetrics(
      totalBusinessesNearHighways: json['totalBusinessesNearHighways'] ?? 0,
      totalBusinessesNearSchools: json['totalBusinessesNearSchools'] ?? 0,
      totalBusinessesNearTouristZones:
          json['totalBusinessesNearTouristZones'] ?? 0,
      totalBusinessesNearTransportHubs:
          json['totalBusinessesNearTransportHubs'] ?? 0,
      municipalityAccessibility: Map<String, int>.from(
        json['municipalityAccessibility'] ?? {},
      ),
      mostAccessibleMunicipalities: List<String>.from(
        json['mostAccessibleMunicipalities'] ?? [],
      ),
      leastAccessibleMunicipalities: List<String>.from(
        json['leastAccessibleMunicipalities'] ?? [],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalBusinessesNearHighways': totalBusinessesNearHighways,
      'totalBusinessesNearSchools': totalBusinessesNearSchools,
      'totalBusinessesNearTouristZones': totalBusinessesNearTouristZones,
      'totalBusinessesNearTransportHubs': totalBusinessesNearTransportHubs,
      'municipalityAccessibility': municipalityAccessibility,
      'mostAccessibleMunicipalities': mostAccessibleMunicipalities,
      'leastAccessibleMunicipalities': leastAccessibleMunicipalities,
    };
  }
}

class MarketSaturationData {
  final Map<String, double> categorySaturationLevels;
  final List<String> saturatedCategories;
  final List<String> unsaturatedCategories;
  final Map<String, double> municipalitySaturation;
  final List<String> saturatedMunicipalities;
  final List<String> unsaturatedMunicipalities;

  MarketSaturationData({
    required this.categorySaturationLevels,
    required this.saturatedCategories,
    required this.unsaturatedCategories,
    required this.municipalitySaturation,
    required this.saturatedMunicipalities,
    required this.unsaturatedMunicipalities,
  });

  factory MarketSaturationData.fromJson(Map<String, dynamic> json) {
    return MarketSaturationData(
      categorySaturationLevels: Map<String, double>.from(
        json['categorySaturationLevels'] ?? {},
      ),
      saturatedCategories: List<String>.from(json['saturatedCategories'] ?? []),
      unsaturatedCategories: List<String>.from(
        json['unsaturatedCategories'] ?? [],
      ),
      municipalitySaturation: Map<String, double>.from(
        json['municipalitySaturation'] ?? {},
      ),
      saturatedMunicipalities: List<String>.from(
        json['saturatedMunicipalities'] ?? [],
      ),
      unsaturatedMunicipalities: List<String>.from(
        json['unsaturatedMunicipalities'] ?? [],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'categorySaturationLevels': categorySaturationLevels,
      'saturatedCategories': saturatedCategories,
      'unsaturatedCategories': unsaturatedCategories,
      'municipalitySaturation': municipalitySaturation,
      'saturatedMunicipalities': saturatedMunicipalities,
      'unsaturatedMunicipalities': unsaturatedMunicipalities,
    };
  }
}

class GrowthTrendsData {
  final Map<String, double> categoryGrowthRates;
  final Map<String, double> municipalityGrowthRates;
  final List<String> fastestGrowingCategories;
  final List<String> fastestGrowingMunicipalities;
  final Map<String, List<double>> monthlyTrends;
  final Map<String, List<double>> quarterlyTrends;

  GrowthTrendsData({
    required this.categoryGrowthRates,
    required this.municipalityGrowthRates,
    required this.fastestGrowingCategories,
    required this.fastestGrowingMunicipalities,
    required this.monthlyTrends,
    required this.quarterlyTrends,
  });

  factory GrowthTrendsData.fromJson(Map<String, dynamic> json) {
    return GrowthTrendsData(
      categoryGrowthRates: Map<String, double>.from(
        json['categoryGrowthRates'] ?? {},
      ),
      municipalityGrowthRates: Map<String, double>.from(
        json['municipalityGrowthRates'] ?? {},
      ),
      fastestGrowingCategories: List<String>.from(
        json['fastestGrowingCategories'] ?? [],
      ),
      fastestGrowingMunicipalities: List<String>.from(
        json['fastestGrowingMunicipalities'] ?? [],
      ),
      monthlyTrends:
          (json['monthlyTrends'] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(key, List<double>.from(value)),
          ) ??
          {},
      quarterlyTrends:
          (json['quarterlyTrends'] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(key, List<double>.from(value)),
          ) ??
          {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'categoryGrowthRates': categoryGrowthRates,
      'municipalityGrowthRates': municipalityGrowthRates,
      'fastestGrowingCategories': fastestGrowingCategories,
      'fastestGrowingMunicipalities': fastestGrowingMunicipalities,
      'monthlyTrends': monthlyTrends,
      'quarterlyTrends': quarterlyTrends,
    };
  }
}

class ComparativeAnalytics {
  final Map<String, Map<String, double>> municipalityComparisons;
  final List<MunicipalityComparison> topComparisons;
  final Map<String, double> categoryConcentrationRankings;
  final Map<String, double> growthTrendRankings;

  ComparativeAnalytics({
    required this.municipalityComparisons,
    required this.topComparisons,
    required this.categoryConcentrationRankings,
    required this.growthTrendRankings,
  });

  factory ComparativeAnalytics.fromJson(Map<String, dynamic> json) {
    return ComparativeAnalytics(
      municipalityComparisons:
          (json['municipalityComparisons'] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(key, Map<String, double>.from(value)),
          ) ??
          {},
      topComparisons:
          (json['topComparisons'] as List<dynamic>?)
              ?.map((comp) => MunicipalityComparison.fromJson(comp))
              .toList() ??
          [],
      categoryConcentrationRankings: Map<String, double>.from(
        json['categoryConcentrationRankings'] ?? {},
      ),
      growthTrendRankings: Map<String, double>.from(
        json['growthTrendRankings'] ?? {},
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'municipalityComparisons': municipalityComparisons,
      'topComparisons': topComparisons.map((comp) => comp.toJson()).toList(),
      'categoryConcentrationRankings': categoryConcentrationRankings,
      'growthTrendRankings': growthTrendRankings,
    };
  }
}

class MunicipalityComparison {
  final String municipality1;
  final String municipality2;
  final String category;
  final double comparisonValue;
  final String comparisonType; // density, growth, accessibility, etc.

  MunicipalityComparison({
    required this.municipality1,
    required this.municipality2,
    required this.category,
    required this.comparisonValue,
    required this.comparisonType,
  });

  factory MunicipalityComparison.fromJson(Map<String, dynamic> json) {
    return MunicipalityComparison(
      municipality1: json['municipality1'] ?? '',
      municipality2: json['municipality2'] ?? '',
      category: json['category'] ?? '',
      comparisonValue: (json['comparisonValue'] ?? 0.0).toDouble(),
      comparisonType: json['comparisonType'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'municipality1': municipality1,
      'municipality2': municipality2,
      'category': category,
      'comparisonValue': comparisonValue,
      'comparisonType': comparisonType,
    };
  }
}
