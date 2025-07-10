import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../models/business.dart';

class BusinessDetailScreen extends StatefulWidget {
  final Business business;

  const BusinessDetailScreen({super.key, required this.business});

  @override
  State<BusinessDetailScreen> createState() => _BusinessDetailScreenState();
}

class _BusinessDetailScreenState extends State<BusinessDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  double userRating = 0;
  final TextEditingController _commentController = TextEditingController();
  final List<Comment> comments = [];
  int currentImageIndex = 0;

  // Sample gallery images
  final List<String> galleryImages = [
    'https://images.unsplash.com/photo-1571091718767-18b5b1457add?w=400&h=300&fit=crop',
    'https://images.unsplash.com/photo-1554118811-1e0d58224f24?w=400&h=300&fit=crop',
    'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=400&h=300&fit=crop',
    'https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=400&h=300&fit=crop',
    'https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?w=400&h=300&fit=crop',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);

    // Add sample comments
    comments.addAll([
      Comment(
        userName: 'John Doe',
        rating: 5.0,
        comment: 'Great food and excellent service! Highly recommended.',
        date: DateTime.now().subtract(const Duration(days: 2)),
      ),
      Comment(
        userName: 'Jane Smith',
        rating: 4.0,
        comment: 'Good quality food, but a bit pricey. Nice atmosphere though.',
        date: DateTime.now().subtract(const Duration(days: 5)),
      ),
      Comment(
        userName: 'Mike Johnson',
        rating: 4.5,
        comment:
            'Amazing place! The staff is very friendly and the food is delicious.',
        date: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ]);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  void _addComment() {
    if (_commentController.text.trim().isNotEmpty && userRating > 0) {
      setState(() {
        comments.insert(
          0,
          Comment(
            userName: 'You',
            rating: userRating,
            comment: _commentController.text.trim(),
            date: DateTime.now(),
          ),
        );
        _commentController.clear();
        userRating = 0;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Comment added successfully!'),
          backgroundColor: AppColors.success,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please provide both rating and comment'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar with Image
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                widget.business.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      offset: Offset(0, 1),
                      blurRadius: 3,
                      color: Colors.black54,
                    ),
                  ],
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  PageView.builder(
                    onPageChanged: (index) {
                      setState(() {
                        currentImageIndex = index;
                      });
                    },
                    itemCount: galleryImages.length,
                    itemBuilder: (context, index) {
                      return Image.network(
                        galleryImages[index],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: AppColors.borderLight,
                            child: const Icon(
                              Icons.business,
                              size: 64,
                              color: AppColors.textLight,
                            ),
                          );
                        },
                      );
                    },
                  ),
                  // Image indicator
                  Positioned(
                    bottom: 16,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        galleryImages.length,
                        (index) => Container(
                          width: 8,
                          height: 8,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: currentImageIndex == index
                                ? Colors.white
                                : Colors.white.withOpacity(0.5),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.share, color: Colors.white),
                onPressed: () {
                  _shareBusiness();
                },
              ),
              IconButton(
                icon: Icon(
                  widget.business.isBookmarked
                      ? Icons.bookmark
                      : Icons.bookmark_border,
                  color: Colors.white,
                ),
                onPressed: () {
                  _toggleBookmark();
                },
              ),
            ],
          ),

          // Business Info
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Rating and Category
                  Row(
                    children: [
                      Row(
                        children: List.generate(5, (index) {
                          return Icon(
                            index < widget.business.rating.floor()
                                ? Icons.star
                                : index < widget.business.rating
                                ? Icons.star_half
                                : Icons.star_border,
                            color: Colors.amber,
                            size: 20,
                          );
                        }),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${widget.business.rating} (${comments.length} reviews)',
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          widget.business.category,
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Price Range and Address
                  Row(
                    children: [
                      Icon(
                        Icons.attach_money,
                        color: AppColors.textLight,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        widget.business.priceRange,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: AppColors.textLight,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          widget.business.address,
                          style: const TextStyle(
                            fontSize: 16,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // TODO: Implement call functionality
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Call functionality coming soon!',
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.phone),
                          label: const Text('Call'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            _showMapDialog();
                          },
                          icon: const Icon(Icons.map),
                          label: const Text('Directions'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primary,
                            side: BorderSide(color: AppColors.primary),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Tab Bar
                  TabBar(
                    controller: _tabController,
                    tabs: const [
                      Tab(text: 'Gallery'),
                      Tab(text: 'Reviews'),
                      Tab(text: 'About'),
                      Tab(text: 'Map'),
                    ],
                    labelColor: AppColors.primary,
                    unselectedLabelColor: AppColors.textSecondary,
                    indicatorColor: AppColors.primary,
                  ),
                ],
              ),
            ),
          ),

          // Tab Views
          SliverFillRemaining(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildGalleryTab(),
                _buildReviewsTab(),
                _buildAboutTab(),
                _buildMapTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGalleryTab() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1,
      ),
      itemCount: galleryImages.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            _showFullScreenImage(index);
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              galleryImages[index],
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: AppColors.borderLight,
                  child: const Icon(Icons.image, color: AppColors.textLight),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildReviewsTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Add Review Section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Add Your Review',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),

                  // Rating
                  Row(
                    children: [
                      const Text('Rating: '),
                      ...List.generate(5, (index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              userRating = index + 1.0;
                            });
                          },
                          child: Icon(
                            index < userRating ? Icons.star : Icons.star_border,
                            color: Colors.amber,
                            size: 24,
                          ),
                        );
                      }),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Comment
                  TextField(
                    controller: _commentController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      hintText: 'Write your review...',
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 12),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _addComment,
                      child: const Text('Submit Review'),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Reviews List
          const Text(
            'All Reviews',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          ...comments.map((comment) => _buildCommentCard(comment)),
        ],
      ),
    );
  }

  Widget _buildCommentCard(Comment comment) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.primary.withOpacity(0.1),
                  child: Text(
                    comment.userName[0],
                    style: TextStyle(
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
                      Text(
                        comment.userName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          ...List.generate(5, (index) {
                            return Icon(
                              index < comment.rating
                                  ? Icons.star
                                  : Icons.star_border,
                              color: Colors.amber,
                              size: 16,
                            );
                          }),
                          const SizedBox(width: 8),
                          Text(
                            _formatDate(comment.date),
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.textLight,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(comment.comment),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About ${widget.business.name}',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          _buildInfoCard(
            'Business Hours',
            'Monday - Friday: 8:00 AM - 10:00 PM\nSaturday - Sunday: 9:00 AM - 11:00 PM',
            Icons.access_time,
          ),

          const SizedBox(height: 12),

          _buildInfoCard(
            'Contact Information',
            'Phone: +63 912 345 6789\nEmail: info@${widget.business.name.toLowerCase().replaceAll(' ', '')}.com',
            Icons.contact_phone,
          ),

          const SizedBox(height: 12),

          _buildInfoCard(
            'Services',
            '• Dine-in\n• Takeout\n• Delivery\n• Catering',
            Icons.miscellaneous_services,
          ),

          const SizedBox(height: 12),

          _buildInfoCard(
            'Payment Methods',
            '• Cash\n• Credit Card\n• Digital Wallets\n• Bank Transfer',
            Icons.payment,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, String content, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    content,
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Location',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // Map Placeholder
          Container(
            height: 300,
            decoration: BoxDecoration(
              color: AppColors.borderLight,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.map, size: 64, color: AppColors.textLight),
                      const SizedBox(height: 16),
                      const Text(
                        'Map View',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Interactive map coming soon!',
                        style: TextStyle(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 16,
                  right: 16,
                  child: FloatingActionButton.small(
                    onPressed: () {
                      _showMapDialog();
                    },
                    child: const Icon(Icons.directions),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Address Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.location_on, color: AppColors.primary),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Address',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(widget.business.address),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      _showMapDialog();
                    },
                    icon: const Icon(Icons.directions),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showMapDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Open in Maps'),
        content: Text(
          'Would you like to open ${widget.business.name} in Google Maps?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _openInGoogleMaps();
            },
            child: const Text('Open Maps'),
          ),
        ],
      ),
    );
  }

  void _openInGoogleMaps() {
    final lat = widget.business.latitude;
    final lng = widget.business.longitude;
    final name = Uri.encodeComponent(widget.business.name);
    final address = Uri.encodeComponent(widget.business.address);

    final url =
        'https://www.google.com/maps/search/?api=1&query=$lat,$lng&query_place_id=$name';

    // For web, we can use url_launcher package
    // For now, show a snackbar with the URL
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening Google Maps for ${widget.business.name}...'),
        backgroundColor: AppColors.success,
        action: SnackBarAction(
          label: 'Copy URL',
          onPressed: () {
            // TODO: Implement clipboard functionality
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('URL copied: $url')));
          },
        ),
      ),
    );
  }

  void _showFullScreenImage(int initialIndex) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            iconTheme: const IconThemeData(color: Colors.white),
            title: Text(
              '${initialIndex + 1} of ${galleryImages.length}',
              style: const TextStyle(color: Colors.white),
            ),
          ),
          body: PageView.builder(
            controller: PageController(initialPage: initialIndex),
            itemCount: galleryImages.length,
            itemBuilder: (context, index) {
              return InteractiveViewer(
                child: Center(
                  child: Image.network(
                    galleryImages[index],
                    fit: BoxFit.contain,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  void _toggleBookmark() {
    setState(() {
      widget.business.isBookmarked = !widget.business.isBookmarked;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          widget.business.isBookmarked
              ? 'Added to bookmarks'
              : 'Removed from bookmarks',
        ),
        backgroundColor: widget.business.isBookmarked
            ? AppColors.success
            : AppColors.warning,
      ),
    );
  }

  void _shareBusiness() {
    final shareText =
        'Check out ${widget.business.name} in ${widget.business.address}! '
        'Rating: ${widget.business.rating}/5 - ${widget.business.category}';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing: $shareText'),
        backgroundColor: AppColors.info,
        action: SnackBarAction(
          label: 'Copy',
          onPressed: () {
            // TODO: Implement clipboard functionality
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Copied to clipboard!')),
            );
          },
        ),
      ),
    );
  }
}

class Comment {
  final String userName;
  final double rating;
  final String comment;
  final DateTime date;

  Comment({
    required this.userName,
    required this.rating,
    required this.comment,
    required this.date,
  });
}
