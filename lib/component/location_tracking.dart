import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart' as perm;
import 'package:geocoding/geocoding.dart' as geocode;
import 'package:task_management/helper/db_helper.dart';
import 'package:task_management/service/location_tracking_service.dart'; // Import DatabaseHelper

/// A service class to manage location tracking functionality, including
/// initialization, permission handling, and background location updates.
class LocationTrackerService {
  static final Location _location = Location();
  static final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  static final LocationTrackingService _trackingService =
      LocationTrackingService();
  static Timer? _syncTimer;

  /// Initializes location services by checking and requesting service and permissions.
  /// Returns true if initialization is successful, false otherwise.
  static Future<bool> initialize() async {
    try {
      // Check if location service is enabled
      bool serviceEnabled = await _location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await _location.requestService();
        if (!serviceEnabled) {
          print('Location service is disabled.');
          return false;
        }
      }

      // Check and request location permission
      PermissionStatus permissionGranted = await _location.hasPermission();
      if (permissionGranted == PermissionStatus.denied) {
        permissionGranted = await _location.requestPermission();
        if (permissionGranted != PermissionStatus.granted &&
            permissionGranted != PermissionStatus.grantedLimited) {
          print('Location permission denied.');
          return false;
        }
      }

      // Start periodic syncing
      startPeriodicSync();

      return true;
    } catch (e) {
      print('Error initializing location service: $e');
      return false;
    }
  }

  /// Starts periodic syncing of locationsizations every 5 minutes.
  static void startPeriodicSync() {
    _syncTimer?.cancel();
    _syncTimer = Timer.periodic(Duration(minutes: 5), (timer) async {
      print('Attempting periodic sync at ${DateTime.now()}');
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        print('No network available, skipping sync.');
        return;
      }
      await _trackingService.syncLocationsToApi();
    });
  }

  /// Stops periodic syncing.
  static void stopPeriodicSync() {
    _syncTimer?.cancel();
    _syncTimer = null;
    print('Periodic sync stopped.');
  }

  /// Retrieves the current location of the device.
  /// Returns null if the location cannot be obtained.
  Future<LocationData?> getCurrentLocation() async {
    try {
      await _getLocation(); // Start tracking and store in DB
      return _currentPosition;
    } catch (e) {
      print('Error getting current location: $e');
      return null;
    }
  }

  /// Enables background location tracking if supported and permitted.
  /// Returns true if background mode is enabled successfully, false otherwise.
  static Future<bool> enableBackgroundMode() async {
    try {
      // Ensure necessary permissions are granted
      bool hasPermissions = await _requestLocationPermissions();
      if (!hasPermissions) {
        print('Required permissions not granted for background mode.');
        return false;
      }

      // Check if background mode is already enabled
      bool isBackgroundEnabled = await _location.isBackgroundModeEnabled();
      if (!isBackgroundEnabled) {
        await _location.enableBackgroundMode(enable: true);
        print('Background mode enabled.');
      }
      return true;
    } catch (e) {
      print('Error enabling background location: $e');
      return false;
    }
  }

  /// Requests necessary location permissions for foreground and background tracking.
  /// Returns true if all required permissions are granted, false otherwise.
  static Future<bool> _requestLocationPermissions() async {
    try {
      // Request location permissions
      Map<perm.Permission, perm.PermissionStatus> statuses = await [
        perm.Permission.location,
        perm.Permission.locationWhenInUse,
        perm.Permission.locationAlways, // Required for background tracking
      ].request();

      // Check if required permissions are granted
      bool isLocationGranted = statuses[perm.Permission.location]!.isGranted ||
          statuses[perm.Permission.locationWhenInUse]!.isGranted;
      bool isBackgroundGranted =
          statuses[perm.Permission.locationAlways]!.isGranted;

      if (!isLocationGranted) {
        print('Location permission denied.');
        return false;
      }

      if (!isBackgroundGranted && (await _requiresBackgroundLocation())) {
        print('Background location permission denied.');
        return false;
      }

      return true;
    } catch (e) {
      print('Error requesting permissions: $e');
      return false;
    }
  }

  /// Determines if background location permission is required based on the platform.
  static Future<bool> _requiresBackgroundLocation() async {
    // Background location is typically required for Android 10+ and iOS
    return true; // Modify based on your app's requirements and platform checks
  }

  Location location = Location();
  LocationData? _currentPosition;
  String _currentAddress = "";

  /// Starts location tracking and stores location data in the database.
  Future<void> _getLocation() async {
    try {
      bool _serviceEnabled = await location.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await location.requestService();
        if (!_serviceEnabled) {
          print('Location service disabled');
          return;
        }
      }

      PermissionStatus _permissionGranted = await location.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
          print('Location permission denied');
          return;
        }
      }

      // Get initial location and store in DB
      LocationData initialLocation = await location.getLocation();
      if (initialLocation.latitude != null &&
          initialLocation.longitude != null) {
        _currentPosition = initialLocation;
        await _storeLocationInDb(initialLocation); // Store in DB
        _getAddressFromLatLng(
            initialLocation.latitude!, initialLocation.longitude!);
        // Attempt to sync locations to API after storing
        var connectivityResult = await Connectivity().checkConnectivity();
        if (connectivityResult != ConnectivityResult.none) {
          await _trackingService.syncLocationsToApi();
        }
      }

      // Listen for location updates and store in DB
      location.onLocationChanged.listen((LocationData currentLocation) async {
        if (currentLocation.latitude != null &&
            currentLocation.longitude != null) {
          _currentPosition = currentLocation;
          await _storeLocationInDb(currentLocation); // Store in DB
          _getAddressFromLatLng(
              currentLocation.latitude!, currentLocation.longitude!);
          // Attempt to sync locations to API after storing
          var connectivityResult = await Connectivity().checkConnectivity();
          if (connectivityResult != ConnectivityResult.none) {
            await _trackingService.syncLocationsToApi();
          }
        }
      });
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  /// Stores location data in the database.
  Future<void> _storeLocationInDb(LocationData locationData) async {
    try {
      await _dbHelper.insertLocation(
        locationData.latitude!,
        locationData.longitude!,
        DateTime.now().toIso8601String(), // Timestamp
        locationData.accuracy ?? 0.0,
        locationData.altitude ?? 0.0,
        locationData.speed ?? 0.0,
      );
      print(
          'Location stored in database: ${locationData.latitude}, ${locationData.longitude}');
    } catch (e) {
      print('Error storing location in database: $e');
    }
  }

  /// Converts latitude and longitude to an address.
  Future<void> _getAddressFromLatLng(double lat, double lng) async {
    try {
      List<geocode.Placemark> placemarks =
          await geocode.placemarkFromCoordinates(lat, lng);
      geocode.Placemark place = placemarks[0];
      _currentAddress =
          "${place.locality}, ${place.postalCode}, ${place.country}";
    } catch (e) {
      print('Error getting address: $e');
    }
  }
}
