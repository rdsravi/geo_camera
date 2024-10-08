import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home Page')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed('/camera');
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.5),
                        spreadRadius: 3,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.camera_alt, size: 64, color: Colors.white),
                      SizedBox(height: 8),
                      Text('Camera', style: TextStyle(color: Colors.white, fontSize: 24)),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  // Attendance functionality here
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.greenAccent,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.5),
                        spreadRadius: 3,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.assignment_turned_in, size: 64, color: Colors.white),
                      SizedBox(height: 8),
                      Text('Attendance', style: TextStyle(color: Colors.white, fontSize: 24)),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  // Leave functionality here
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.red.withOpacity(0.5),
                        spreadRadius: 3,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.date_range, size: 64, color: Colors.white),
                      SizedBox(height: 8),
                      Text('Leave', style: TextStyle(color: Colors.white, fontSize: 24)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
