import 'package:dio/dio.dart';
import 'package:task_management/constant/custom_toast.dart';
import 'package:task_management/helper/db_helper.dart';
import 'package:task_management/helper/storage_helper.dart';

class LocationTrackingService {
  final Dio _dio = Dio();
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  /// Syncs unsynced locations from the local database to the API.
  Future<bool> syncLocationsToApi() async {
    try {
      // Fetch unsynced locations from the database
      List<Map<String, dynamic>> unsyncedLocations =
          await _dbHelper.getUnsyncedLocations();
      if (unsyncedLocations.isEmpty) {
        print('No unsynced locations to sync.');
        CustomToast().showCustomToast('No unsynced locations to sync. in api');
        return true;
      }

      // Prepare location data for API
      var userId = StorageHelper.getId();
      List<Map<String, dynamic>> locationsToSync =
          unsyncedLocations.map((location) {
        return {
          "latitude": double.parse(location['latitude'].toString()),
          "longitude": double.parse(location['longitude'].toString()),
          "captured_at": location['timestamp'],
        };
      }).toList();

      // Log the payload
      print('Sending payload: ${{
        "user_id": userId,
        "locations": locationsToSync,
      }}');

      // Send locations to API
      final response = await _dio.post(
        'https://taskmaster.electionmaster.in/public/api/save-user-locations-json',
        data: {
          "user_id": userId,
          "locations": locationsToSync,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      print('Response status: ${response.statusCode}');
      print('Response data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        List<int> locationIds =
            unsyncedLocations.map((location) => location['id'] as int).toList();
        // await _dbHelper.markLocationsAsSynced(locationIds);
        print('Successfully synced ${locationIds.length} locations to API.');
        CustomToast().showCustomToast('Locations synced successfully. in api');
        return true;
      } else {
        CustomToast().showCustomToast(
            response.data['message'] ?? 'Failed to sync locations. in api');
        return false;
      }
    } catch (e) {
      print('Error syncing locations to API: $e');
      CustomToast().showCustomToast('Failed to sync locations: $e');
      return false;
    }
  }
}
