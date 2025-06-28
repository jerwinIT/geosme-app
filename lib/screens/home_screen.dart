import 'package:flutter/material.dart';
import '../models/business.dart';
import '../widgets/business_card.dart';
import '../data/dummy_data.dart';

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
            selectedColor: Theme.of(context).colorScheme.primary,
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
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
    final allCategories = dummyBusinesses.map((b) => b.category).toSet().toList();
    allCategories.sort();
    return ['All', ...allCategories];
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
    filteredBusinesses = dummyBusinesses.where((business) {
      final matchesCategory = selectedCategory == 'All' || business.category == selectedCategory;
      final matchesQuery = business.name.toLowerCase().contains(searchQuery) ||
          business.address.toLowerCase().contains(searchQuery);
      return matchesCategory && matchesQuery;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SME Feeds"),
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
            child: ListView.builder(
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
