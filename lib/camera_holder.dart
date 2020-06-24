import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraHolder {
  CameraDescription firstCamera;

  static final CameraHolder _cameraHolder = CameraHolder._internal();

  factory CameraHolder() {
    return _cameraHolder;
  }

  CameraHolder._internal();

  Future<void> initCameras() async {
    // Ensure that plugin services are initialized so that `availableCameras()`
    // can be called before `runApp()`
    WidgetsFlutterBinding.ensureInitialized();

    // Obtain a list of the available cameras on the device.
    final cameras = await availableCameras();

    // Get a specific camera from the list of available cameras.
    firstCamera = cameras.first;
  }
}
