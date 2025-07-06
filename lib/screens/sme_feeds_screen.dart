import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class SmeFeedsScreen extends StatefulWidget {
  const SmeFeedsScreen({super.key});

  @override
  State<SmeFeedsScreen> createState() => _SmeFeedsScreenState();
}

class _SmeFeedsScreenState extends State<SmeFeedsScreen> {
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
        title: const Text('SME Feeds'),
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

          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search SME feeds...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: AppColors.surface,
              ),
            ),
          ),

          // Feeds List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _getFeeds().length,
              itemBuilder: (context, index) {
                final feed = _getFeeds()[index];
                return _buildFeedCard(feed);
              },
            ),
          ),
        ],
      ),
    );
  }

  List<FeedItem> _getFeeds() {
    return [
      FeedItem(
        businessName: 'Lipa City Restaurant',
        category: 'Restaurants',
        content:
            'Just launched our new menu featuring local Batangas specialties! Come try our famous Bulalo and Lomi.',
        timeAgo: '2 hours ago',
        likes: 24,
        comments: 8,
        imageUrl: null,
        isVerified: true,
      ),
      FeedItem(
        businessName: 'Batangas Coffee Co.',
        category: 'Retail',
        content:
            'Fresh batch of Batangas coffee beans just arrived! Perfect for your morning brew. Available in our store and online.',
        timeAgo: '4 hours ago',
        likes: 18,
        comments: 5,
        imageUrl: null,
        isVerified: true,
      ),
      FeedItem(
        businessName: 'Tech Solutions Batangas',
        category: 'Services',
        content:
            'Excited to announce our new IT consulting services for SMEs in Batangas. Helping businesses go digital!',
        timeAgo: '6 hours ago',
        likes: 31,
        comments: 12,
        imageUrl: null,
        isVerified: false,
      ),
      FeedItem(
        businessName: 'Batangas Furniture Co.',
        category: 'Manufacturing',
        content:
            'Handcrafted furniture made from sustainable local materials. Custom orders welcome!',
        timeAgo: '1 day ago',
        likes: 42,
        comments: 15,
        imageUrl: null,
        isVerified: true,
      ),
      FeedItem(
        businessName: 'Fresh Market Grocery',
        category: 'Retail',
        content:
            'Weekend sale alert! 20% off on all local produce. Support local farmers and get fresh ingredients.',
        timeAgo: '1 day ago',
        likes: 56,
        comments: 23,
        imageUrl: null,
        isVerified: true,
      ),
      FeedItem(
        businessName: 'Batangas Auto Repair',
        category: 'Services',
        content:
            'New diagnostic equipment installed! Now offering comprehensive car maintenance services.',
        timeAgo: '2 days ago',
        likes: 28,
        comments: 9,
        imageUrl: null,
        isVerified: false,
      ),
    ];
  }

  Widget _buildFeedCard(FeedItem feed) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.primary.withOpacity(0.1),
                  child: Text(
                    feed.businessName[0],
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            feed.businessName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          if (feed.isVerified) ...[
                            const SizedBox(width: 4),
                            Icon(
                              Icons.verified,
                              color: AppColors.primary,
                              size: 16,
                            ),
                          ],
                        ],
                      ),
                      Text(
                        feed.category,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  feed.timeAgo,
                  style: const TextStyle(
                    color: AppColors.textLight,
                    fontSize: 12,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Content
            Text(
              feed.content,
              style: const TextStyle(fontSize: 14, height: 1.4),
            ),

            const SizedBox(height: 16),

            // Actions
            Row(
              children: [
                _buildActionButton(
                  Icons.thumb_up_outlined,
                  '${feed.likes}',
                  () {
                    // TODO: Implement like functionality
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Like functionality coming soon!'),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 24),
                _buildActionButton(
                  Icons.comment_outlined,
                  '${feed.comments}',
                  () {
                    // TODO: Implement comment functionality
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Comment functionality coming soon!'),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 24),
                _buildActionButton(Icons.share_outlined, 'Share', () {
                  // TODO: Implement share functionality
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Share functionality coming soon!'),
                    ),
                  );
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: AppColors.textSecondary),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FeedItem {
  final String businessName;
  final String category;
  final String content;
  final String timeAgo;
  final int likes;
  final int comments;
  final String? imageUrl;
  final bool isVerified;

  FeedItem({
    required this.businessName,
    required this.category,
    required this.content,
    required this.timeAgo,
    required this.likes,
    required this.comments,
    this.imageUrl,
    required this.isVerified,
  });
}
