import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/business.dart';

class BookmarkService {
  static const String _bookmarksKey = 'bookmarked_businesses';
  static const String _userPreferencesKey = 'user_preferences';

  // Get bookmarked businesses
  static Future<List<String>> getBookmarkedBusinessIds() async {
    final prefs = await SharedPreferences.getInstance();
    final bookmarksJson = prefs.getStringList(_bookmarksKey) ?? [];
    return bookmarksJson;
  }

  // Add business to bookmarks
  static Future<bool> addBookmark(String businessId) async {
    final prefs = await SharedPreferences.getInstance();
    final bookmarks = await getBookmarkedBusinessIds();

    if (!bookmarks.contains(businessId)) {
      bookmarks.add(businessId);
      return await prefs.setStringList(_bookmarksKey, bookmarks);
    }
    return true;
  }

  // Remove business from bookmarks
  static Future<bool> removeBookmark(String businessId) async {
    final prefs = await SharedPreferences.getInstance();
    final bookmarks = await getBookmarkedBusinessIds();

    bookmarks.remove(businessId);
    return await prefs.setStringList(_bookmarksKey, bookmarks);
  }

  // Check if business is bookmarked
  static Future<bool> isBookmarked(String businessId) async {
    final bookmarks = await getBookmarkedBusinessIds();
    return bookmarks.contains(businessId);
  }

  // Get bookmarked businesses with full data
  static Future<List<Business>> getBookmarkedBusinesses(
    List<Business> allBusinesses,
  ) async {
    final bookmarkedIds = await getBookmarkedBusinessIds();
    return allBusinesses
        .where((business) => bookmarkedIds.contains(business.id))
        .toList();
  }

  // Toggle bookmark status
  static Future<bool> toggleBookmark(String businessId) async {
    final isCurrentlyBookmarked = await isBookmarked(businessId);

    if (isCurrentlyBookmarked) {
      return await removeBookmark(businessId);
    } else {
      return await addBookmark(businessId);
    }
  }

  // Clear all bookmarks
  static Future<bool> clearAllBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.remove(_bookmarksKey);
  }

  // Get bookmark count
  static Future<int> getBookmarkCount() async {
    final bookmarks = await getBookmarkedBusinessIds();
    return bookmarks.length;
  }
}

class UserPreferences {
  final String? selectedMunicipality;
  final List<String> preferredCategories;
  final double? userLatitude;
  final double? userLongitude;
  final bool notificationsEnabled;
  final String themePreference; // 'light', 'dark', 'system'

  UserPreferences({
    this.selectedMunicipality,
    this.preferredCategories = const [],
    this.userLatitude,
    this.userLongitude,
    this.notificationsEnabled = true,
    this.themePreference = 'system',
  });

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      selectedMunicipality: json['selectedMunicipality'],
      preferredCategories: List<String>.from(json['preferredCategories'] ?? []),
      userLatitude: json['userLatitude']?.toDouble(),
      userLongitude: json['userLongitude']?.toDouble(),
      notificationsEnabled: json['notificationsEnabled'] ?? true,
      themePreference: json['themePreference'] ?? 'system',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'selectedMunicipality': selectedMunicipality,
      'preferredCategories': preferredCategories,
      'userLatitude': userLatitude,
      'userLongitude': userLongitude,
      'notificationsEnabled': notificationsEnabled,
      'themePreference': themePreference,
    };
  }

  UserPreferences copyWith({
    String? selectedMunicipality,
    List<String>? preferredCategories,
    double? userLatitude,
    double? userLongitude,
    bool? notificationsEnabled,
    String? themePreference,
  }) {
    return UserPreferences(
      selectedMunicipality: selectedMunicipality ?? this.selectedMunicipality,
      preferredCategories: preferredCategories ?? this.preferredCategories,
      userLatitude: userLatitude ?? this.userLatitude,
      userLongitude: userLongitude ?? this.userLongitude,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      themePreference: themePreference ?? this.themePreference,
    );
  }
}

class UserPreferencesService {
  static const String _preferencesKey = 'user_preferences';

  // Get user preferences
  static Future<UserPreferences> getUserPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final preferencesJson = prefs.getString(_preferencesKey);

    if (preferencesJson != null) {
      try {
        final Map<String, dynamic> json = jsonDecode(preferencesJson);
        return UserPreferences.fromJson(json);
      } catch (e) {
        // Return default preferences if parsing fails
        return UserPreferences();
      }
    }

    return UserPreferences();
  }

  // Save user preferences
  static Future<bool> saveUserPreferences(UserPreferences preferences) async {
    final prefs = await SharedPreferences.getInstance();
    final preferencesJson = jsonEncode(preferences.toJson());
    return await prefs.setString(_preferencesKey, preferencesJson);
  }

  // Update selected municipality
  static Future<bool> updateSelectedMunicipality(String? municipality) async {
    final preferences = await getUserPreferences();
    final updatedPreferences = preferences.copyWith(
      selectedMunicipality: municipality,
    );
    return await saveUserPreferences(updatedPreferences);
  }

  // Update preferred categories
  static Future<bool> updatePreferredCategories(List<String> categories) async {
    final preferences = await getUserPreferences();
    final updatedPreferences = preferences.copyWith(
      preferredCategories: categories,
    );
    return await saveUserPreferences(updatedPreferences);
  }

  // Update user location
  static Future<bool> updateUserLocation(
    double latitude,
    double longitude,
  ) async {
    final preferences = await getUserPreferences();
    final updatedPreferences = preferences.copyWith(
      userLatitude: latitude,
      userLongitude: longitude,
    );
    return await saveUserPreferences(updatedPreferences);
  }

  // Update notification settings
  static Future<bool> updateNotificationSettings(bool enabled) async {
    final preferences = await getUserPreferences();
    final updatedPreferences = preferences.copyWith(
      notificationsEnabled: enabled,
    );
    return await saveUserPreferences(updatedPreferences);
  }

  // Update theme preference
  static Future<bool> updateThemePreference(String theme) async {
    final preferences = await getUserPreferences();
    final updatedPreferences = preferences.copyWith(themePreference: theme);
    return await saveUserPreferences(updatedPreferences);
  }

  // Clear all user preferences
  static Future<bool> clearUserPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.remove(_preferencesKey);
  }
}
