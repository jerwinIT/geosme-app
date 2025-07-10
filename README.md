# GeoSME - Batangas SME Market Analytics

A comprehensive mobile application for Small and Medium Enterprise (SME) market analytics in Batangas Province, Philippines. This Flutter-based application provides insights into business density, market trends, competitor analysis, and opportunity zones.

## Features

### 🏠 Dashboard

- **Overview Statistics**: Total SMEs, categories, municipalities, and growth metrics
- **Category Distribution**: Interactive pie charts showing business category breakdown
- **Top Categories**: Ranking of most popular business categories
- **Municipality Density**: Business density analysis by municipality
- **Hotspots**: Identification of business clusters and high-density areas
- **Opportunity Zones**: Areas with growth potential and market gaps

### 🗺️ Business Density Map

- **Interactive Map**: Google Maps integration with business locations
- **Heatmap Visualization**: Color-coded density representation
- **Filtering**: Filter by municipality and business category
- **Business Details**: Tap markers for detailed business information
- **Directions**: Get directions to business locations

### 📊 Market Trends

- **Growth Analysis**: Category-wise growth trends and patterns
- **Trending Categories**: Fastest growing business sectors
- **Market Insights**: Key insights and recommendations
- **Seasonal Trends**: Time-based business pattern analysis
- **Filtering Options**: Customize analysis by timeframe and category

### 🔍 Competitor Analysis

- **Business Hotspots**: High-competition areas and clusters
- **Competition Heatmap**: Visual representation of competitive density
- **Market Saturation**: Analysis of market saturation by category
- **Competitive Advantages**: Key factors for business success
- **Detailed Insights**: In-depth competitive landscape analysis

### 📚 SME Browse

- **Business Directory**: Comprehensive list of all SMEs
- **Search & Filter**: Advanced search and filtering capabilities
- **Business Cards**: Detailed business information cards
- **Bookmarking**: Save favorite businesses for quick access
- **Category Filtering**: Filter by business category

### 🔖 Bookmarks

- **Saved Businesses**: Quick access to bookmarked SMEs
- **Search & Sort**: Search within bookmarks and sort options
- **Swipe to Remove**: Easy bookmark management
- **Sync**: Persistent bookmark storage

## Technology Stack

- **Framework**: Flutter 3.8+
- **Language**: Dart
- **Maps**: Google Maps Flutter
- **Charts**: FL Chart
- **Storage**: Shared Preferences
- **State Management**: Provider
- **UI**: Material Design 3

## Project Structure

```
lib/
├── constants/
│   └── app_colors.dart          # Application color scheme
├── data/
│   ├── dummy_data.dart          # Sample business data
│   └── user_credentials.dart    # User authentication data
├── models/
│   ├── business.dart            # Business entity model
│   ├── analytics.dart           # Analytics data models
│   └── user.dart                # User authentication models
├── screens/
│   ├── landing_screen.dart      # Onboarding and app introduction
│   ├── login_screen.dart        # User authentication
│   ├── register_screen.dart     # User registration
│   ├── dashboard_screen.dart    # Main dashboard
│   ├── business_density_screen.dart
│   ├── market_trends_screen.dart
│   ├── competitor_analysis_screen.dart
│   ├── sme_browse_screen.dart
│   ├── bookmarks_screen.dart
│   └── business_detail_screen.dart
├── services/
│   ├── analytics_service.dart   # Business analytics logic
│   └── bookmark_service.dart    # Bookmark management
├── widgets/
│   └── business_card.dart       # Reusable business card widget
└── main.dart                    # Application entry point
```

## Getting Started

### Prerequisites

- Flutter SDK 3.8.1 or higher
- Dart SDK 3.8.1 or higher
- Android Studio / VS Code
- Google Maps API Key (for map functionality)

### Installation

1. **Clone the repository**

   ```bash
   git clone https://github.com/yourusername/geosme.git
   cd geosme
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Configure Google Maps API Key**

   - Get an API key from [Google Cloud Console](https://console.cloud.google.com/)
   - Add the key to `android/app/src/main/AndroidManifest.xml`:
     ```xml
     <meta-data
       android:name="com.google.android.geo.API_KEY"
       android:value="YOUR_API_KEY_HERE"/>
     ```

4. **Run the application**
   ```bash
   flutter run
   ```

### Authentication

The application starts with an onboarding flow and requires authentication to access the main features:

**Demo Credentials:**

- **Admin User**: `admin@geosme.com` / `admin123`
- **Regular User**: `user@geosme.com` / `user123`
- **Demo User**: `demo@geosme.com` / `demo123`
- **Test User**: `test@geosme.com` / `test123`

**Flow:**

1. **Landing Screen** - Onboarding and app introduction
2. **Authentication** - Login or create new account
3. **Dashboard** - Main application with all features

## Key Features Implementation

### Analytics Service

The `AnalyticsService` provides comprehensive business analytics including:

- Category distribution analysis
- Municipality business density
- Hotspot identification
- Opportunity zone detection
- Market trend calculations

### Business Model

Enhanced business model with:

- Geographic coordinates (latitude/longitude)
- Rating and review system
- Contact information
- Price range classification
- Municipality categorization

### Map Integration

Google Maps integration with:

- Custom markers for different business categories
- Heatmap visualization
- Interactive business details
- Location-based filtering

## Data Sources

The application currently uses dummy data representing:

- **1,247 SMEs** across Batangas Province
- **6 business categories**: Food & Beverage, Retail & Trade, Services, Manufacturing, Agriculture, Tourism & Hospitality
- **Multiple municipalities**: Batangas City, Lipa City, Tanauan, San Jose, Taal, Balayan, and more

## Future Enhancements

- [ ] Real-time data integration
- [ ] User authentication and profiles
- [ ] Push notifications for market updates
- [ ] Advanced filtering and search
- [ ] Business registration and management
- [ ] Social features and reviews
- [ ] Export and reporting capabilities
- [ ] Multi-language support

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Batangas Provincial Government for domain expertise
- Flutter team for the amazing framework
- Google Maps for location services
- FL Chart for data visualization

## Contact

For questions and support, please contact:

- Email: support@geosme.ph
- Website: https://geosme.ph
- GitHub: https://github.com/yourusername/geosme

---

**GeoSME** - Empowering SMEs through data-driven insights in Batangas Province 🇵🇭
