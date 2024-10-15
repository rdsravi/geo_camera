import 'package:flutter/material.dart';
import 'package:geo_camera/gallery_page.dart';
import 'calender_page.dart';
import 'camera_page.dart';
import 'splash_screen.dart';
import 'login_page.dart';
import 'home_page.dart';
import 'attendance/attendance_page.dart';
import 'leaves/leaves_page.dart';
import 'working_site_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/login': (context) => LoginPage(),
        '/home': (context) => HomePage(),
        '/camera': (context) => CameraPage(), // Implement the CameraPage here
        '/gallery': (context) => GalleryPage(imagePaths: []), // Pass imagePaths
        '/attendance': (context) => AttendancePage(), // Implement AttendancePage
        '/calendar': (context) => CalenderPage(attendanceList: [],),
        '/leaves': (context) => LeavesPage(), // Implement LeavesPage
        '/working_site': (context) => WorkingSitePage(), // Implement WorkingSitePage
      },
    );
  }
}
