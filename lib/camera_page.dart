import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';

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

  // Function to store image in device storage
  Future<String> _saveImageToDevice(String imagePath) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      String newPath = path.join(directory.path, '${DateTime.now()}.png');
      File newImage = await File(imagePath).copy(newPath);
      await _saveImagePath(newImage.path);  // Save the image path
      return newImage.path;
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
            return CameraPreview(_controller);
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
            String savedImagePath = await _saveImageToDevice(image.path);

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
