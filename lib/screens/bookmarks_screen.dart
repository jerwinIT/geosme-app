import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../models/business.dart';
import '../services/bookmark_service.dart';
import '../data/dummy_data.dart';
import '../widgets/business_card.dart';
import 'business_detail_screen.dart';

class BookmarksScreen extends StatefulWidget {
  const BookmarksScreen({super.key});

  @override
  State<BookmarksScreen> createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends State<BookmarksScreen> {
  List<Business> bookmarkedBusinesses = [];
  bool isLoading = true;
  String searchQuery = '';
  String selectedCategory = 'All';
  final TextEditingController _searchController = TextEditingController();

  final List<String> categories = [
    'All',
    'Food & Beverage',
    'Retail & Trade',
    'Services',
    'Manufacturing',
    'Agriculture',
    'Tourism & Hospitality',
  ];

  @override
  void initState() {
    super.initState();
    _loadBookmarks();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadBookmarks() async {
    setState(() {
      isLoading = true;
    });

    try {
      final bookmarks = await BookmarkService.getBookmarkedBusinesses(
        dummyBusinesses,
      );
      setState(() {
        bookmarkedBusinesses = bookmarks;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error loading bookmarks: $e')));
      }
    }
  }

  void _onSearchChanged() {
    setState(() {
      searchQuery = _searchController.text.toLowerCase();
    });
  }

  void _onCategorySelected(String category) {
    setState(() {
      selectedCategory = category;
    });
  }

  List<Business> get filteredBookmarks {
    return bookmarkedBusinesses.where((business) {
      final matchesSearch =
          business.name.toLowerCase().contains(searchQuery) ||
          business.address.toLowerCase().contains(searchQuery) ||
          business.category.toLowerCase().contains(searchQuery);

      final matchesCategory =
          selectedCategory == 'All' ||
          business.category.toLowerCase() == selectedCategory.toLowerCase();

      return matchesSearch && matchesCategory;
    }).toList();
  }

  Future<void> _removeBookmark(Business business) async {
    try {
      await BookmarkService.removeBookmark(business.id);
      setState(() {
        bookmarkedBusinesses.removeWhere((b) => b.id == business.id);
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${business.name} removed from bookmarks'),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () => _addBookmark(business),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error removing bookmark: $e')));
      }
    }
  }

  Future<void> _addBookmark(Business business) async {
    try {
      await BookmarkService.addBookmark(business.id);
      setState(() {
        if (!bookmarkedBusinesses.any((b) => b.id == business.id)) {
          bookmarkedBusinesses.add(business);
        }
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error adding bookmark: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bookmarks'),
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.primary),
            onPressed: _loadBookmarks,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search bookmarks...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: AppColors.surface,
              ),
            ),
          ),

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
                    onSelected: (_) => _onCategorySelected(category),
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

          // Results Count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${filteredBookmarks.length} bookmarks',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
                if (filteredBookmarks.isNotEmpty)
                  TextButton.icon(
                    onPressed: () {
                      _showSortDialog();
                    },
                    icon: const Icon(Icons.sort, size: 16),
                    label: const Text('Sort'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.primary,
                    ),
                  ),
              ],
            ),
          ),

          // Bookmarks List
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredBookmarks.isEmpty
                ? _buildEmptyState()
                : RefreshIndicator(
                    onRefresh: _loadBookmarks,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: filteredBookmarks.length,
                      itemBuilder: (context, index) {
                        final business = filteredBookmarks[index];
                        return Dismissible(
                          key: Key(business.id),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 20),
                            color: AppColors.error,
                            child: const Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                          onDismissed: (direction) {
                            _removeBookmark(business);
                          },
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      BusinessDetailScreen(business: business),
                                ),
                              );
                            },
                            child: BusinessCard(
                              business: business,
                              onBookmarkChanged: () {
                                _removeBookmark(business);
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.bookmark_border, size: 64, color: AppColors.textSecondary),
          const SizedBox(height: 16),
          Text(
            searchQuery.isNotEmpty || selectedCategory != 'All'
                ? 'No bookmarks found'
                : 'No bookmarks yet',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            searchQuery.isNotEmpty || selectedCategory != 'All'
                ? 'Try adjusting your search or filters'
                : 'Start exploring businesses and save your favorites',
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          if (searchQuery.isEmpty && selectedCategory == 'All')
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.explore),
              label: const Text('Explore Businesses'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.textOnPrimary,
              ),
            ),
        ],
      ),
    );
  }

  void _showSortDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sort Bookmarks'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.sort_by_alpha),
              title: const Text('Name (A-Z)'),
              onTap: () {
                setState(() {
                  filteredBookmarks.sort((a, b) => a.name.compareTo(b.name));
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.sort_by_alpha),
              title: const Text('Name (Z-A)'),
              onTap: () {
                setState(() {
                  filteredBookmarks.sort((a, b) => b.name.compareTo(a.name));
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.category),
              title: const Text('Category'),
              onTap: () {
                setState(() {
                  filteredBookmarks.sort(
                    (a, b) => a.category.compareTo(b.category),
                  );
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.star),
              title: const Text('Rating (High to Low)'),
              onTap: () {
                setState(() {
                  filteredBookmarks.sort(
                    (a, b) => b.rating.compareTo(a.rating),
                  );
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.location_on),
              title: const Text('Location'),
              onTap: () {
                setState(() {
                  filteredBookmarks.sort(
                    (a, b) => a.municipality.compareTo(b.municipality),
                  );
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
