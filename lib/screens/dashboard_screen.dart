import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../constants/app_colors.dart';
import '../models/business.dart';
import '../models/analytics.dart';
import '../services/analytics_service.dart';
import '../data/dummy_data.dart';
import 'business_density_screen.dart';
import 'market_trends_screen.dart';
import 'competitor_analysis_screen.dart';
import 'sme_browse_screen.dart';
import 'bookmarks_screen.dart';
import 'analytics_navigation_screen.dart';
import '../services/navigation_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late BusinessAnalytics analytics;
  late List<Business> businesses;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      isLoading = true;
    });

    // Simulate loading time
    await Future.delayed(const Duration(milliseconds: 500));

    analytics = AnalyticsService.generateAnalytics();
    businesses = dummyBusinesses;

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'GeoSME Dashboard',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => NavigationService.smartPop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark, color: AppColors.primary),
            onPressed: () {
              NavigationService.navigateTo(
                context,
                const BookmarksScreen(),
                routeName: 'bookmarks',
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.primary),
            onPressed: _loadData,
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadData,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildWelcomeCard(),
                    const SizedBox(height: 16),
                    _buildQuickStats(),
                    const SizedBox(height: 16),
                    _buildCategoryDistributionChart(),
                    const SizedBox(height: 16),
                    _buildTopCategoriesCard(),
                    const SizedBox(height: 16),
                    _buildMunicipalityDensityCard(),
                    const SizedBox(height: 16),
                    _buildHotspotsCard(),
                    const SizedBox(height: 16),
                    _buildOpportunityZonesCard(),
                    const SizedBox(height: 16),
                    _buildAnalyticsOverviewCard(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildWelcomeCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: const LinearGradient(
            colors: [AppColors.primary, Color(0xFFb05a1a)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.analytics, color: Colors.white, size: 32),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Batangas SME Analytics',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${analytics.totalBusinesses} businesses across ${analytics.municipalityData.length} municipalities',
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
                  'Total SMEs',
                  analytics.totalBusinesses.toString(),
                  Icons.business,
                ),
                _buildStatItem(
                  'Categories',
                  analytics.categoryCount.length.toString(),
                  Icons.category,
                ),
                _buildStatItem(
                  'Municipalities',
                  analytics.municipalityData.length.toString(),
                  Icons.location_city,
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
            fontSize: 18,
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

  Widget _buildQuickStats() {
    return Row(
      children: [
        Expanded(
          child: _buildQuickStatCard(
            'Top Category',
            analytics.topCategories.isNotEmpty
                ? analytics.topCategories.first
                : 'N/A',
            Icons.trending_up,
            AppColors.success,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildQuickStatCard(
            'Avg Rating',
            analytics.averageRatingByCategory.values.isNotEmpty
                ? (analytics.averageRatingByCategory.values.reduce(
                            (a, b) => a + b,
                          ) /
                          analytics.averageRatingByCategory.length)
                      .toStringAsFixed(1)
                : '0.0',
            Icons.star,
            AppColors.warning,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              title,
              style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryDistributionChart() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Business Category Distribution',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MarketTrendsScreen(),
                      ),
                    );
                  },
                  child: const Text('View Details'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: _buildPieChartSections(),
                  centerSpaceRadius: 40,
                  sectionsSpace: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> _buildPieChartSections() {
    final colors = [
      AppColors.primary,
      AppColors.success,
      AppColors.warning,
      AppColors.info,
      AppColors.error,
      const Color(0xFF9C27B0),
    ];

    return analytics.categoryCount.entries.map((entry) {
      final index = analytics.categoryCount.keys.toList().indexOf(entry.key);
      final percentage = (entry.value / analytics.totalBusinesses * 100)
          .round();

      return PieChartSectionData(
        color: colors[index % colors.length],
        value: entry.value.toDouble(),
        title: '$percentage%',
        radius: 60,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  Widget _buildTopCategoriesCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Top Business Categories',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            ...analytics.topCategories.asMap().entries.map((entry) {
              final index = entry.key;
              final category = entry.value;
              final count = analytics.categoryCount[category] ?? 0;

              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.primary.withOpacity(0.1),
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text(category),
                subtitle: Text('$count businesses'),
                trailing: Text(
                  '${(count / analytics.totalBusinesses * 100).round()}%',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildMunicipalityDensityCard() {
    final sortedMunicipalities = analytics.municipalityData.entries.toList()
      ..sort(
        (a, b) => b.value.totalBusinesses.compareTo(a.value.totalBusinesses),
      );

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Municipality Business Density',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BusinessDensityScreen(),
                      ),
                    );
                  },
                  child: const Text('View Map'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...sortedMunicipalities.take(5).map((entry) {
              final municipality = entry.key;
              final data = entry.value;

              return ListTile(
                leading: const Icon(
                  Icons.location_city,
                  color: AppColors.primary,
                ),
                title: Text(municipality),
                subtitle: Text('${data.totalBusinesses} businesses'),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${data.density.toStringAsFixed(1)}/km²',
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildHotspotsCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Business Hotspots',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Map functionality coming soon!'),
                        backgroundColor: AppColors.info,
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  child: const Text('View Analysis'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...analytics.hotspots.take(3).map((hotspot) {
              return ListTile(
                leading: const Icon(
                  Icons.location_on,
                  color: AppColors.warning,
                ),
                title: Text(hotspot.name),
                subtitle: Text('${hotspot.businessCount} businesses'),
                trailing: Text(
                  '${hotspot.density.toStringAsFixed(1)}/km²',
                  style: const TextStyle(
                    color: AppColors.warning,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildOpportunityZonesCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Opportunity Zones',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            ...analytics.opportunityZones.take(3).map((zone) {
              return ListTile(
                leading: const Icon(
                  Icons.trending_up,
                  color: AppColors.success,
                ),
                title: Text('${zone.category} in ${zone.municipality}'),
                subtitle: Text(
                  '${zone.currentBusinesses} current, ${zone.potentialDemand} potential',
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  // Navigate to opportunity details
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalyticsOverviewCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Analytics Overview',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    NavigationService.navigateTo(
                      context,
                      const AnalyticsNavigationScreen(),
                      routeName: 'analytics',
                    );
                  },
                  child: const Text('View All Analytics'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildOverviewStat(
                    'Total SMEs',
                    analytics.totalBusinesses.toString(),
                    Icons.business,
                    AppColors.primary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildOverviewStat(
                    'Avg Rating',
                    analytics.averageRatingByCategory.values.isNotEmpty
                        ? (analytics.averageRatingByCategory.values.reduce(
                                    (a, b) => a + b,
                                  ) /
                                  analytics.averageRatingByCategory.length)
                              .toStringAsFixed(1)
                        : '0.0',
                    Icons.star,
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

  Widget _buildOverviewStat(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
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
          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textSecondary,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Browse'),
        BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Map'),
        BottomNavigationBarItem(
          icon: Icon(Icons.analytics),
          label: 'Analytics',
        ),
      ],
      onTap: (index) {
        switch (index) {
          case 1:
            NavigationService.navigateTo(
              context,
              const SmeBrowseScreen(),
              routeName: 'sme_browse',
            );
            break;
          case 2:
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Map functionality coming soon!'),
                backgroundColor: AppColors.info,
                duration: Duration(seconds: 2),
              ),
            );
            break;
          case 3:
            NavigationService.navigateTo(
              context,
              const AnalyticsNavigationScreen(),
              routeName: 'analytics',
            );
            break;
        }
      },
    );
  }
}
