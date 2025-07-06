import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class CompetitorAnalysisScreen extends StatefulWidget {
  const CompetitorAnalysisScreen({super.key});

  @override
  State<CompetitorAnalysisScreen> createState() =>
      _CompetitorAnalysisScreenState();
}

class _CompetitorAnalysisScreenState extends State<CompetitorAnalysisScreen> {
  String selectedIndustry = 'Restaurants';
  final List<String> industries = [
    'Restaurants',
    'Retail',
    'Services',
    'Manufacturing',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Competitor Analysis'),
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
            // Industry Selector
            const Text(
              'Select Industry',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: industries.length,
                itemBuilder: (context, index) {
                  final industry = industries[index];
                  final isSelected = industry == selectedIndustry;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(industry),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          selectedIndustry = industry;
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

            const SizedBox(height: 24),

            // Market Share Chart
            _buildSectionCard(
              'Market Share Analysis',
              'Top competitors in $selectedIndustry',
              _buildMarketShareChart(),
            ),

            const SizedBox(height: 16),

            // Competitor Comparison
            _buildSectionCard(
              'Competitor Comparison',
              'Key metrics comparison',
              _buildCompetitorComparison(),
            ),

            const SizedBox(height: 16),

            // Competitive Landscape
            _buildSectionCard(
              'Competitive Landscape',
              'Market positioning analysis',
              _buildCompetitiveLandscape(),
            ),

            const SizedBox(height: 16),

            // Key Insights
            _buildSectionCard(
              'Key Insights',
              'Strategic recommendations',
              _buildKeyInsights(),
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

  Widget _buildMarketShareChart() {
    final competitors = _getCompetitors();

    return Column(
      children: competitors.map((competitor) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  competitor.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Stack(
                  children: [
                    Container(
                      height: 24,
                      decoration: BoxDecoration(
                        color: AppColors.borderLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    Container(
                      height: 24,
                      width:
                          MediaQuery.of(context).size.width *
                          0.3 *
                          (competitor.marketShare / 100),
                      decoration: BoxDecoration(
                        color: competitor.color,
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: 50,
                child: Text(
                  '${competitor.marketShare}%',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCompetitorComparison() {
    final competitors = _getCompetitors();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Competitor')),
          DataColumn(label: Text('Rating')),
          DataColumn(label: Text('Reviews')),
          DataColumn(label: Text('Price')),
          DataColumn(label: Text('Location')),
        ],
        rows: competitors.map((competitor) {
          return DataRow(
            cells: [
              DataCell(Text(competitor.name)),
              DataCell(
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 16),
                    Text(' ${competitor.rating}'),
                  ],
                ),
              ),
              DataCell(Text('${competitor.reviews}')),
              DataCell(Text(competitor.priceRange)),
              DataCell(Text(competitor.location)),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCompetitiveLandscape() {
    return Column(
      children: [
        _buildLandscapeItem(
          'Market Leader',
          'Lipa City Restaurant',
          'Strong brand presence, high customer loyalty',
          AppColors.success,
        ),
        _buildLandscapeItem(
          'Challenger',
          'Batangas Coffee Co.',
          'Innovative products, growing market share',
          AppColors.warning,
        ),
        _buildLandscapeItem(
          'Niche Player',
          'Local Food Hub',
          'Specialized offerings, loyal customer base',
          AppColors.info,
        ),
        _buildLandscapeItem(
          'Emerging',
          'New Market Entrants',
          'Innovative business models, digital focus',
          AppColors.primary,
        ),
      ],
    );
  }

  Widget _buildLandscapeItem(
    String position,
    String name,
    String description,
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  position,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                name,
                style: const TextStyle(
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
    );
  }

  Widget _buildKeyInsights() {
    return Column(
      children: [
        _buildInsightItem(
          'Market Opportunity',
          'Growing demand for local cuisine in Batangas',
          Icons.trending_up,
          AppColors.success,
        ),
        _buildInsightItem(
          'Competitive Advantage',
          'Focus on authentic local ingredients and recipes',
          Icons.star,
          AppColors.warning,
        ),
        _buildInsightItem(
          'Digital Presence',
          'Invest in online ordering and delivery services',
          Icons.smartphone,
          AppColors.info,
        ),
        _buildInsightItem(
          'Customer Experience',
          'Enhance service quality and customer engagement',
          Icons.people,
          AppColors.primary,
        ),
      ],
    );
  }

  Widget _buildInsightItem(
    String title,
    String description,
    IconData icon,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
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

  List<Competitor> _getCompetitors() {
    switch (selectedIndustry) {
      case 'Restaurants':
        return [
          Competitor(
            'Lipa City Restaurant',
            35,
            4.8,
            1247,
            'Premium',
            'Lipa City',
            AppColors.primary,
          ),
          Competitor(
            'Batangas Coffee Co.',
            28,
            4.6,
            892,
            'Mid-range',
            'Batangas City',
            AppColors.success,
          ),
          Competitor(
            'Local Food Hub',
            22,
            4.4,
            567,
            'Budget',
            'Tanauan',
            AppColors.warning,
          ),
          Competitor(
            'Others',
            15,
            4.2,
            234,
            'Various',
            'Various',
            AppColors.info,
          ),
        ];
      case 'Retail':
        return [
          Competitor(
            'Fresh Market Grocery',
            40,
            4.7,
            1567,
            'Mid-range',
            'Batangas City',
            AppColors.primary,
          ),
          Competitor(
            'Local Mart',
            30,
            4.5,
            987,
            'Budget',
            'Lipa City',
            AppColors.success,
          ),
          Competitor(
            'Premium Store',
            20,
            4.8,
            456,
            'Premium',
            'Tanauan',
            AppColors.warning,
          ),
          Competitor(
            'Others',
            10,
            4.3,
            123,
            'Various',
            'Various',
            AppColors.info,
          ),
        ];
      default:
        return [
          Competitor(
            'Market Leader',
            35,
            4.6,
            1000,
            'Various',
            'Batangas',
            AppColors.primary,
          ),
          Competitor(
            'Challenger',
            25,
            4.4,
            750,
            'Various',
            'Batangas',
            AppColors.success,
          ),
          Competitor(
            'Niche Player',
            20,
            4.5,
            500,
            'Various',
            'Batangas',
            AppColors.warning,
          ),
          Competitor(
            'Others',
            20,
            4.2,
            250,
            'Various',
            'Batangas',
            AppColors.info,
          ),
        ];
    }
  }
}

class Competitor {
  final String name;
  final double marketShare;
  final double rating;
  final int reviews;
  final String priceRange;
  final String location;
  final Color color;

  Competitor(
    this.name,
    this.marketShare,
    this.rating,
    this.reviews,
    this.priceRange,
    this.location,
    this.color,
  );
}
