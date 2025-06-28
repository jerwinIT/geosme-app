import 'package:flutter/material.dart';
import '../models/business.dart';
import '../widgets/business_card.dart';
import '../data/dummy_data.dart';
import '../services/business_filter_service.dart';
import '../constants/app_colors.dart';

class CategorySelector extends StatelessWidget {
  final List<String> categories;
  final String selectedCategory;
  final Function(String) onCategorySelected;

  const CategorySelector({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, __) => SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = category == selectedCategory;
          return ChoiceChip(
            label: Text(category),
            selected: isSelected,
            onSelected: (_) => onCategorySelected(category),
            selectedColor: AppColors.primary,
            checkmarkColor: AppColors.textOnPrimary,
            labelStyle: TextStyle(
              color: isSelected
                  ? AppColors.textOnPrimary
                  : AppColors.textPrimary,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
            backgroundColor: AppColors.surface,
            side: BorderSide(
              color: isSelected ? AppColors.primary : AppColors.borderLight,
              width: 1,
            ),
          );
        },
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Business> filteredBusinesses = dummyBusinesses;
  String searchQuery = '';
  String selectedCategory = 'All';

  List<String> get categories {
    return BusinessFilterService.getCategories(dummyBusinesses);
  }

  void updateSearch(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
      _filterBusinesses();
    });
  }

  void updateCategory(String category) {
    setState(() {
      selectedCategory = category;
      _filterBusinesses();
    });
  }

  void _filterBusinesses() {
    filteredBusinesses = BusinessFilterService.filterBusinesses(
      allBusinesses: dummyBusinesses,
      searchQuery: searchQuery,
      selectedCategory: selectedCategory,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          'assets/images/geosme-logo-light.png',
          height: 40,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            // Fallback to text logo if image fails to load
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'GeoSME',
                    style: TextStyle(
                      color: AppColors.textOnPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Text(
                  'Batangas',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            );
          },
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: CategorySelector(
              categories: categories,
              selectedCategory: selectedCategory,
              onCategorySelected: updateCategory,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                labelText: "Search",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: updateSearch,
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(12),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: filteredBusinesses.length,
              itemBuilder: (context, index) {
                return BusinessCard(business: filteredBusinesses[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
