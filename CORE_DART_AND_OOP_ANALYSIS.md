# Core Dart Fundamentals and OOP Analysis - GeoSME App

## Overview

This document focuses specifically on core Dart fundamentals and OOP concepts found in the GeoSME Flutter application.

---

## 1. Variables and Data Types

### Variable Declarations

```dart
// From business.dart - Model properties
final String name;           // String data type
final String address;        // String data type
final double rating;         // Double data type
final String? imageUrl;      // Nullable String data type

// From home_screen.dart - State variables
List<Business> filteredBusinesses = dummyBusinesses;  // List data type
String searchQuery = '';                              // String data type
String selectedCategory = 'All';                      // String data type
```

### Data Types Used

- **String**: `name`, `address`, `category`, `priceRange`
- **double**: `rating`
- **String?**: `imageUrl` (nullable)
- **List<Business>**: `filteredBusinesses`, `dummyBusinesses`
- **List<String>**: `categories`
- **Color**: `primary`, `background` (from Flutter)
- **bool**: `isSelected`, `matchesCategory`

---

## 2. Classes and Objects

### Class Definition

```dart
// From business.dart - Model class
class Business {
  final String name;
  final String address;
  final String priceRange;
  final double rating;
  final String category;
  final String? imageUrl;

  Business({
    required this.name,
    required this.address,
    required this.priceRange,
    required this.rating,
    required this.category,
    this.imageUrl,
  });
}
```

### Object Creation

```dart
// From dummy_data.dart - Creating Business objects
Business(
  name: "Angel Riana Burger",
  address: "123 M.Kahoy",
  priceRange: "₱₱",
  rating: 4.5,
  category: "Food",
  imageUrl: "https://images.unsplash.com/photo-1571091718767-18b5b1457add?w=400&h=300&fit=crop",
)
```

### Widget Classes

```dart
// From business_card.dart - StatelessWidget class
class BusinessCard extends StatelessWidget {
  final Business business;

  const BusinessCard({Key? key, required this.business}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Widget implementation
  }
}

// From home_screen.dart - StatefulWidget class
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // State implementation
}
```

---

## 3. Methods

### Instance Methods

```dart
// From home_screen.dart - Instance methods in State class
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
```

### Static Methods

```dart
// From business_filter_service.dart - Static utility methods
static List<String> getCategories(List<Business> businesses) {
  final allCategories = businesses.map((b) => b.category).toSet().toList();
  allCategories.sort();
  return ['All', ...allCategories];
}

static List<Business> filterBusinesses({
  required List<Business> allBusinesses,
  required String searchQuery,
  required String selectedCategory,
}) {
  List<Business> filtered = [];
  // Method implementation
  return filtered;
}
```

### Override Methods

```dart
// From widgets - Overriding build method
@override
Widget build(BuildContext context) {
  return Card(
    // Widget implementation
  );
}

// From StatefulWidget - Overriding createState
@override
State<HomeScreen> createState() => _HomeScreenState();
```

---

## 4. Lists

### List Creation and Initialization

```dart
// From dummy_data.dart - List of Business objects
List<Business> dummyBusinesses = [
  Business(name: "Angel Riana Burger", ...),
  Business(name: "Mary Gea Lane", ...),
  Business(name: "Jerwin's Pizzeria", ...),
];

// From home_screen.dart - List initialization
List<Business> filteredBusinesses = dummyBusinesses;
```

### List Operations

```dart
// From business_filter_service.dart - List manipulation
List<Business> filtered = [];                    // Empty list creation
filtered.add(business);                         // Adding elements
List<Business> sorted = List.from(businesses);  // List copying
sorted.sort((a, b) => b.rating.compareTo(a.rating)); // Sorting

// List transformation
final allCategories = businesses.map((b) => b.category).toSet().toList();
return ['All', ...allCategories];  // Spread operator
```

### List Iteration

```dart
// From business_filter_service.dart - For-in loop with lists
for (Business business in allBusinesses) {
  bool matchesCategory = false;
  bool matchesQuery = false;
  // Process each business
  if (matchesCategory && matchesQuery) {
    filtered.add(business);
  }
}
```

---

## 5. Loops

### For-in Loop

```dart
// From business_filter_service.dart - Iterating through list
for (Business business in allBusinesses) {
  // Process each business object
  if (business.name.toLowerCase().contains(query)) {
    filtered.add(business);
  }
}
```

### ListView.builder Loop

```dart
// From home_screen.dart - Implicit loop in ListView.builder
GridView.builder(
  itemCount: filteredBusinesses.length,
  itemBuilder: (context, index) {
    return BusinessCard(business: filteredBusinesses[index]);
  },
)
```

### ListView.separated Loop

```dart
// From home_screen.dart - Loop with separators
ListView.separated(
  itemCount: categories.length,
  separatorBuilder: (_, __) => SizedBox(width: 8),
  itemBuilder: (context, index) {
    final category = categories[index];
    // Build category item
  },
)
```

---

## 6. If-Else Statements

### Simple If-Else

```dart
// From business_filter_service.dart - Category filtering
if (selectedCategory == 'All') {
  matchesCategory = true;
} else {
  if (business.category == selectedCategory) {
    matchesCategory = true;
  } else {
    matchesCategory = false;
  }
}
```

### If-Else with Null Checking

```dart
// From business_card.dart - Null-aware conditional
if (business.imageUrl != null) {
  // Show network image
} else {
  // Show placeholder
}
```

### Ternary Operators

```dart
// From home_screen.dart - Conditional styling
color: isSelected ? AppColors.primary : AppColors.borderLight

// From business_card.dart - Conditional rendering
business.imageUrl != null
    ? Image.network(business.imageUrl!, ...)
    : Container(...)
```

### Complex Conditional Logic

```dart
// From business_filter_service.dart - Multiple conditions
if (searchQuery.isEmpty) {
  matchesQuery = true;
} else {
  String businessName = business.name.toLowerCase();
  String businessAddress = business.address.toLowerCase();

  if (businessName.contains(searchQuery) ||
      businessAddress.contains(searchQuery)) {
    matchesQuery = true;
  } else {
    matchesQuery = false;
  }
}

// Add business to filtered list if both conditions are met
if (matchesCategory && matchesQuery) {
  filtered.add(business);
}
```

---

## 7. OOP Concepts

### Inheritance

```dart
// Widget inheritance
class BusinessCard extends StatelessWidget {
  // Inherits from StatelessWidget
}

class HomeScreen extends StatefulWidget {
  // Inherits from StatefulWidget
}

class _HomeScreenState extends State<HomeScreen> {
  // Inherits from State
}
```

### Encapsulation

```dart
// Private constructor - prevents instantiation
class AppColors {
  AppColors._(); // Private constructor
  static const Color primary = Color(0xFFD72323);
}

// Private method - internal implementation
void _filterBusinesses() {
  // Private method implementation
}
```

### Polymorphism

```dart
// Method overriding
@override
Widget build(BuildContext context) {
  // Each widget implements build differently
}

@override
State<HomeScreen> createState() => _HomeScreenState();
```

### Abstraction

#### What is Abstraction?

Abstraction is the process of hiding complex implementation details and showing only the necessary features of an object. It helps in reducing complexity and increasing efficiency by hiding unnecessary details from the user.

#### Types of Abstraction in the Codebase

##### 1. **Service Layer Abstraction**

```dart
// From business_filter_service.dart - Abstracting complex filtering logic
class BusinessFilterService {
  // This class abstracts the complex filtering logic
  // Users don't need to know HOW filtering works, just WHAT it does

  /// Get all unique categories from the business list
  static List<String> getCategories(List<Business> businesses) {
    final allCategories = businesses.map((b) => b.category).toSet().toList();
    allCategories.sort();
    return ['All', ...allCategories];
  }

  /// Filter businesses based on search query and category
  static List<Business> filterBusinesses({
    required List<Business> allBusinesses,
    required String searchQuery,
    required String selectedCategory,
  }) {
    List<Business> filtered = [];

    for (Business business in allBusinesses) {
      bool matchesCategory = false;
      bool matchesQuery = false;

      // Complex category matching logic
      if (selectedCategory == 'All') {
        matchesCategory = true;
      } else {
        matchesCategory = business.category == selectedCategory;
      }

      // Complex search logic
      if (searchQuery.isEmpty) {
        matchesQuery = true;
      } else {
        String businessName = business.name.toLowerCase();
        String businessAddress = business.address.toLowerCase();
        matchesQuery = businessName.contains(searchQuery) ||
                       businessAddress.contains(searchQuery);
      }

      if (matchesCategory && matchesQuery) {
        filtered.add(business);
      }
    }

    return filtered;
  }
}
```

**How this demonstrates abstraction:**

- **Hides Complexity**: The complex filtering logic (loops, conditionals, string operations) is hidden inside the service
- **Simple Interface**: Users just call `BusinessFilterService.filterBusinesses()` with parameters
- **Reusable**: The same filtering logic can be used anywhere in the app
- **Maintainable**: Changes to filtering logic only need to be made in one place

##### 2. **Widget Abstraction**

```dart
// From business_card.dart - Abstracting UI complexity
class BusinessCard extends StatelessWidget {
  final Business business;

  const BusinessCard({Key? key, required this.business}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Complex image handling with fallbacks
          Container(
            height: 120,
            child: Stack(
              children: [
                // Complex conditional rendering logic
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                  child: business.imageUrl != null
                      ? Image.network(
                          business.imageUrl!,
                          width: double.infinity,
                          height: 120,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            // Fallback UI for failed image loading
                            return Container(
                              width: double.infinity,
                              height: 120,
                              color: Colors.grey[300],
                              child: Icon(Icons.business, size: 40, color: Colors.grey[600]),
                            );
                          },
                          loadingBuilder: (context, child, loadingProgress) {
                            // Loading state handling
                            if (loadingProgress == null) return child;
                            return Container(
                              width: double.infinity,
                              height: 120,
                              color: Colors.grey[300],
                              child: Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                            loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              ),
                            );
                          },
                        )
                      : Container(
                          // Placeholder for missing image
                          width: double.infinity,
                          height: 120,
                          color: Colors.grey[300],
                          child: Icon(Icons.business, size: 40, color: Colors.grey[600]),
                        ),
                ),
                // Rating badge positioning
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.star, size: 14, color: Colors.white),
                        SizedBox(width: 2),
                        Text(
                          business.rating.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Business information display
          Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  business.name,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Text(
                  business.address,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green[200]!),
                  ),
                  child: Text(
                    business.priceRange,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.green[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
```

**How this demonstrates abstraction:**

- **Complex UI Logic**: The widget contains complex UI logic (image loading, error handling, layout)
- **Simple Usage**: Users just pass a `Business` object: `BusinessCard(business: myBusiness)`
- **Encapsulated Behavior**: All the UI behavior is contained within the widget
- **Reusable Component**: Can be used anywhere in the app

##### 3. **Theme Abstraction**

```dart
// From app_colors.dart - Abstracting color management
class AppColors {
  // Private constructor prevents instantiation
  AppColors._();

  // Abstract color definitions - users don't need to know the hex values
  static const Color primary = Color(0xFFD72323);
  static const Color background = Color(0xFFf5f5f5);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF1A202C);
  static const Color textSecondary = Color(0xFF4A5568);

  // Helper methods for opacity variations
  static Color primaryWithOpacity(double opacity) {
    return primary.withOpacity(opacity);
  }

  static Color backgroundWithOpacity(double opacity) {
    return background.withOpacity(opacity);
  }
}
```

**How this demonstrates abstraction:**

- **Color Management**: Complex hex values are abstracted into meaningful names
- **Consistency**: Ensures consistent colors throughout the app
- **Maintainability**: Changing colors only requires updating the constants
- **Semantic Names**: `AppColors.primary` is more meaningful than `Color(0xFFD72323)`

##### 4. **Model Abstraction**

```dart
// From business.dart - Abstracting data structure
class Business {
  final String name;
  final String address;
  final String priceRange;
  final double rating;
  final String category;
  final String? imageUrl;

  Business({
    required this.name,
    required this.address,
    required this.priceRange,
    required this.rating,
    required this.category,
    this.imageUrl,
  });
}
```

**How this demonstrates abstraction:**

- **Data Structure**: Represents a business entity as a single object
- **Type Safety**: Ensures all business data has the correct types
- **Immutability**: Using `final` prevents accidental modifications
- **Validation**: Required parameters ensure necessary data is provided

#### Benefits of Abstraction in This Codebase

1. **Reduced Complexity**: Complex operations are hidden behind simple interfaces
2. **Code Reusability**: Abstracted components can be used multiple times
3. **Maintainability**: Changes to implementation don't affect the interface
4. **Testability**: Abstracted logic can be tested independently
5. **Readability**: Code is more readable and self-documenting

#### Abstraction vs Other OOP Concepts

- **Abstraction** focuses on hiding complexity and showing only essential features
- **Encapsulation** focuses on bundling data and methods that operate on that data
- **Inheritance** focuses on creating new classes based on existing ones
- **Polymorphism** focuses on using a single interface for different types

In the GeoSME app, abstraction is primarily achieved through:

- **Service classes** that hide complex business logic
- **Widget components** that hide complex UI logic
- **Model classes** that hide data structure complexity
- **Utility classes** that hide implementation details

---

## Summary

This GeoSME Flutter application demonstrates:

**Variables & Data Types:**

- Strong typing with `String`, `double`, `List<T>`, nullable types
- Proper variable declarations with `final` and `const`

**Classes & Objects:**

- Model classes (`Business`)
- Widget classes (`BusinessCard`, `HomeScreen`)
- Object instantiation with named parameters

**Methods:**

- Instance methods for state management
- Static methods for utility functions
- Override methods for widget lifecycle

**Lists:**

- List creation, manipulation, and iteration
- Functional programming with `map()`, `sort()`, `toSet()`

**Loops:**

- For-in loops for list iteration
- Implicit loops in Flutter widgets

**If-Else Statements:**

- Conditional logic for filtering and UI rendering
- Null checking and ternary operators

**OOP Concepts:**

- Inheritance through widget hierarchy
- Encapsulation with private members
- Polymorphism through method overriding
- Abstraction through service classes, widgets, and models

The codebase effectively demonstrates core Dart fundamentals and OOP principles in a practical Flutter application context.
