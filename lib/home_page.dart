import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        backgroundColor: Colors.deepPurpleAccent,
        elevation: 0,
      ),
      body: PageView(
        scrollDirection: Axis.vertical, // Makes the containers scroll vertically
        children: [
          // Camera Button
          buildContainer(
            context,
            onTap: () {
              Navigator.of(context).pushNamed('/camera');
            },
            icon: Icons.camera_alt,
            title: 'Camera',
            gradientColors: [Colors.blueAccent, Colors.lightBlue],
          ),
          // Attendance Button
          buildContainer(
            context,
            onTap: () {
              Navigator.of(context).pushNamed('/attendance');
            },
            icon: Icons.assignment_turned_in,
            title: 'Attendance',
            gradientColors: [Colors.greenAccent, Colors.green],
          ),
          // Leave Button
          buildContainer(
            context,
            onTap: () {
              Navigator.of(context).pushNamed('/leave');
            },
            icon: Icons.date_range,
            title: 'Leave',
            gradientColors: [Colors.redAccent, Colors.deepOrange],
          ),
          // Gallery Button
          buildContainer(
            context,
            onTap: () {
              Navigator.of(context).pushNamed('/gallery');
            },
            icon: Icons.photo_library,
            title: 'Gallery',
            gradientColors: [Colors.purpleAccent, Colors.deepPurple],
          ),
        ],
      ),
    );
  }

  // Helper function to build the container with consistent design
  Widget buildContainer(
      BuildContext context, {
        required VoidCallback onTap,
        required IconData icon,
        required String title,
        required List<Color> gradientColors,
      }) {
    return InkWell(
      onTap: onTap,
      splashColor: gradientColors[0].withOpacity(0.4),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: gradientColors[0].withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 15,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 80, color: Colors.white),
            SizedBox(height: 20),
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
