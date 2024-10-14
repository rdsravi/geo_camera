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
      body: GridView.count(
        crossAxisCount: 2, // Set the number of columns in the grid
        padding: EdgeInsets.all(10),
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
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
              Navigator.of(context).pushNamed('/calendar');
            },
            icon: Icons.date_range,
            title: 'Calendar',
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
          // Leaves Button
          buildContainer(
            context,
            onTap: () {
              Navigator.of(context).pushNamed('/leaves');
            },
            icon: Icons.nature_people,
            title: 'Leaves',
            gradientColors: [Colors.lightGreen, Colors.green],
          ),
          // My Working Site Button
          buildContainer(
            context,
            onTap: () {
              Navigator.of(context).pushNamed('/working_site');
            },
            icon: Icons.location_on,
            title: 'My Working Site',
            gradientColors: [Colors.blueAccent, Colors.blue],
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
      splashColor: gradientColors[0].withOpacity(1),
      child: Container(
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
            Icon(icon, size: 50, color: Colors.white), // Icon with size increased
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16, // Font size increased
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
