import 'dart:io';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GalleryPage extends StatefulWidget {
  final List<String> imagePaths;

  const GalleryPage({Key? key, required this.imagePaths}) : super(key: key);

  @override
  _GalleryPageState createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  late List<String> _imagePaths;

  @override
  void initState() {
    super.initState();
    _imagePaths = widget.imagePaths; // Use the passed imagePaths
  }

  Future<void> _deleteImage(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      File(_imagePaths[index]).deleteSync(); // Delete the file
      _imagePaths.removeAt(index); // Remove the path from the list
    });
    await prefs.setStringList('imagePaths', _imagePaths); // Update preferences
  }

  Future<void> _confirmDelete(int index) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Image'),
          content: const Text('Are you sure you want to delete this image?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                _deleteImage(index); // Delete the image
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gallery')),
      body: _imagePaths.isEmpty
          ? Center(child: Text('No images taken yet.'))
          : GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 4.0,
          mainAxisSpacing: 4.0,
        ),
        itemCount: _imagePaths.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => DisplayPictureScreen(imagePath: _imagePaths[index]),
                ),
              );
            },
            onLongPress: () => _confirmDelete(index), // Confirm before deletion
            child: Image.file(
              File(_imagePaths[index]),
              fit: BoxFit.cover,
            ),
          );
        },
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
