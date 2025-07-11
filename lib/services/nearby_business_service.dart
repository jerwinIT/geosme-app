import 'dart:math';
import '../models/business.dart';
import '../data/dummy_data.dart';

class NearbyBusinessService {
  // Haversine formula to calculate distance between two points
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

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }

  static double _degreesToRadians(double degrees) {
    return degrees * (pi / 180);
  }

  // Find nearby businesses within specified radius
  static List<Business> findNearbyBusinesses(
    Business targetBusiness,
    double radiusKm, {
    String? categoryFilter,
  }) {
    List<Business> nearbyBusinesses = [];

    for (Business business in dummyBusinesses) {
      // Skip the target business itself
      if (business.id == targetBusiness.id) continue;

      // Calculate distance
      double distance = _calculateDistance(
        targetBusiness.latitude,
        targetBusiness.longitude,
        business.latitude,
        business.longitude,
      );

      // Check if within radius
      if (distance <= radiusKm) {
        // Apply category filter if specified
        if (categoryFilter == null || business.category == categoryFilter) {
          nearbyBusinesses.add(business);
        }
      }
    }

    // Sort by distance (closest first)
    nearbyBusinesses.sort((a, b) {
      double distanceA = _calculateDistance(
        targetBusiness.latitude,
        targetBusiness.longitude,
        a.latitude,
        a.longitude,
      );
      double distanceB = _calculateDistance(
        targetBusiness.latitude,
        targetBusiness.longitude,
        b.latitude,
        b.longitude,
      );
      return distanceA.compareTo(distanceB);
    });

    return nearbyBusinesses;
  }

  // Get competitor analysis insights
  static Map<String, dynamic> getCompetitorInsights(
    Business targetBusiness,
    double radiusKm,
  ) {
    List<Business> nearbyBusinesses = findNearbyBusinesses(
      targetBusiness,
      radiusKm,
      categoryFilter: targetBusiness.category,
    );

    if (nearbyBusinesses.isEmpty) {
      return {
        'competitorCount': 0,
        'avgRating': 0.0,
        'avgPriceRange': 'N/A',
        'marketSaturation': 'Low',
        'competitivePressure': 'Low',
        'opportunityLevel': 'High',
      };
    }

    // Calculate insights
    double avgRating =
        nearbyBusinesses.map((b) => b.rating).reduce((a, b) => a + b) /
        nearbyBusinesses.length;

    // Analyze price ranges
    List<String> priceRanges = nearbyBusinesses
        .map((b) => b.priceRange)
        .toList();
    String mostCommonPriceRange = _getMostCommonPriceRange(priceRanges);

    // Determine market saturation
    String marketSaturation = _determineMarketSaturation(
      nearbyBusinesses.length,
      radiusKm,
    );

    // Determine competitive pressure
    String competitivePressure = _determineCompetitivePressure(
      avgRating,
      targetBusiness.rating,
    );

    // Determine opportunity level
    String opportunityLevel = _determineOpportunityLevel(
      marketSaturation,
      competitivePressure,
    );

    return {
      'competitorCount': nearbyBusinesses.length,
      'avgRating': avgRating,
      'avgPriceRange': mostCommonPriceRange,
      'marketSaturation': marketSaturation,
      'competitivePressure': competitivePressure,
      'opportunityLevel': opportunityLevel,
      'nearbyBusinesses': nearbyBusinesses,
    };
  }

  static String _getMostCommonPriceRange(List<String> priceRanges) {
    Map<String, int> frequency = {};
    for (String range in priceRanges) {
      frequency[range] = (frequency[range] ?? 0) + 1;
    }

    String mostCommon = priceRanges.first;
    int maxCount = 0;

    frequency.forEach((range, count) {
      if (count > maxCount) {
        maxCount = count;
        mostCommon = range;
      }
    });

    return mostCommon;
  }

  static String _determineMarketSaturation(
    int competitorCount,
    double radiusKm,
  ) {
    double density = competitorCount / (pi * radiusKm * radiusKm);

    if (density > 2.0) return 'Very High';
    if (density > 1.0) return 'High';
    if (density > 0.5) return 'Medium';
    return 'Low';
  }

  static String _determineCompetitivePressure(
    double avgCompetitorRating,
    double targetRating,
  ) {
    double difference = targetRating - avgCompetitorRating;

    if (difference > 1.0) return 'Low';
    if (difference > 0.5) return 'Medium';
    if (difference > -0.5) return 'High';
    return 'Very High';
  }

  static String _determineOpportunityLevel(
    String marketSaturation,
    String competitivePressure,
  ) {
    if (marketSaturation == 'Low' && competitivePressure == 'Low') {
      return 'Very High';
    }
    if (marketSaturation == 'Low' || competitivePressure == 'Low') {
      return 'High';
    }
    if (marketSaturation == 'Medium' && competitivePressure == 'Medium') {
      return 'Medium';
    }
    return 'Low';
  }
}
