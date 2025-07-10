import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../models/analytics.dart';
import '../services/analytics_service.dart';

class AccessibilityAnalyticsScreen extends StatefulWidget {
  const AccessibilityAnalyticsScreen({super.key});

  @override
  State<AccessibilityAnalyticsScreen> createState() =>
      _AccessibilityAnalyticsScreenState();
}

class _AccessibilityAnalyticsScreenState
    extends State<AccessibilityAnalyticsScreen> {
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
        title: const Text('Accessibility & Proximity'),
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
            _buildOverviewCard(),
            const SizedBox(height: 16),
            _buildProximityStats(),
            const SizedBox(height: 16),
            _buildMostAccessibleAreas(),
            const SizedBox(height: 16),
            _buildLeastAccessibleAreas(),
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
            colors: [AppColors.warning, Color(0xFFF57C00)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.route, color: Colors.white, size: 32),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Accessibility & Proximity',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Location-based accessibility analysis',
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
                  'Near Highways',
                  analytics.accessibility.totalBusinessesNearHighways
                      .toString(),
                  Icons.route,
                ),
                _buildStatItem(
                  'Near Schools',
                  analytics.accessibility.totalBusinessesNearSchools.toString(),
                  Icons.school,
                ),
                _buildStatItem(
                  'Tourist Zones',
                  analytics.accessibility.totalBusinessesNearTouristZones
                      .toString(),
                  Icons.attractions,
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

  Widget _buildProximityStats() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Proximity Statistics',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildProximityItem(
                    'Transport Hubs',
                    analytics.accessibility.totalBusinessesNearTransportHubs
                        .toString(),
                    Icons.directions_bus,
                    AppColors.info,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildProximityItem(
                    'Highways',
                    analytics.accessibility.totalBusinessesNearHighways
                        .toString(),
                    Icons.route,
                    AppColors.success,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildProximityItem(
                    'Schools',
                    analytics.accessibility.totalBusinessesNearSchools
                        .toString(),
                    Icons.school,
                    AppColors.primary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildProximityItem(
                    'Tourist Zones',
                    analytics.accessibility.totalBusinessesNearTouristZones
                        .toString(),
                    Icons.attractions,
                    AppColors.warning,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProximityItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMostAccessibleAreas() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Most Accessible Municipalities',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            ...analytics.accessibility.mostAccessibleMunicipalities.map((
              municipality,
            ) {
              final score =
                  analytics
                      .accessibility
                      .municipalityAccessibility[municipality] ??
                  0;
              return ListTile(
                leading: const Icon(
                  Icons.check_circle,
                  color: AppColors.success,
                ),
                title: Text(municipality),
                subtitle: Text('$score accessibility points'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildLeastAccessibleAreas() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Least Accessible Municipalities',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Areas needing infrastructure improvement',
              style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 12),
            ...analytics.accessibility.leastAccessibleMunicipalities.map((
              municipality,
            ) {
              final score =
                  analytics
                      .accessibility
                      .municipalityAccessibility[municipality] ??
                  0;
              return ListTile(
                leading: const Icon(Icons.warning, color: AppColors.warning),
                title: Text(municipality),
                subtitle: Text('$score accessibility points'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
