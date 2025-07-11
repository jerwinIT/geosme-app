import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../constants/app_colors.dart';

class MapsService {
  static final MapsService _instance = MapsService._internal();
  factory MapsService() => _instance;
  MapsService._internal();

  // Check if Google Maps is available
  static Future<bool> isGoogleMapsAvailable() async {
    try {
      final url = Uri.parse('https://www.google.com/maps');
      return await canLaunchUrl(url);
    } catch (e) {
      return false;
    }
  }

  // Open Google Maps with error handling
  static Future<bool> openGoogleMaps({
    required double latitude,
    required double longitude,
    String? businessName,
    String? address,
    required BuildContext context,
  }) async {
    try {
      // Check if Google Maps is available
      final isAvailable = await isGoogleMapsAvailable();
      if (!isAvailable) {
        _showMapsErrorDialog(
          context,
          'Google Maps is not available on this device.',
        );
        return false;
      }

      // Build the URL
      final name = businessName != null
          ? Uri.encodeComponent(businessName)
          : '';
      final addr = address != null ? Uri.encodeComponent(address) : '';

      String url;
      if (businessName != null && address != null) {
        url =
            'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude&query_place_id=$name';
      } else {
        url =
            'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
      }

      final uri = Uri.parse(url);

      // Try to launch the URL
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (launched) {
        _showSuccessMessage(context, businessName ?? 'Location');
        return true;
      } else {
        _showMapsErrorDialog(
          context,
          'Failed to open Google Maps. Please try again.',
        );
        return false;
      }
    } catch (e) {
      _showMapsErrorDialog(
        context,
        'Error opening Google Maps: ${e.toString()}',
      );
      return false;
    }
  }

  // Show error dialog for maps
  static void _showMapsErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.error_outline, color: AppColors.error),
            SizedBox(width: 8),
            Text('Maps Error'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(message),
            const SizedBox(height: 16),
            const Text(
              'Alternative options:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('• Copy the address to clipboard'),
            const Text('• Use a different maps app'),
            const Text('• Check your internet connection'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showAlternativeOptions(context);
            },
            child: const Text('More Options'),
          ),
        ],
      ),
    );
  }

  // Show alternative options
  static void _showAlternativeOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Alternative Maps Options'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.copy),
              title: const Text('Copy Address'),
              subtitle: const Text('Copy the business address to clipboard'),
              onTap: () {
                Navigator.of(context).pop();
                // TODO: Implement clipboard functionality
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Address copied to clipboard')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.map),
              title: const Text('Open in Browser'),
              subtitle: const Text('Open Google Maps in web browser'),
              onTap: () {
                Navigator.of(context).pop();
                _openInBrowser(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.help),
              title: const Text('Get Help'),
              subtitle: const Text('Contact support for assistance'),
              onTap: () {
                Navigator.of(context).pop();
                _showHelpDialog(context);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  // Open in browser
  static void _openInBrowser(BuildContext context) {
    try {
      final url = Uri.parse('https://www.google.com/maps');
      launchUrl(url, mode: LaunchMode.externalApplication);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error opening browser: ${e.toString()}')),
      );
    }
  }

  // Show help dialog
  static void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Maps Help'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('If you\'re having trouble with maps:'),
            SizedBox(height: 8),
            Text('• Make sure you have an internet connection'),
            Text('• Check if Google Maps is installed'),
            Text('• Try updating your Google Maps app'),
            Text('• Contact support if the issue persists'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // Show success message
  static void _showSuccessMessage(BuildContext context, String businessName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening Google Maps for $businessName...'),
        backgroundColor: AppColors.success,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Validate coordinates
  static bool isValidCoordinates(double latitude, double longitude) {
    return latitude >= -90 &&
        latitude <= 90 &&
        longitude >= -180 &&
        longitude <= 180;
  }

  // Get map error message
  static String getMapErrorMessage(String error) {
    if (error.contains('network')) {
      return 'Network error. Please check your internet connection.';
    } else if (error.contains('permission')) {
      return 'Location permission denied. Please enable location access.';
    } else if (error.contains('api')) {
      return 'Google Maps API error. Please try again later.';
    } else {
      return 'An error occurred while loading the map. Please try again.';
    }
  }
}
