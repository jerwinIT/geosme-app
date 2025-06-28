import '../models/business.dart';

class BusinessFilterService {
  /// Get all unique categories from the business list
  static List<String> getCategories(List<Business> businesses) {
    final allCategories = businesses.map((b) => b.category).toSet().toList();
    allCategories.sort();
    return ['All', ...allCategories];
  }

  /// Filter businesses based on search query and category
  static List<Business> filterBusinesses({
    required List<Business> allBusinesses,
    required String searchQuery,
    required String selectedCategory,
  }) {
    List<Business> filtered = [];

    for (Business business in allBusinesses) {
      bool matchesCategory = false;
      bool matchesQuery = false;

      // Check category filter
      if (selectedCategory == 'All') {
        matchesCategory = true;
      } else {
        if (business.category == selectedCategory) {
          matchesCategory = true;
        } else {
          matchesCategory = false;
        }
      }

      // Check search query
      if (searchQuery.isEmpty) {
        matchesQuery = true;
      } else {
        String businessName = business.name.toLowerCase();
        String businessAddress = business.address.toLowerCase();

        if (businessName.contains(searchQuery) ||
            businessAddress.contains(searchQuery)) {
          matchesQuery = true;
        } else {
          matchesQuery = false;
        }
      }

      // Add business to filtered list if both conditions are met
      if (matchesCategory && matchesQuery) {
        filtered.add(business);
      }
    }

    return filtered;
  }

  /// Search businesses by name only
  static List<Business> searchByName({
    required List<Business> allBusinesses,
    required String searchQuery,
  }) {
    if (searchQuery.isEmpty) {
      return allBusinesses;
    }

    List<Business> filtered = [];
    String query = searchQuery.toLowerCase();

    for (Business business in allBusinesses) {
      if (business.name.toLowerCase().contains(query)) {
        filtered.add(business);
      }
    }

    return filtered;
  }

  /// Filter businesses by category only
  static List<Business> filterByCategory({
    required List<Business> allBusinesses,
    required String selectedCategory,
  }) {
    if (selectedCategory == 'All') {
      return allBusinesses;
    }

    List<Business> filtered = [];

    for (Business business in allBusinesses) {
      if (business.category == selectedCategory) {
        filtered.add(business);
      }
    }

    return filtered;
  }

  /// Get businesses sorted by rating (highest first)
  static List<Business> sortByRating(List<Business> businesses) {
    List<Business> sorted = List.from(businesses);
    sorted.sort((a, b) => b.rating.compareTo(a.rating));
    return sorted;
  }

  /// Get businesses sorted by name (alphabetical)
  static List<Business> sortByName(List<Business> businesses) {
    List<Business> sorted = List.from(businesses);
    sorted.sort((a, b) => a.name.compareTo(b.name));
    return sorted;
  }

  /// Get businesses sorted by price range (lowest first)
  static List<Business> sortByPrice(List<Business> businesses) {
    List<Business> sorted = List.from(businesses);
    sorted.sort((a, b) => a.priceRange.length.compareTo(b.priceRange.length));
    return sorted;
  }
}
