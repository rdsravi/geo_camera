import 'dart:async'; // For Timer
import 'dart:io'; // For File
import 'package:flutter/material.dart';
import 'package:camera/camera.dart'; // For camera functionality
import 'package:geo_camera/attendance/time_helper.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path_provider/path_provider.dart'; // For saving files
import 'package:path/path.dart';
import 'package:geocoding/geocoding.dart'; // Import the geocoding package
import '../calender_page.dart';
import 'camera_helper.dart';

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
  CameraController? _controller;
  List<CameraDescription> cameras = [];
  String? imagePath; // To store the path of the captured image
  bool isInTime = true; // Track if it's IN TIME or OUT TIME

  // Attendance List to store attendance data
  List<Event> attendanceList = []; // New attendance list

  @override
  void initState() {
    super.initState();
    _updateTime();
    _fetchCurrentLocation();
    _initializeCamera();
  }

  // Initialize the camera
  Future<void> _initializeCamera() async {
    cameras = await availableCameras();
    _controller = await initializeCamera(cameras);
    setState(() {});
  }

  // Update the time every second
  void _updateTime() {
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      final DateTime now = DateTime.now();
      setState(() {
        _currentTime = formatTime(now); // Use the helper function
        _currentDate = formatDate(now); // Use the helper function
      });
    });
  }


// Fetch current location using geolocator package
  Future<void> _fetchCurrentLocation() async {
    // Request location permission
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
      // Get current position
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

      // Use the latitude and longitude from the position
      List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);

      if (placemarks.isNotEmpty) {
        Placemark placemark = placemarks[0];
        setState(() {
          // Build the full address from available components
          _currentLocation = "${placemark.name}, ${placemark.street}, ${placemark.locality}, "
              "${placemark.administrativeArea}, ${placemark.postalCode}, ${placemark.country}";
        });
      } else {
        setState(() {
          _currentLocation = "Unable to fetch address";
        });
      }
    } else {
      setState(() {
        _currentLocation = "Location permission denied";
      });
    }
  }



  // Capture the image
  Future<void> _captureImage() async {
    if (_controller == null) return;

    try {
      // Capture the image
      final image = await _controller!.takePicture();

      // Get the temporary directory to save the image
      final directory = await getTemporaryDirectory();
      final imagePath = join(directory.path, 'attendance_${DateTime.now()}.png');

      // Save the image file
      await File(image.path).copy(imagePath);

      // Update state with the captured image path
      setState(() {
        this.imagePath = imagePath;
        isInTime = false; // Change to OUT TIME after capturing
      });

      // Save attendance data with the current date
      String attendanceTitle = isInTime ? 'In Time' : 'Out Time';
      attendanceList.add(Event(
        attendanceTitle,
        imagePath: imagePath,
        time: _currentTime,
        location: _currentLocation,
        date: DateTime.now(), // Save the current date
      ));

      // Print additional data
      print('Image saved at: $imagePath');
      print('Time: $_currentTime');
      print('Date: $_currentDate');
      print('Location: $_currentLocation');
    } catch (e) {
      print('Error capturing image: $e');
    }
  }

  @override
  void dispose() {
    _controller?.dispose(); // Dispose the camera controller
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
                        'Full Name',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Worker type',
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
            // Camera Preview Section
            _controller == null
                ? Center(child: CircularProgressIndicator())
                : Container(
              height: 200,
              width: double.infinity,
              child: CameraPreview(_controller!),
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
                      isInTime ? 'IN TIME' : 'OUT TIME',
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
                      isInTime ? 'N/A' : _currentTime, // Replace this with the actual out-time value
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
                _captureImage(); // Capture image when button is pressed
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 64),
                backgroundColor: Colors.deepPurpleAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ), // Button background color
              ),
              child: Text(
                isInTime ? 'IN TIME' : 'OUT TIME', // Change button text
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
            Spacer(),

            // Calendar Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CalenderPage(attendanceList: attendanceList), // Pass the attendance list
                    ),
                  );
                },
                child: Text('Calendar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
