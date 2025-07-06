import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class BusinessDensityScreen extends StatefulWidget {
  const BusinessDensityScreen({super.key});

  @override
  State<BusinessDensityScreen> createState() => _BusinessDensityScreenState();
}

class _BusinessDensityScreenState extends State<BusinessDensityScreen> {
  String selectedCategory = 'All';
  final List<String> categories = [
    'All',
    'Restaurants',
    'Retail',
    'Services',
    'Manufacturing',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Business Density'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          // Category Filter
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = category == selectedCategory;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        selectedCategory = category;
                      });
                    },
                    selectedColor: AppColors.primary,
                    checkmarkColor: AppColors.textOnPrimary,
                    labelStyle: TextStyle(
                      color: isSelected
                          ? AppColors.textOnPrimary
                          : AppColors.textPrimary,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                    backgroundColor: AppColors.surface,
                    side: BorderSide(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.borderLight,
                    ),
                  ),
                );
              },
            ),
          ),

          // Map Container
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Heatmap Legend
                  _buildLegend(),

                  const SizedBox(height: 16),

                  // Heatmap Visualization
                  _buildHeatmap(),

                  const SizedBox(height: 24),

                  // Density Statistics
                  _buildDensityStats(),

                  const SizedBox(height: 16),

                  // Top Areas
                  _buildTopAreas(),

                  const SizedBox(height: 16),

                  // Business Clusters
                  _buildBusinessClusters(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Density Legend',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: AppColors.success,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text('High Density'),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: AppColors.warning,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text('Medium Density'),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: AppColors.error,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text('Low Density'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeatmap() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Batangas Business Density Map',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),

            // Simplified heatmap grid
            Container(
              height: 300,
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.borderLight),
                borderRadius: BorderRadius.circular(8),
              ),
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 8,
                  crossAxisSpacing: 1,
                  mainAxisSpacing: 1,
                ),
                itemCount: 64,
                itemBuilder: (context, index) {
                  final density = _getDensityForIndex(index);
                  return Container(
                    decoration: BoxDecoration(
                      color: density.color,
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: Center(
                      child: Text(
                        '${density.count}',
                        style: const TextStyle(
                          fontSize: 8,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 12),

            // Map labels
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Batangas City', style: TextStyle(fontSize: 12)),
                const Text('Lipa City', style: TextStyle(fontSize: 12)),
                const Text('Tanauan', style: TextStyle(fontSize: 12)),
                const Text('San Jose', style: TextStyle(fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDensityStats() {
    final stats = _getDensityStats();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Density Statistics',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    'Total Businesses',
                    '${stats.totalBusinesses}',
                    Icons.business,
                    AppColors.primary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatItem(
                    'Avg. Density',
                    '${stats.averageDensity}/km²',
                    Icons.density_medium,
                    AppColors.info,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    'High Density Areas',
                    '${stats.highDensityAreas}',
                    Icons.location_on,
                    AppColors.success,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatItem(
                    'Coverage Area',
                    '${stats.coverageArea} km²',
                    Icons.map,
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

  Widget _buildStatItem(
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
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildTopAreas() {
    final topAreas = _getTopAreas();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Top Business Areas',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            ...topAreas.map((area) => _buildAreaItem(area)),
          ],
        ),
      ),
    );
  }

  Widget _buildAreaItem(AreaData area) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: area.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Icons.location_on, color: area.color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  area.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  '${area.businessCount} businesses',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${area.density}/km²',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: area.color,
                  fontSize: 14,
                ),
              ),
              Text(
                area.category,
                style: const TextStyle(
                  fontSize: 10,
                  color: AppColors.textLight,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBusinessClusters() {
    final clusters = _getBusinessClusters();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Business Clusters',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            ...clusters.map((cluster) => _buildClusterItem(cluster)),
          ],
        ),
      ),
    );
  }

  Widget _buildClusterItem(ClusterData cluster) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cluster.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: cluster.color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(cluster.icon, color: cluster.color, size: 20),
              const SizedBox(width: 8),
              Text(
                cluster.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const Spacer(),
              Text(
                '${cluster.businessCount} businesses',
                style: TextStyle(
                  color: cluster.color,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            cluster.description,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  DensityData _getDensityForIndex(int index) {
    // Simplified density calculation for demo
    if (index < 16) return DensityData(15, AppColors.success); // High density
    if (index < 32) return DensityData(8, AppColors.warning); // Medium density
    if (index < 48) return DensityData(3, AppColors.error); // Low density
    return DensityData(1, AppColors.borderLight); // Very low density
  }

  DensityStats _getDensityStats() {
    return DensityStats(
      totalBusinesses: 1247,
      averageDensity: 45,
      highDensityAreas: 8,
      coverageArea: 3165,
    );
  }

  List<AreaData> _getTopAreas() {
    return [
      AreaData('Batangas City Center', 156, 89, 'Mixed', AppColors.primary),
      AreaData('Lipa City Plaza', 134, 76, 'Retail', AppColors.success),
      AreaData('Tanauan Market', 98, 67, 'Food', AppColors.warning),
      AreaData('San Jose Industrial', 87, 54, 'Manufacturing', AppColors.info),
    ];
  }

  List<ClusterData> _getBusinessClusters() {
    return [
      ClusterData(
        'Food & Beverage Cluster',
        'Restaurants, cafes, and food services',
        45,
        Icons.restaurant,
        AppColors.primary,
      ),
      ClusterData(
        'Retail Hub',
        'Shopping centers and retail stores',
        38,
        Icons.shopping_cart,
        AppColors.success,
      ),
      ClusterData(
        'Service District',
        'Professional and personal services',
        32,
        Icons.miscellaneous_services,
        AppColors.info,
      ),
      ClusterData(
        'Industrial Zone',
        'Manufacturing and industrial businesses',
        28,
        Icons.factory,
        AppColors.warning,
      ),
    ];
  }
}

class DensityData {
  final int count;
  final Color color;

  DensityData(this.count, this.color);
}

class DensityStats {
  final int totalBusinesses;
  final int averageDensity;
  final int highDensityAreas;
  final int coverageArea;

  DensityStats({
    required this.totalBusinesses,
    required this.averageDensity,
    required this.highDensityAreas,
    required this.coverageArea,
  });
}

class AreaData {
  final String name;
  final int businessCount;
  final int density;
  final String category;
  final Color color;

  AreaData(
    this.name,
    this.businessCount,
    this.density,
    this.category,
    this.color,
  );
}

class ClusterData {
  final String name;
  final String description;
  final int businessCount;
  final IconData icon;
  final Color color;

  ClusterData(
    this.name,
    this.description,
    this.businessCount,
    this.icon,
    this.color,
  );
}
