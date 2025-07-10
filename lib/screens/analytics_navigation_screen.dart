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
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Analytics',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Choose an analytics view',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(child: _buildAnalyticsGrid(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalyticsGrid(BuildContext context) {
    final analyticsItems = [
      {
        'title': 'SME Types',
        'subtitle': 'Business categories',
        'icon': Icons.category,
        'color': AppColors.primary,
        'screen': const SmeTypeAnalyticsScreen(),
      },
      {
        'title': 'Geographic',
        'subtitle': 'Location analysis',
        'icon': Icons.map,
        'color': AppColors.success,
        'screen': const GeographicAnalyticsScreen(),
      },
      {
        'title': 'Hotspots',
        'subtitle': 'Business clusters',
        'icon': Icons.location_on,
        'color': AppColors.warning,
        'screen': const HotspotAnalyticsScreen(),
      },
      {
        'title': 'User Engagement',
        'subtitle': 'Activity metrics',
        'icon': Icons.people,
        'color': AppColors.info,
        'screen': const UserEngagementAnalyticsScreen(),
      },
      {
        'title': 'Opportunities',
        'subtitle': 'Market gaps',
        'icon': Icons.trending_up,
        'color': AppColors.success,
        'screen': const OpportunityZonesAnalyticsScreen(),
      },
      {
        'title': 'Compare',
        'subtitle': 'Analytics comparison',
        'icon': Icons.compare_arrows,
        'color': AppColors.primary,
        'screen': const ComparativeAnalyticsScreen(),
      },
      {
        'title': 'Accessibility',
        'subtitle': 'Proximity analysis',
        'icon': Icons.route,
        'color': AppColors.warning,
        'screen': const AccessibilityAnalyticsScreen(),
      },
    ];

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.1,
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
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => item['screen']),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: item['color'].withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(item['icon'], size: 32, color: item['color']),
              ),
              const SizedBox(height: 12),
              Text(
                item['title'],
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                item['subtitle'],
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
