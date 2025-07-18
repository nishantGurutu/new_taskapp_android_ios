import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:geocoding/geocoding.dart' as geocode;
import 'package:task_management/helper/db_helper.dart';
import 'package:task_management/helper/storage_helper.dart';

class LocationPage extends StatefulWidget {
  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  Location location = Location();
  LocationData? _currentPosition; // Nullable to avoid LateInitializationError
  String _currentAddress = "";

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  Future<void> _getLocation() async {
    try {
      // Check if location service is enabled
      bool _serviceEnabled = await location.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await location.requestService();
        if (!_serviceEnabled) {
          print('Location service disabled');
          return;
        }
      }

      // Check and request location permissions
      PermissionStatus _permissionGranted = await location.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
          print('Location permission denied');
          return;
        }
      }

      // Configure distance filter for location updates
      // await location.changeNotificationOptions(
      //   distanceFilter: 10, // Update every 10 meters
      // );

      // Get initial location
      LocationData initialLocation = await location.getLocation();
      if (initialLocation.latitude != null &&
          initialLocation.longitude != null) {
        setState(() {
          _currentPosition = initialLocation;
          _getAddressFromLatLng(
              initialLocation.latitude!, initialLocation.longitude!);
        });

        // Store initial location in DatabaseHelper
        final dbHelper = DatabaseHelper.instance;
        await dbHelper.insertLocation(
          StorageHelper.getId(),
          initialLocation.latitude!,
          initialLocation.longitude!,
          DateTime.now().toIso8601String(),
          initialLocation.accuracy ?? 0.0,
          initialLocation.altitude ?? 0.0,
          initialLocation.speed ?? 0.0,
        );
      }

      // Listen for location updates
      location.onLocationChanged.listen((LocationData currentLocation) async {
        if (currentLocation.latitude != null &&
            currentLocation.longitude != null) {
          setState(() {
            _currentPosition = currentLocation;
            _getAddressFromLatLng(
                currentLocation.latitude!, currentLocation.longitude!);
          });

          // Store location updates in DatabaseHelper
          final dbHelper = DatabaseHelper.instance;
          await dbHelper.insertLocation(
            StorageHelper.getId(),
            currentLocation.latitude!,
            currentLocation.longitude!,
            DateTime.now().toIso8601String(),
            currentLocation.accuracy ?? 0.0,
            currentLocation.altitude ?? 0.0,
            currentLocation.speed ?? 0.0,
          );
        }
      });
    } catch (e) {
      print('Error getting location: $e');
    }
  }

  Future<void> _getAddressFromLatLng(double lat, double lng) async {
    try {
      List<geocode.Placemark> placemarks =
          await geocode.placemarkFromCoordinates(lat, lng);
      geocode.Placemark place = placemarks[0];

      setState(() {
        _currentAddress =
            "${place.locality}, ${place.postalCode}, ${place.country}";
      });
    } catch (e) {
      print('Error getting address: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Location Example"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_currentPosition != null)
              Text(
                "Latitude: ${_currentPosition?.latitude ?? 0.0}, Longitude: ${_currentPosition?.longitude ?? 0.0}",
              ),
            if (_currentAddress != "")
              Text(
                "Address: $_currentAddress",
              ),
            ElevatedButton(
              onPressed: () {
                _getLocation();
              },
              child: Text("Get Location"),
            ),
          ],
        ),
      ),
    );
  }
}
