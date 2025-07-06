import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class MarketTrendsScreen extends StatefulWidget {
  const MarketTrendsScreen({super.key});

  @override
  State<MarketTrendsScreen> createState() => _MarketTrendsScreenState();
}

class _MarketTrendsScreenState extends State<MarketTrendsScreen> {
  String selectedTimeframe = '6 Months';
  final List<String> timeframes = ['1 Month', '3 Months', '6 Months', '1 Year'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Market Trends'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Timeframe Selector
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Market Trends',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                DropdownButton<String>(
                  value: selectedTimeframe,
                  items: timeframes.map((String timeframe) {
                    return DropdownMenuItem<String>(
                      value: timeframe,
                      child: Text(timeframe),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedTimeframe = newValue!;
                    });
                  },
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Growth Trends
            _buildSectionCard(
              'Growth Trends',
              'SME growth in Batangas over $selectedTimeframe',
              _buildGrowthTrends(),
            ),

            const SizedBox(height: 16),

            // Industry Performance
            _buildSectionCard(
              'Industry Performance',
              'Top performing industries',
              _buildIndustryPerformance(),
            ),

            const SizedBox(height: 16),

            // Revenue Trends
            _buildSectionCard(
              'Revenue Trends',
              'Average revenue by industry',
              _buildRevenueTrends(),
            ),

            const SizedBox(height: 16),

            // Market Opportunities
            _buildSectionCard(
              'Market Opportunities',
              'Emerging trends and opportunities',
              _buildMarketOpportunities(),
            ),

            const SizedBox(height: 16),

            // Regional Analysis
            _buildSectionCard(
              'Regional Analysis',
              'Performance by city/municipality',
              _buildRegionalAnalysis(),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard(String title, String subtitle, Widget content) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            content,
          ],
        ),
      ),
    );
  }

  Widget _buildGrowthTrends() {
    final trends = _getGrowthTrends();

    return Column(
      children: trends.map((trend) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  trend.metric,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Row(
                  children: [
                    Expanded(
                      child: LinearProgressIndicator(
                        value: trend.value / 100,
                        backgroundColor: AppColors.borderLight,
                        valueColor: AlwaysStoppedAnimation<Color>(trend.color),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${trend.value}%',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: trend.color,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildIndustryPerformance() {
    final industries = _getIndustryPerformance();

    return Column(
      children: industries.map((industry) {
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
                  color: industry.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(industry.icon, color: industry.color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      industry.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      '${industry.growth}% growth',
                      style: TextStyle(
                        color: industry.growth >= 0
                            ? AppColors.success
                            : AppColors.error,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '₱${industry.revenue}M',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildRevenueTrends() {
    final revenues = _getRevenueTrends();

    return Column(
      children: revenues.map((revenue) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  revenue.industry,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 8,
                        decoration: BoxDecoration(
                          color: revenue.color,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '₱${revenue.amount}M',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMarketOpportunities() {
    return Column(
      children: [
        _buildOpportunityItem(
          'Digital Transformation',
          'Growing demand for online services and e-commerce',
          '+25%',
          Icons.trending_up,
          AppColors.success,
        ),
        _buildOpportunityItem(
          'Local Tourism',
          'Increased focus on local and sustainable tourism',
          '+18%',
          Icons.location_on,
          AppColors.info,
        ),
        _buildOpportunityItem(
          'Food & Beverage',
          'Rising demand for local cuisine and specialty foods',
          '+22%',
          Icons.restaurant,
          AppColors.warning,
        ),
        _buildOpportunityItem(
          'Health & Wellness',
          'Growing health-conscious consumer market',
          '+15%',
          Icons.favorite,
          AppColors.primary,
        ),
      ],
    );
  }

  Widget _buildOpportunityItem(
    String title,
    String description,
    String growth,
    IconData icon,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      growth,
                      style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegionalAnalysis() {
    final regions = _getRegionalAnalysis();

    return Column(
      children: regions.map((region) {
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.borderLight),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  region.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
              Text(
                '${region.smeCount} SMEs',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                '₱${region.revenue}M',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  List<GrowthTrend> _getGrowthTrends() {
    return [
      GrowthTrend('New SMEs', 15, AppColors.success),
      GrowthTrend('Revenue Growth', 12, AppColors.primary),
      GrowthTrend('Employment', 8, AppColors.info),
      GrowthTrend('Digital Adoption', 25, AppColors.warning),
    ];
  }

  List<IndustryPerformance> _getIndustryPerformance() {
    return [
      IndustryPerformance(
        'Restaurants',
        18,
        45.2,
        Icons.restaurant,
        AppColors.primary,
      ),
      IndustryPerformance(
        'Retail',
        12,
        38.7,
        Icons.shopping_cart,
        AppColors.success,
      ),
      IndustryPerformance(
        'Services',
        15,
        32.1,
        Icons.miscellaneous_services,
        AppColors.info,
      ),
      IndustryPerformance(
        'Manufacturing',
        8,
        28.4,
        Icons.factory,
        AppColors.warning,
      ),
    ];
  }

  List<RevenueTrend> _getRevenueTrends() {
    return [
      RevenueTrend('Restaurants', 45.2, AppColors.primary),
      RevenueTrend('Retail', 38.7, AppColors.success),
      RevenueTrend('Services', 32.1, AppColors.info),
      RevenueTrend('Manufacturing', 28.4, AppColors.warning),
    ];
  }

  List<RegionalData> _getRegionalAnalysis() {
    return [
      RegionalData('Batangas City', 245, 45.2),
      RegionalData('Lipa City', 189, 38.7),
      RegionalData('Tanauan City', 156, 32.1),
      RegionalData('San Jose', 134, 28.4),
      RegionalData('Others', 523, 65.8),
    ];
  }
}

class GrowthTrend {
  final String metric;
  final double value;
  final Color color;

  GrowthTrend(this.metric, this.value, this.color);
}

class IndustryPerformance {
  final String name;
  final double growth;
  final double revenue;
  final IconData icon;
  final Color color;

  IndustryPerformance(
    this.name,
    this.growth,
    this.revenue,
    this.icon,
    this.color,
  );
}

class RevenueTrend {
  final String industry;
  final double amount;
  final Color color;

  RevenueTrend(this.industry, this.amount, this.color);
}

class RegionalData {
  final String name;
  final int smeCount;
  final double revenue;

  RegionalData(this.name, this.smeCount, this.revenue);
}
