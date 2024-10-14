// lib/attendance/camera_helper.dart
import 'package:camera/camera.dart';

Future<CameraController> initializeCamera(List<CameraDescription> cameras) async {
  final controller = CameraController(cameras[0], ResolutionPreset.high);
  await controller.initialize();
  return controller;
}
