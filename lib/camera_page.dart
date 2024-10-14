import 'dart:io';
import 'dart:typed_data'; // Add this import for ByteData
import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/rendering.dart';

class CameraPage extends StatefulWidget {
  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  late List<CameraDescription> cameras;
  CameraDescription? selectedCamera;
  List<String> _imagePaths = [];
  GlobalKey _imageKey = GlobalKey(); // Global key to capture the image with overlay

  @override
  void initState() {
    super.initState();
    _initCamera();
    _loadSavedImages();
  }

  // Initialize the camera
  Future<void> _initCamera() async {
    cameras = await availableCameras();
    selectedCamera = cameras.first;

    _controller = CameraController(
      selectedCamera!,
      ResolutionPreset.high,
    );

    _initializeControllerFuture = _controller.initialize();
    setState(() {});
  }

  // Load saved images from shared preferences
  Future<void> _loadSavedImages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _imagePaths = prefs.getStringList('imagePaths') ?? [];
    });
  }

  // Save the image paths to shared preferences
  Future<void> _saveImagePath(String imagePath) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _imagePaths.add(imagePath);
    await prefs.setStringList('imagePaths', _imagePaths);
  }

  // Function to get the current location
  Future<Position?> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return null;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return null;
    }

    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  // Function to capture and save the image with overlay
  Future<String> _saveImageWithOverlay(String imagePath) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      String newPath = path.join(directory.path, '${DateTime.now().millisecondsSinceEpoch}.png');

      // Create a widget that shows the image with the text overlay
      RenderRepaintBoundary boundary = _imageKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      var image = await boundary.toImage(pixelRatio: 3.0);
      Uint8List? byteData = (await image.toByteData(format: ImageByteFormat.png))?.buffer.asUint8List(); // Use Uint8List to avoid ambiguity
      if (byteData != null) {
        File(newPath).writeAsBytesSync(byteData);
      }

      // Save the new image path
      await _saveImagePath(newPath);
      return newPath;
    } catch (e) {
      print("Error saving image: $e");
      return '';
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Camera')),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              key: _imageKey, // Assign key to the widget to capture the image with overlay
              children: [
                CameraPreview(_controller),
                Positioned(
                  left: 10,
                  top: 10,
                  child: Text(
                    DateTime.now().toString(),
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      backgroundColor: Colors.black,
                    ),
                  ),
                ),
                Positioned(
                  left: 10,
                  top: 40,
                  child: FutureBuilder<Position?>(
                    future: _getCurrentLocation(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final position = snapshot.data!;
                        return Text(
                          "Lat: ${position.latitude}, Lng: ${position.longitude}",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            backgroundColor: Colors.black,
                          ),
                        );
                      } else {
                        return Text(
                          "Location: Unknown",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            backgroundColor: Colors.black,
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            await _initializeControllerFuture;
            final image = await _controller.takePicture();
            String savedImagePath = await _saveImageWithOverlay(image.path);

            if (savedImagePath.isNotEmpty) {
              if (!mounted) return;
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => DisplayPictureScreen(imagePath: savedImagePath),
                ),
              );
            }
          } catch (e) {
            print(e);
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({Key? key, required this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display Picture')),
      body: Center(
        child: Image.file(File(imagePath)),
      ),
    );
  }
}
