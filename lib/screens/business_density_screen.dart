import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../constants/app_colors.dart';
import '../data/dummy_data.dart';
import '../models/business.dart';
import '../services/maps_service.dart';
import '../services/navigation_service.dart';

class BusinessDensityScreen extends StatefulWidget {
  const BusinessDensityScreen({super.key});

  @override
  State<BusinessDensityScreen> createState() => _BusinessDensityScreenState();
}

class _BusinessDensityScreenState extends State<BusinessDensityScreen> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  Set<Circle> _circles = {};
  String selectedMunicipality = 'All';
  String selectedCategory = 'All';
  bool showHeatmap = true;

  late final List<String> municipalities;
  final List<String> categories = ['All', ...businessCategories];

  @override
  void initState() {
    super.initState();
    municipalities = ['All', ...municipalities];
    _initializeMapWithErrorHandling();
  }

  void _initializeMapWithErrorHandling() {
    try {
      _updateMarkers();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(MapsService.getMapErrorMessage(e.toString())),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  void _updateMarkers() {
    final businesses = _getFilteredBusinesses();
    final markers = <Marker>{};
    final circles = <Circle>{};

    for (var business in businesses) {
      final marker = Marker(
        markerId: MarkerId(business.id),
        position: LatLng(business.latitude, business.longitude),
        infoWindow: InfoWindow(
          title: business.name,
          snippet: '${business.category} • ${business.municipality}',
          onTap: () {
            _showBusinessDetails(business);
          },
        ),
        icon: _getMarkerIcon(business.category),
      );
      markers.add(marker);

      if (showHeatmap) {
        final circle = Circle(
          circleId: CircleId(business.id),
          center: LatLng(business.latitude, business.longitude),
          radius: 500, // 500 meters radius
          fillColor: _getHeatmapColor(business.category).withOpacity(0.3),
          strokeColor: _getHeatmapColor(business.category).withOpacity(0.5),
          strokeWidth: 2,
        );
        circles.add(circle);
      }
    }

    setState(() {
      _markers = markers;
      _circles = circles;
    });
  }

  List<Business> _getFilteredBusinesses() {
    return dummyBusinesses.where((business) {
      final matchesMunicipality =
          selectedMunicipality == 'All' ||
          business.municipality == selectedMunicipality;
      final matchesCategory =
          selectedCategory == 'All' || business.category == selectedCategory;
      return matchesMunicipality && matchesCategory;
    }).toList();
  }

  BitmapDescriptor _getMarkerIcon(String category) {
    switch (category) {
      case 'Food & Beverage':
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
      case 'Retail & Trade':
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
      case 'Services':
        return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
      case 'Manufacturing':
        return BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueOrange,
        );
      case 'Agriculture':
        return BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueYellow,
        );
      case 'Tourism & Hospitality':
        return BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueViolet,
        );
      default:
        return BitmapDescriptor.defaultMarker;
    }
  }

  Color _getHeatmapColor(String category) {
    switch (category) {
      case 'Food & Beverage':
        return Colors.red;
      case 'Retail & Trade':
        return Colors.blue;
      case 'Services':
        return Colors.green;
      case 'Manufacturing':
        return Colors.orange;
      case 'Agriculture':
        return Colors.yellow;
      case 'Tourism & Hospitality':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  void _showBusinessDetails(Business business) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildBusinessDetailsSheet(business),
    );
  }

  Widget _buildBusinessDetailsSheet(Business business) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.borderLight,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    business.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: AppColors.primary,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        business.municipality,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildDetailRow('Category', business.category),
                  _buildDetailRow('Address', business.address),
                  _buildDetailRow('Price Range', business.priceRange),
                  _buildDetailRow(
                    'Rating',
                    '${business.rating}/5.0 (${business.reviewCount} reviews)',
                  ),
                  if (business.phoneNumber != null)
                    _buildDetailRow('Phone', business.phoneNumber!),
                  if (business.email != null)
                    _buildDetailRow('Email', business.email!),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // TODO: Implement directions
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Directions coming soon!'),
                              ),
                            );
                          },
                          icon: const Icon(Icons.directions),
                          label: const Text('Get Directions'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.textOnPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            // TODO: Implement bookmark
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Bookmark feature coming soon!'),
                              ),
                            );
                          },
                          icon: const Icon(Icons.bookmark_border),
                          label: const Text('Bookmark'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primary,
                            side: const BorderSide(color: AppColors.primary),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Business Density Map'),
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => NavigationService.smartPop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              showHeatmap ? Icons.layers : Icons.layers_outlined,
              color: AppColors.primary,
            ),
            onPressed: () {
              setState(() {
                showHeatmap = !showHeatmap;
                _updateMarkers();
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Filters
          Container(
            padding: const EdgeInsets.all(16),
            color: AppColors.surface,
            child: Column(
              children: [
                // Municipality Filter
                DropdownButtonFormField<String>(
                  value: selectedMunicipality,
                  decoration: const InputDecoration(
                    labelText: 'Municipality',
                    border: OutlineInputBorder(),
                  ),
                  items: municipalities.map((municipality) {
                    return DropdownMenuItem(
                      value: municipality,
                      child: Text(municipality),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedMunicipality = value!;
                      _updateMarkers();
                    });
                  },
                ),
                const SizedBox(height: 12),
                // Category Filter
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                  items: categories.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value!;
                      _updateMarkers();
                    });
                  },
                ),
              ],
            ),
          ),
          // Map
          Expanded(
            child: GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: LatLng(13.7563, 121.0583), // Batangas City center
                zoom: 10,
              ),
              onMapCreated: (controller) {
                _mapController = controller;
              },
              markers: _markers,
              circles: _circles,
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              zoomControlsEnabled: false,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _mapController?.animateCamera(
            CameraUpdate.newCameraPosition(
              const CameraPosition(target: LatLng(13.7563, 121.0583), zoom: 10),
            ),
          );
        },
        backgroundColor: AppColors.primary,
        child: const Icon(
          Icons.center_focus_strong,
          color: AppColors.textOnPrimary,
        ),
      ),
    );
  }
}
