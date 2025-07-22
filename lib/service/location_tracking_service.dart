import 'package:dio/dio.dart';
import 'package:task_management/constant/custom_toast.dart';
import 'package:task_management/helper/db_helper.dart';
import 'package:task_management/helper/storage_helper.dart';

// class LocationTrackingService {
//   final Dio _dio = Dio();
//   final DatabaseHelper _dbHelper = DatabaseHelper.instance;

//   /// Syncs unsynced locations from the local database to the API.
//   Future<bool> syncLocationsToApi() async {
//     try {
//       // Fetch unsynced locations from the database
//       List<Map<String, dynamic>> unsyncedLocations =
//           await _dbHelper.getUnsyncedLocations();

//       if (unsyncedLocations.isEmpty) {
//         print('No unsynced locations to sync.');
//         CustomToast().showCustomToast('No unsynced locations to sync. in api');
//         return true;
//       }
//       final token = await StorageHelper.getToken();
//       print('Unsynced locations to sync: $unsyncedLocations');
//       _dio.options.headers = {
//         "Authorization": "Bearer $token",
//         "Accept": "application/json",
//         "Content-Type": "application/json",
//       };
//       print('Unsynced locations unauthorised: $token');

//       // Prepare location data for API
//       List<Map<String, dynamic>> locationsToSync =
//           unsyncedLocations.map((location) {
//         return {
//           "latitude": double.tryParse(location['latitude'].toString()) ?? 0.0,
//           "longitude": double.tryParse(location['longitude'].toString()) ?? 0.0,
//           "captured_at": location['timestamp'].toString(),
//         };
//       }).toList();

//       var userId = StorageHelper.getId();

//       print('Sending payload: ${{
//         "user_id": userId.toString(),
//         "locations": locationsToSync,
//       }}');

//       // Send locations to API
//       final response = await _dio.post(
//         'https://taskmaster.electionmaster.in/public/api/save-user-locations-json',
//         data: {
//           "user_id": userId,
//           "locations": locationsToSync,
//         },
//         options: Options(
//           headers: {
//             "Authorization": "Bearer $token",
//             "Accept": "application/json",
//             "Content-Type": "application/json",
//           },
//           followRedirects: false,
//           validateStatus: (status) => status! < 500,
//         ),
//       );

//       print('Response status: ${response.statusCode}');
//       print('Response data: ${response.data}');

//       if (response.statusCode == 200 || response.statusCode == 201) {
//         // Convert location IDs from dynamic to int
//         List<int> locationIds = unsyncedLocations
//             .map((location) => int.parse(location['id'].toString()))
//             .toList();

//         // Uncomment this when your DB method is ready
//         // await _dbHelper.markLocationsAsSynced(locationIds);

//         print('Successfully synced ${locationIds.length} locations to API.');
//         CustomToast().showCustomToast('Locations synced successfully.');
//         return true;
//       } else {
//         CustomToast().showCustomToast(
//           response.data['message'] ?? 'Failed to sync locations.',
//         );
//         return false;
//       }
//     } catch (e) {
//       print('Error syncing locations to API: $e');
//       CustomToast().showCustomToast('Failed to sync locations: $e');
//       return false;
//     }
//   }
// }

class LocationTrackingService {
  final Dio _dio = Dio();
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<bool> syncLocationsToApi({required String token}) async {
    try {
      List<Map<String, dynamic>> unsyncedLocations =
          await _dbHelper.getUnsyncedLocations();

      if (unsyncedLocations.isEmpty) {
        print('No unsynced locations to sync.');
        CustomToast().showCustomToast('No unsynced locations to sync. in api');
        return true;
      }

      print('Unsynced locations to sync: $unsyncedLocations');
      _dio.options.headers = {
        "Authorization": "Bearer $token",
        "Accept": "application/json",
        "Content-Type": "application/json",
      };

      List<Map<String, dynamic>> locationsToSync =
          unsyncedLocations.map((location) {
        return {
          "latitude": double.tryParse(location['latitude'].toString()) ?? 0.0,
          "longitude": double.tryParse(location['longitude'].toString()) ?? 0.0,
          "captured_at": location['timestamp'].toString(),
        };
      }).toList();

      var userId = StorageHelper.getId();

      final response = await _dio.post(
        'https://taskmaster.electionmaster.in/public/api/save-user-locations-json',
        data: {
          "user_id": userId,
          "locations": locationsToSync,
        },
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
            "Accept": "application/json",
            "Content-Type": "application/json",
          },
          followRedirects: false,
          validateStatus: (status) => status! < 500,
        ),
      );

      print('Response status: ${response.statusCode}');
      print('Response data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        List<int> locationIds = unsyncedLocations
            .map((location) => int.parse(location['id'].toString()))
            .toList();

        print('Successfully synced ${locationIds.length} locations to API.');
        CustomToast().showCustomToast('Locations synced successfully.');
        return true;
      } else {
        CustomToast().showCustomToast(
          response.data['message'] ?? 'Failed to sync locations.',
        );
        return false;
      }
    } catch (e) {
      print('Error syncing locations to API: $e');
      CustomToast().showCustomToast('Failed to sync locations: $e');
      return false;
    }
  }
}
