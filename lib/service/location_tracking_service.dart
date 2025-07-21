import 'package:dio/dio.dart';
import 'package:task_management/constant/custom_toast.dart';
import 'package:task_management/helper/db_helper.dart';
import 'package:task_management/helper/storage_helper.dart';

class LocationTrackingService {
  final Dio _dio = Dio();
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  Future<dynamic> locationTracking() async {
    try {
      var userId = StorageHelper.getId();
      final response = await _dio.post(
          'https://taskmaster.electionmaster.in/public/api/save-user-locations-json',
          data: {
            "user_id": userId,
            "locations": [
              {
                "latitude": 28.6139,
                "longitude": 77.2090,
                "captured_at": "2025-07-19 10:00:00"
              },
              {
                "latitude": 28.6150,
                "longitude": 77.2100,
                "captured_at": "2025-07-19 10:15:00"
              }
            ]
          });

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      } else {
        CustomToast().showCustomToast(response.data['message']);
      }
    } catch (e) {
      CustomToast().showCustomToast('Something went wrong.');
      return null;
    }
    return null;
  }

  /// Syncs unsynced locations from the local database to the API.
  Future<bool> syncLocationsToApi() async {
    try {
      // Fetch unsynced locations from the database
      List<Map<String, dynamic>> unsyncedLocations =
          await _dbHelper.getUnsyncedLocations();
      if (unsyncedLocations.isEmpty) {
        print('No unsynced locations to sync.');
        return true;
      }

      // Prepare location data for API
      var userId = StorageHelper.getId();
      List<Map<String, dynamic>> locationsToSync =
          unsyncedLocations.map((location) {
        return {
          "latitude": location['latitude'],
          "longitude": location['longitude'],
          "captured_at": location['timestamp'],
        };
      }).toList();

      // Send locations to API
      final response = await _dio.post(
        'https://taskmaster.electionmaster.in/public/api/save-user-locations-json',
        data: {
          "user_id": userId,
          "locations": locationsToSync,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Mark locations as synced in the database
        List<int> locationIds =
            unsyncedLocations.map((location) => location['id'] as int).toList();
        await _dbHelper.markLocationsAsSynced(locationIds);
        print('Successfully synced ${locationIds.length} locations to API.');
        CustomToast().showCustomToast('Locations synced successfully.');
        return true;
      } else {
        CustomToast().showCustomToast(
            response.data['message'] ?? 'Failed to sync locations.');
        return false;
      }
    } catch (e) {
      print('Error syncing locations to API: $e');
      CustomToast().showCustomToast('Failed to sync locations.');
      return false;
    }
  }
}
