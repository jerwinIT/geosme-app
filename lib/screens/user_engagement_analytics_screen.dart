import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../models/analytics.dart';
import '../services/analytics_service.dart';
import '../services/navigation_service.dart';

class UserEngagementAnalyticsScreen extends StatefulWidget {
  const UserEngagementAnalyticsScreen({super.key});

  @override
  State<UserEngagementAnalyticsScreen> createState() =>
      _UserEngagementAnalyticsScreenState();
}

class _UserEngagementAnalyticsScreenState
    extends State<UserEngagementAnalyticsScreen> {
  late BusinessAnalytics analytics;

  @override
  void initState() {
    super.initState();
    analytics = AnalyticsService.generateAnalytics();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Engagement'),
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => NavigationService.smartPop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOverviewCard(),
            const SizedBox(height: 16),
            _buildMostViewedCategories(),
            const SizedBox(height: 16),
            _buildMostBookmarkedCategories(),
            const SizedBox(height: 16),
            _buildHighInteractionAreas(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: const LinearGradient(
            colors: [AppColors.info, Color(0xFF1976D2)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.people, color: Colors.white, size: 32),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'User Engagement Metrics',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'User interaction and activity patterns',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  'Most Viewed',
                  analytics.userEngagement.mostViewedCategories.length
                      .toString(),
                  Icons.visibility,
                ),
                _buildStatItem(
                  'Most Bookmarked',
                  analytics.userEngagement.mostBookmarkedCategories.length
                      .toString(),
                  Icons.bookmark,
                ),
                _buildStatItem(
                  'High Interaction',
                  analytics.userEngagement.highInteractionMunicipalities.length
                      .toString(),
                  Icons.location_on,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildMostViewedCategories() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Most Viewed Categories',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            ...analytics.userEngagement.mostViewedCategories.map((category) {
              final viewCount =
                  analytics.userEngagement.categoryViewCount[category] ?? 0;
              return ListTile(
                leading: const Icon(Icons.visibility, color: AppColors.info),
                title: Text(category),
                subtitle: Text('$viewCount views'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildMostBookmarkedCategories() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Most Bookmarked Categories',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            ...analytics.userEngagement.mostBookmarkedCategories.map((
              category,
            ) {
              final bookmarkCount =
                  analytics.userEngagement.categoryBookmarkCount[category] ?? 0;
              return ListTile(
                leading: const Icon(Icons.bookmark, color: AppColors.warning),
                title: Text(category),
                subtitle: Text('$bookmarkCount bookmarks'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildHighInteractionAreas() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'High Interaction Municipalities',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            ...analytics.userEngagement.highInteractionMunicipalities.map((
              municipality,
            ) {
              return ListTile(
                leading: const Icon(
                  Icons.location_on,
                  color: AppColors.success,
                ),
                title: Text(municipality),
                subtitle: const Text('High user activity'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              );
            }),
          ],
        ),
      ),
    );
  }
}
