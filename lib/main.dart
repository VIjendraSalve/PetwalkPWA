import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PWA Location Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LocationTrackerPage(),
    );
  }
}

class LocationTrackerPage extends StatefulWidget {
  const LocationTrackerPage({super.key});

  @override
  State<LocationTrackerPage> createState() => _LocationTrackerPageState();
}

class _LocationTrackerPageState extends State<LocationTrackerPage> {
  String latitude = "";
  String longitude = "";
  String speed = "";

  @override
  void initState() {
    super.initState();
    _startLocationTracking();
  }

  void _startLocationTracking() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        latitude = "Location services are disabled.";
        longitude = "";
        speed = "";
      });
      return;
    }

    // Check location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          latitude = "Location permissions are denied.";
          longitude = "";
          speed = "";
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        latitude = "Location permissions are permanently denied.";
        longitude = "";
        speed = "";
      });
      return;
    }

    // Continuously get location updates
    Geolocator.getPositionStream(locationSettings: LocationSettings(accuracy: LocationAccuracy.best, distanceFilter: 10)).listen((Position position) {
      setState(() {
        latitude = position.latitude.toString();
        longitude = position.longitude.toString();
        speed = position.speed.toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PWA Location Tracker'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Current Location:',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 10),
            Text('Latitude: $latitude', style: const TextStyle(fontSize: 16)),
            Text('Longitude: $longitude', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text('Speed: $speed m/s', style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
