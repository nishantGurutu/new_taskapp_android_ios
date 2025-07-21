import 'package:flutter/material.dart';
import 'package:location/location.dart';

class LocationPage extends StatefulWidget {
  @override
  _LocationPageState createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  Location location = Location();
  LocationData? _currentPosition;
  String _currentAddress = "";

  @override
  void initState() {
    super.initState();
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
              onPressed: () {},
              child: Text("Get Location"),
            ),
          ],
        ),
      ),
    );
  }
}
