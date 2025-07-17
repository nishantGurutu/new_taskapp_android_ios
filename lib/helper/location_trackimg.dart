import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:geocoding/geocoding.dart' as geocode;

class LocationPage extends StatefulWidget {
  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  Location location = Location();
  LocationData? _currentPosition; // Use nullable type instead of late
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

      // Get initial location
      LocationData initialLocation = await location.getLocation();
      setState(() {
        _currentPosition = initialLocation;
        if (_currentPosition!.latitude != null &&
            _currentPosition!.longitude != null) {
          _getAddressFromLatLng(
              _currentPosition!.latitude!, _currentPosition!.longitude!);
        }
      });

      // Listen for location updates
      location.onLocationChanged.listen((LocationData currentLocation) {
        setState(() {
          _currentPosition = currentLocation;
          if (_currentPosition!.latitude != null &&
              _currentPosition!.longitude != null) {
            _getAddressFromLatLng(
                _currentPosition!.latitude!, _currentPosition!.longitude!);
          }
        });
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
