import 'dart:async'; // For Timer
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For formatting date and time
import 'package:geolocator/geolocator.dart'; // For fetching location

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  String _currentTime = '';
  String _currentDate = '';
  String _currentLocation = 'Fetching location...';
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _updateTime();
    _fetchCurrentLocation();
  }

  // Update the time every second
  void _updateTime() {
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      final DateTime now = DateTime.now();
      setState(() {
        _currentTime = DateFormat('hh:mm a').format(now);
        _currentDate = DateFormat('EEEE, MMM d').format(now);
      });
    });
  }

  // Fetch current location using geolocator package
  Future<void> _fetchCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _currentLocation = 'Location services are disabled.';
      });
      return;
    }

    // Check for permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _currentLocation = 'Location permissions are permanently denied.';
        });
        return;
      } else if (permission == LocationPermission.denied) {
        setState(() {
          _currentLocation = 'Location permissions are denied.';
        });
        return;
      }
    }

    // Get the current position
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentLocation =
      'Lat: ${position.latitude}, Long: ${position.longitude}';
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Stop the timer when widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // User Profile Section
            Container(
              decoration: BoxDecoration(
                color: Colors.deepPurpleAccent,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  // Profile Image
                  CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage(
                      'https://via.placeholder.com/150', // Replace with actual image URL
                    ),
                  ),
                  SizedBox(width: 10),
                  // User Info
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Lorem Ipsum Dolor Sit',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Consequatur Elit.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            // Map placeholder (you can use GoogleMap widget here)
            Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(
                  image: NetworkImage(
                    'https://via.placeholder.com/400x200', // Replace with map image or widget
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 20),
            // Time Section
            Column(
              children: [
                Text(
                  _currentTime,
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  _currentDate,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
                Text(
                  _currentLocation,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            // In Time / Out Time Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text(
                      'IN TIME',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      _currentTime, // Replace this with the actual in-time value
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      'OUT TIME',
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '00:00 am', // Replace this with the actual out-time value
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20),
            // In Time Button
            ElevatedButton(
              onPressed: () {
                // Handle IN TIME logic here
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 64), backgroundColor: Colors.deepPurpleAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ), // Button background color
              ),
              child: Text(
                'IN TIME',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
            Spacer(),
            // Bottom Navigation Bar Placeholder
            // BottomNavigationBar(
            //   currentIndex: 0, // set the index for the active item
            //   items: [
            //     BottomNavigationBarItem(
            //       icon: Icon(Icons.home),
            //       label: 'Home',
            //     ),
            //     BottomNavigationBarItem(
            //       icon: Icon(Icons.access_time),
            //       label: 'Attendance',
            //     ),
            //     BottomNavigationBarItem(
            //       icon: Icon(Icons.settings),
            //       label: 'Settings',
            //     ),
            //   ],
            //   selectedItemColor: Colors.deepPurpleAccent,
            // ),
          ],
        ),
      ),
    );
  }
}
