import 'dart:math';
import '../models/business.dart';
import '../models/analytics.dart';
import '../data/dummy_data.dart';

class AnalyticsService {
  static BusinessAnalytics generateAnalytics() {
    final businesses = dummyBusinesses;

    // Calculate category counts and ratings
    Map<String, int> categoryCount = {};
    Map<String, double> categoryRatings = {};
    Map<String, int> categoryReviewCounts = {};

    for (var business in businesses) {
      categoryCount[business.category] =
          (categoryCount[business.category] ?? 0) + 1;
      categoryRatings[business.category] =
          (categoryRatings[business.category] ?? 0) + business.rating;
      categoryReviewCounts[business.category] =
          (categoryReviewCounts[business.category] ?? 0) + business.reviewCount;
    }

    // Calculate average ratings
    Map<String, double> averageRatingByCategory = {};
    categoryCount.forEach((category, count) {
      averageRatingByCategory[category] = categoryRatings[category]! / count;
    });

    // Get top and least represented categories
    List<String> topCategories = _getTopCategories(categoryCount, 5);
    List<String> leastRepresentedCategories = _getLeastRepresentedCategories(
      categoryCount,
      3,
    );

    // Generate municipality data with enhanced metrics
    Map<String, MunicipalityData> municipalityData = _generateMunicipalityData(
      businesses,
    );

    // Generate hotspots
    List<BusinessHotspot> hotspots = _generateHotspots(businesses);

    // Generate opportunity zones
    List<OpportunityZone> opportunityZones = _generateOpportunityZones(
      businesses,
      municipalityData,
    );

    // Generate user engagement metrics
    UserEngagementMetrics userEngagement = _generateUserEngagementMetrics(
      businesses,
      categoryCount,
      averageRatingByCategory,
    );

    // Generate accessibility metrics
    AccessibilityMetrics accessibility = _generateAccessibilityMetrics(
      businesses,
      municipalityData,
    );

    // Generate market saturation data
    MarketSaturationData marketSaturation = _generateMarketSaturationData(
      businesses,
      municipalityData,
      categoryCount,
    );

    // Generate growth trends
    GrowthTrendsData growthTrends = _generateGrowthTrendsData(
      businesses,
      categoryCount,
      municipalityData,
    );

    // Generate comparative analytics
    ComparativeAnalytics comparativeAnalytics = _generateComparativeAnalytics(
      municipalityData,
      categoryCount,
      growthTrends,
    );

    return BusinessAnalytics(
      totalBusinesses: businesses.length,
      categoryCount: categoryCount,
      averageRatingByCategory: averageRatingByCategory,
      topCategories: topCategories,
      leastRepresentedCategories: leastRepresentedCategories,
      municipalityData: municipalityData,
      hotspots: hotspots,
      opportunityZones: opportunityZones,
      userEngagement: userEngagement,
      accessibility: accessibility,
      marketSaturation: marketSaturation,
      growthTrends: growthTrends,
      comparativeAnalytics: comparativeAnalytics,
    );
  }

  static List<String> _getTopCategories(
    Map<String, int> categoryCount,
    int count,
  ) {
    var sorted = categoryCount.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sorted.take(count).map((e) => e.key).toList();
  }

  static List<String> _getLeastRepresentedCategories(
    Map<String, int> categoryCount,
    int count,
  ) {
    var sorted = categoryCount.entries.toList()
      ..sort((a, b) => a.value.compareTo(b.value));
    return sorted.take(count).map((e) => e.key).toList();
  }

  static Map<String, MunicipalityData> _generateMunicipalityData(
    List<Business> businesses,
  ) {
    Map<String, List<Business>> businessesByMunicipality = {};

    for (var business in businesses) {
      if (!businessesByMunicipality.containsKey(business.municipality)) {
        businessesByMunicipality[business.municipality] = [];
      }
      businessesByMunicipality[business.municipality]!.add(business);
    }

    Map<String, MunicipalityData> municipalityData = {};

    // Define municipality areas (simplified)
    Map<String, double> municipalityAreas = {
      'Batangas City': 282.96,
      'Lipa City': 209.40,
      'Tanauan City': 107.83,
      'Santo Tomas': 95.41,
      'Malvar': 33.00,
      'Talisay': 28.20,
      'Laurel': 71.29,
      'Agoncillo': 49.96,
      'San Nicolas': 22.58,
      'Taal': 29.76,
      'Alitagtag': 24.76,
      'Cuenca': 58.18,
      'Mataas na Kahoy': 22.21,
      'Balete': 25.00,
      'San Jose': 53.29,
    };

    businessesByMunicipality.forEach((municipality, businessList) {
      Map<String, int> categoryDistribution = {};
      double avgLat = 0, avgLng = 0;

      for (var business in businessList) {
        categoryDistribution[business.category] =
            (categoryDistribution[business.category] ?? 0) + 1;
        avgLat += business.latitude;
        avgLng += business.longitude;
      }

      avgLat /= businessList.length;
      avgLng /= businessList.length;

      List<String> topCategories = _getTopCategories(categoryDistribution, 3);
      List<String> underservedCategories = _getLeastRepresentedCategories(
        categoryDistribution,
        2,
      );

      // Calculate accessibility metrics
      int businessesNearHighway = _countBusinessesNearHighway(businessList);
      int businessesNearSchools = _countBusinessesNearSchools(businessList);
      int businessesNearTouristZones = _countBusinessesNearTouristZones(
        businessList,
      );

      double areaKm2 = municipalityAreas[municipality] ?? 100.0;
      double density = businessList.length / areaKm2;

      municipalityData[municipality] = MunicipalityData(
        name: municipality,
        totalBusinesses: businessList.length,
        categoryDistribution: categoryDistribution,
        latitude: avgLat,
        longitude: avgLng,
        density: density,
        topCategories: topCategories,
        underservedCategories: underservedCategories,
        areaKm2: areaKm2,
        businessesNearHighway: businessesNearHighway,
        businessesNearSchools: businessesNearSchools,
        businessesNearTouristZones: businessesNearTouristZones,
      );
    });

    return municipalityData;
  }

  static int _countBusinessesNearHighway(List<Business> businesses) {
    // Simulate businesses near major highways (within 5km)
    return businesses.where((business) {
      // Major highways in Batangas: SLEX, STAR Tollway, Batangas-Tagaytay Road
      List<Map<String, double>> highways = [
        {'lat': 14.0583, 'lng': 121.0583}, // SLEX area
        {'lat': 14.1563, 'lng': 121.0583}, // STAR Tollway area
        {'lat': 13.7563, 'lng': 121.0583}, // Batangas City area
      ];

      return highways.any((highway) {
        double distance = _calculateDistance(
          business.latitude,
          business.longitude,
          highway['lat']!,
          highway['lng']!,
        );
        return distance <= 5.0; // Within 5km
      });
    }).length;
  }

  static int _countBusinessesNearSchools(List<Business> businesses) {
    // Simulate businesses near schools (within 2km)
    return businesses.where((business) {
      // Major schools in Batangas
      List<Map<String, double>> schools = [
        {'lat': 13.7563, 'lng': 121.0583}, // Batangas State University
        {'lat': 14.0583, 'lng': 121.0583}, // De La Salle Lipa
        {'lat': 14.1563, 'lng': 121.0583}, // University of Batangas
      ];

      return schools.any((school) {
        double distance = _calculateDistance(
          business.latitude,
          business.longitude,
          school['lat']!,
          school['lng']!,
        );
        return distance <= 2.0; // Within 2km
      });
    }).length;
  }

  static int _countBusinessesNearTouristZones(List<Business> businesses) {
    // Simulate businesses near tourist zones (within 3km)
    return businesses.where((business) {
      // Tourist spots in Batangas
      List<Map<String, double>> touristSpots = [
        {'lat': 13.7563, 'lng': 121.0583}, // Taal Volcano
        {'lat': 14.0583, 'lng': 121.0583}, // Lipa Cathedral
        {'lat': 14.1563, 'lng': 121.0583}, // Batangas City Plaza
      ];

      return touristSpots.any((spot) {
        double distance = _calculateDistance(
          business.latitude,
          business.longitude,
          spot['lat']!,
          spot['lng']!,
        );
        return distance <= 3.0; // Within 3km
      });
    }).length;
  }

  static List<BusinessHotspot> _generateHotspots(List<Business> businesses) {
    List<BusinessHotspot> hotspots = [];

    // Group businesses by category and municipality
    Map<String, List<Business>> categoryGroups = {};
    for (var business in businesses) {
      String key = '${business.category}_${business.municipality}';
      if (!categoryGroups.containsKey(key)) {
        categoryGroups[key] = [];
      }
      categoryGroups[key]!.add(business);
    }

    // Find clusters (3 or more businesses of same category in same municipality)
    categoryGroups.forEach((key, businessList) {
      if (businessList.length >= 3) {
        String category = businessList.first.category;
        String municipality = businessList.first.municipality;

        // Calculate average position
        double avgLat =
            businessList.map((b) => b.latitude).reduce((a, b) => a + b) /
            businessList.length;
        double avgLng =
            businessList.map((b) => b.longitude).reduce((a, b) => a + b) /
            businessList.length;

        hotspots.add(
          BusinessHotspot(
            name: '$category Cluster in $municipality',
            category: category,
            municipality: municipality,
            latitude: avgLat,
            longitude: avgLng,
            businessCount: businessList.length,
            density: businessList.length / 10.0,
            description:
                'High concentration of $category businesses in $municipality',
          ),
        );
      }
    });

    return hotspots;
  }

  static List<OpportunityZone> _generateOpportunityZones(
    List<Business> businesses,
    Map<String, MunicipalityData> municipalityData,
  ) {
    List<OpportunityZone> zones = [];

    // Find municipalities with low business density
    var sortedMunicipalities = municipalityData.entries.toList()
      ..sort(
        (a, b) => a.value.totalBusinesses.compareTo(b.value.totalBusinesses),
      );

    // Consider bottom 30% as potential opportunity zones
    int opportunityCount = (sortedMunicipalities.length * 0.3).round();
    var lowDensityMunicipalities = sortedMunicipalities.take(opportunityCount);

    for (var entry in lowDensityMunicipalities) {
      String municipality = entry.key;
      MunicipalityData data = entry.value;

      // Find underserved categories in this municipality
      for (String category in data.underservedCategories) {
        zones.add(
          OpportunityZone(
            municipality: municipality,
            category: category,
            description:
                'Opportunity for $category businesses in $municipality',
            latitude: data.latitude,
            longitude: data.longitude,
            currentBusinesses: data.categoryDistribution[category] ?? 0,
            potentialDemand: 5,
            reasons: [
              'Low business density in $municipality',
              'High demand for $category services',
              'Strategic location for business expansion',
            ],
          ),
        );
      }
    }

    return zones;
  }

  static UserEngagementMetrics _generateUserEngagementMetrics(
    List<Business> businesses,
    Map<String, int> categoryCount,
    Map<String, double> averageRatingByCategory,
  ) {
    // Simulate user engagement data
    Map<String, int> categoryViewCount = {};
    Map<String, int> categoryBookmarkCount = {};
    Map<String, double> categoryAverageRating = {};

    categoryCount.forEach((category, count) {
      // Simulate view count based on business count and popularity
      categoryViewCount[category] = count * (5 + Random().nextInt(10));
      categoryBookmarkCount[category] = (count * 0.3).round();
      categoryAverageRating[category] =
          averageRatingByCategory[category] ?? 0.0;
    });

    List<String> mostViewedCategories = _getTopCategories(categoryViewCount, 5);
    List<String> mostBookmarkedCategories = _getTopCategories(
      categoryBookmarkCount,
      5,
    );
    List<String> mostRatedCategories = _getTopCategories(
      categoryAverageRating.map((k, v) => MapEntry(k, (v * 100).round())),
      5,
    );

    // High interaction municipalities (based on business density and ratings)
    List<String> highInteractionMunicipalities = [
      'Batangas City',
      'Lipa City',
      'Tanauan City',
    ];

    return UserEngagementMetrics(
      mostViewedCategories: mostViewedCategories,
      mostBookmarkedCategories: mostBookmarkedCategories,
      mostRatedCategories: mostRatedCategories,
      highInteractionMunicipalities: highInteractionMunicipalities,
      categoryViewCount: categoryViewCount,
      categoryBookmarkCount: categoryBookmarkCount,
      categoryAverageRating: categoryAverageRating,
    );
  }

  static AccessibilityMetrics _generateAccessibilityMetrics(
    List<Business> businesses,
    Map<String, MunicipalityData> municipalityData,
  ) {
    int totalBusinessesNearHighways = 0;
    int totalBusinessesNearSchools = 0;
    int totalBusinessesNearTouristZones = 0;
    int totalBusinessesNearTransportHubs = 0;

    Map<String, int> municipalityAccessibility = {};

    municipalityData.forEach((municipality, data) {
      totalBusinessesNearHighways += data.businessesNearHighway;
      totalBusinessesNearSchools += data.businessesNearSchools;
      totalBusinessesNearTouristZones += data.businessesNearTouristZones;

      // Simulate transport hubs (bus terminals, jeepney stops)
      int transportHubs = (data.totalBusinesses * 0.2).round();
      totalBusinessesNearTransportHubs += transportHubs;

      municipalityAccessibility[municipality] =
          data.businessesNearHighway +
          data.businessesNearSchools +
          data.businessesNearTouristZones;
    });

    // Sort municipalities by accessibility
    var sortedAccessibility = municipalityAccessibility.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    List<String> mostAccessibleMunicipalities = sortedAccessibility
        .take(5)
        .map((e) => e.key)
        .toList();
    List<String> leastAccessibleMunicipalities = sortedAccessibility.reversed
        .take(5)
        .map((e) => e.key)
        .toList();

    return AccessibilityMetrics(
      totalBusinessesNearHighways: totalBusinessesNearHighways,
      totalBusinessesNearSchools: totalBusinessesNearSchools,
      totalBusinessesNearTouristZones: totalBusinessesNearTouristZones,
      totalBusinessesNearTransportHubs: totalBusinessesNearTransportHubs,
      municipalityAccessibility: municipalityAccessibility,
      mostAccessibleMunicipalities: mostAccessibleMunicipalities,
      leastAccessibleMunicipalities: leastAccessibleMunicipalities,
    );
  }

  static MarketSaturationData _generateMarketSaturationData(
    List<Business> businesses,
    Map<String, MunicipalityData> municipalityData,
    Map<String, int> categoryCount,
  ) {
    Map<String, double> categorySaturationLevels = {};
    Map<String, double> municipalitySaturation = {};

    // Calculate category saturation (based on business count vs potential market)
    int totalBusinesses = businesses.length;
    categoryCount.forEach((category, count) {
      double saturation = (count / totalBusinesses) * 100;
      categorySaturationLevels[category] = saturation;
    });

    // Calculate municipality saturation (based on density)
    municipalityData.forEach((municipality, data) {
      double saturation = (data.density / 2.0) * 100; // Normalize to percentage
      municipalitySaturation[municipality] = saturation.clamp(0.0, 100.0);
    });

    // Identify saturated and unsaturated categories
    var sortedCategories = categorySaturationLevels.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    List<String> saturatedCategories = sortedCategories
        .where((e) => e.value > 15.0) // More than 15% market share
        .take(3)
        .map((e) => e.key)
        .toList();

    List<String> unsaturatedCategories = sortedCategories
        .where((e) => e.value < 5.0) // Less than 5% market share
        .take(3)
        .map((e) => e.key)
        .toList();

    // Identify saturated and unsaturated municipalities
    var sortedMunicipalities = municipalitySaturation.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    List<String> saturatedMunicipalities = sortedMunicipalities
        .where((e) => e.value > 50.0)
        .take(3)
        .map((e) => e.key)
        .toList();

    List<String> unsaturatedMunicipalities = sortedMunicipalities
        .where((e) => e.value < 20.0)
        .take(3)
        .map((e) => e.key)
        .toList();

    return MarketSaturationData(
      categorySaturationLevels: categorySaturationLevels,
      saturatedCategories: saturatedCategories,
      unsaturatedCategories: unsaturatedCategories,
      municipalitySaturation: municipalitySaturation,
      saturatedMunicipalities: saturatedMunicipalities,
      unsaturatedMunicipalities: unsaturatedMunicipalities,
    );
  }

  static GrowthTrendsData _generateGrowthTrendsData(
    List<Business> businesses,
    Map<String, int> categoryCount,
    Map<String, MunicipalityData> municipalityData,
  ) {
    Map<String, double> categoryGrowthRates = {};
    Map<String, double> municipalityGrowthRates = {};

    // Simulate growth rates for categories
    categoryCount.forEach((category, count) {
      double growthRate = (Random().nextDouble() * 20) - 5; // -5% to +15%
      categoryGrowthRates[category] = growthRate;
    });

    // Simulate growth rates for municipalities
    municipalityData.forEach((municipality, data) {
      double growthRate = (Random().nextDouble() * 25) - 5; // -5% to +20%
      municipalityGrowthRates[municipality] = growthRate;
    });

    // Get fastest growing categories and municipalities
    var sortedCategories = categoryGrowthRates.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    var sortedMunicipalities = municipalityGrowthRates.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    List<String> fastestGrowingCategories = sortedCategories
        .take(5)
        .map((e) => e.key)
        .toList();
    List<String> fastestGrowingMunicipalities = sortedMunicipalities
        .take(5)
        .map((e) => e.key)
        .toList();

    // Generate monthly and quarterly trends
    Map<String, List<double>> monthlyTrends = {};
    Map<String, List<double>> quarterlyTrends = {};

    categoryCount.keys.take(5).forEach((category) {
      monthlyTrends[category] = List.generate(12, (index) {
        return 100 +
            (Random().nextDouble() * 20) -
            10; // Base 100 with variation
      });
      quarterlyTrends[category] = List.generate(4, (index) {
        return 100 + (Random().nextDouble() * 30) - 15;
      });
    });

    return GrowthTrendsData(
      categoryGrowthRates: categoryGrowthRates,
      municipalityGrowthRates: municipalityGrowthRates,
      fastestGrowingCategories: fastestGrowingCategories,
      fastestGrowingMunicipalities: fastestGrowingMunicipalities,
      monthlyTrends: monthlyTrends,
      quarterlyTrends: quarterlyTrends,
    );
  }

  static ComparativeAnalytics _generateComparativeAnalytics(
    Map<String, MunicipalityData> municipalityData,
    Map<String, int> categoryCount,
    GrowthTrendsData growthTrends,
  ) {
    Map<String, Map<String, double>> municipalityComparisons = {};
    List<MunicipalityComparison> topComparisons = [];

    // Generate municipality comparisons
    List<String> municipalities = municipalityData.keys.toList();
    for (int i = 0; i < municipalities.length; i++) {
      for (int j = i + 1; j < municipalities.length; j++) {
        String muni1 = municipalities[i];
        String muni2 = municipalities[j];

        MunicipalityData data1 = municipalityData[muni1]!;
        MunicipalityData data2 = municipalityData[muni2]!;

        double densityComparison = data1.density / data2.density;
        double growthComparison =
            growthTrends.municipalityGrowthRates[muni1]! /
            growthTrends.municipalityGrowthRates[muni2]!;

        municipalityComparisons['${muni1}_vs_$muni2'] = {
          'density': densityComparison,
          'growth': growthComparison,
          'accessibility':
              data1.businessesNearHighway / (data2.businessesNearHighway + 1),
        };

        // Add top comparisons
        if (topComparisons.length < 10) {
          topComparisons.add(
            MunicipalityComparison(
              municipality1: muni1,
              municipality2: muni2,
              category: 'Overall',
              comparisonValue: densityComparison,
              comparisonType: 'density',
            ),
          );
        }
      }
    }

    // Generate category concentration rankings
    Map<String, double> categoryConcentrationRankings = {};
    categoryCount.forEach((category, count) {
      double concentration = count / municipalityData.length;
      categoryConcentrationRankings[category] = concentration;
    });

    // Generate growth trend rankings
    Map<String, double> growthTrendRankings = {};
    growthTrends.categoryGrowthRates.forEach((category, rate) {
      growthTrendRankings[category] = rate;
    });

    return ComparativeAnalytics(
      municipalityComparisons: municipalityComparisons,
      topComparisons: topComparisons,
      categoryConcentrationRankings: categoryConcentrationRankings,
      growthTrendRankings: growthTrendRankings,
    );
  }

  static List<Business> getBusinessesByCategory(String category) {
    return dummyBusinesses
        .where((business) => business.category == category)
        .toList();
  }

  static List<Business> getBusinessesByMunicipality(String municipality) {
    return dummyBusinesses
        .where((business) => business.municipality == municipality)
        .toList();
  }

  static List<Business> getBusinessesNearby(
    double latitude,
    double longitude,
    double radiusKm,
  ) {
    return dummyBusinesses.where((business) {
      double distance = _calculateDistance(
        latitude,
        longitude,
        business.latitude,
        business.longitude,
      );
      return distance <= radiusKm;
    }).toList();
  }

  static double _calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const double earthRadius = 6371; // Earth's radius in kilometers

    double dLat = _degreesToRadians(lat2 - lat1);
    double dLon = _degreesToRadians(lon2 - lon1);

    double a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(_degreesToRadians(lat1)) *
            cos(_degreesToRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);

    double c = 2 * asin(sqrt(a));

    return earthRadius * c;
  }

  static double _degreesToRadians(double degrees) {
    return degrees * (3.14159265359 / 180);
  }

  static Map<String, int> getCategoryDistribution() {
    Map<String, int> distribution = {};
    for (var business in dummyBusinesses) {
      distribution[business.category] =
          (distribution[business.category] ?? 0) + 1;
    }
    return distribution;
  }

  static Map<String, double> getAverageRatingByCategory() {
    Map<String, List<double>> ratingsByCategory = {};

    for (var business in dummyBusinesses) {
      if (!ratingsByCategory.containsKey(business.category)) {
        ratingsByCategory[business.category] = [];
      }
      ratingsByCategory[business.category]!.add(business.rating);
    }

    Map<String, double> averageRatings = {};
    ratingsByCategory.forEach((category, ratings) {
      averageRatings[category] =
          ratings.reduce((a, b) => a + b) / ratings.length;
    });

    return averageRatings;
  }
}
