// A screen that takes in a list of cameras and the Directory to store images.
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

// A screen that allows users to take a picture using a given camera.
class TakePicturePage extends StatefulWidget {
  final CameraDescription camera;

  const TakePicturePage({
    Key key,
    @required this.camera,
  }) : super(key: key);

  @override
  TakePicturePageState createState() => TakePicturePageState();
}

class TakePicturePageState extends State<TakePicturePage> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Take a picture')),
      // Wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner
      // until the controller has finished initializing.
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return Column(
              children: <Widget>[
                SizedBox(
                  height: 500,
//                AspectRatio(
//                  aspectRatio: _controller.value.aspectRatio,
                    child: CameraPreview(_controller)
//                ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.black87,
                    child: Align(
                      alignment: Alignment.center,
                      child: FloatingActionButton(
                        child: Icon(Icons.camera),
                        // Provide an onPressed callback.
                        onPressed: () async {
                          // Take the Picture in a try / catch block. If anything goes wrong,
                          // catch the error.
                          try {
                            // Ensure that the camera is initialized.
                            await _initializeControllerFuture;

                            // Construct the path where the image should be saved using the
                            // pattern package.
                            final path = join(
                              // Store the picture in the temp directory.
                              // Find the temp directory using the `path_provider` plugin.
                              (await getApplicationSupportDirectory()).path,
                              '${DateTime.now()}.png',
                            );

                            // Attempt to take a picture and log where it's been saved.
                            await _controller.takePicture(path);

                            // If the picture was taken, display it on a new screen.
                            Navigator.pop(context, path);

                          } catch (e) {
                            // If an error occurs, log the error to the console.
                            print(e);
                          }
                        },
                      ),
                    ),
                  ),
                )
              ],
            );
          } else {
            // Otherwise, display a loading indicator.
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({Key key, this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Display the Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Image.file(File(imagePath)),
    );
  }
}