import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import 'sme_type_analytics_screen.dart';
import 'geographic_analytics_screen.dart';
import 'hotspot_analytics_screen.dart';
import 'user_engagement_analytics_screen.dart';
import 'opportunity_zones_analytics_screen.dart';
import 'comparative_analytics_screen.dart';
import 'accessibility_analytics_screen.dart';

class AnalyticsNavigationScreen extends StatelessWidget {
  const AnalyticsNavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics Dashboard'),
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Comprehensive Analytics',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Explore detailed insights about SMEs in Batangas',
              style: TextStyle(fontSize: 16, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 24),
            _buildAnalyticsGrid(context),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalyticsGrid(BuildContext context) {
    final analyticsItems = [
      {
        'title': 'SME Type Distribution',
        'subtitle': 'Category analysis and business types',
        'icon': Icons.category,
        'color': AppColors.primary,
        'screen': const SmeTypeAnalyticsScreen(),
      },
      {
        'title': 'Geographic Concentration',
        'subtitle': 'Business density and location analysis',
        'icon': Icons.map,
        'color': AppColors.success,
        'screen': const GeographicAnalyticsScreen(),
      },
      {
        'title': 'Business Hotspots',
        'subtitle': 'Clusters and concentration areas',
        'icon': Icons.location_on,
        'color': AppColors.warning,
        'screen': const HotspotAnalyticsScreen(),
      },
      {
        'title': 'User Engagement',
        'subtitle': 'User interaction and activity metrics',
        'icon': Icons.people,
        'color': AppColors.info,
        'screen': const UserEngagementAnalyticsScreen(),
      },
      {
        'title': 'Opportunity Zones',
        'subtitle': 'Market gaps and business opportunities',
        'icon': Icons.trending_up,
        'color': AppColors.success,
        'screen': const OpportunityZonesAnalyticsScreen(),
      },
      {
        'title': 'Comparative Analytics',
        'subtitle': 'Municipality and category comparisons',
        'icon': Icons.compare_arrows,
        'color': AppColors.primary,
        'screen': const ComparativeAnalyticsScreen(),
      },
      {
        'title': 'Accessibility & Proximity',
        'subtitle': 'Location-based accessibility analysis',
        'icon': Icons.route,
        'color': AppColors.warning,
        'screen': const AccessibilityAnalyticsScreen(),
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.2,
      ),
      itemCount: analyticsItems.length,
      itemBuilder: (context, index) {
        final item = analyticsItems[index];
        return _buildAnalyticsCard(context, item);
      },
    );
  }

  Widget _buildAnalyticsCard(BuildContext context, Map<String, dynamic> item) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => item['screen']),
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                item['color'].withOpacity(0.1),
                item['color'].withOpacity(0.05),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: item['color'].withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(item['icon'], size: 32, color: item['color']),
              ),
              const SizedBox(height: 16),
              Text(
                item['title'],
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                item['subtitle'],
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
