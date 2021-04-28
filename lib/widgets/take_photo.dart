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
  AnimationController _focusModeControlRowAnimationController;
  Animation<double> _focusModeControlRowAnimation;

  bool isClickable = true;

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

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text('Take a picture')),
      // Wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner
      // until the controller has finished initializing.
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return Stack(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height,
                  color: Colors.black,
                ),
                Container(
                  child: AspectRatio(
                    //previewSize.width / previewSize.height
                    // aspectRatio: _controller.value.aspectRatio,
                    aspectRatio: _controller.value.previewSize.height /
                        _controller.value.previewSize.width,
                    child: CameraPreview(_controller),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    color: Colors.black87,
                    padding: const EdgeInsets.all(36.0),
                    child: Align(
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          FloatingActionButton(
                            child: Icon(Icons.camera),
                            // Provide an onPressed callback.
                            onPressed: isClickable
                                ? () => onFloatingButtonClick(context)
                                : null,
                          ),
                          _focusModeControlRowWidget(),
                        ],
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

  void onFloatingButtonClick(BuildContext context) async {
    // Take the Picture in a try / catch block. If anything goes wrong,
    // catch the error.
    setState(() {
      isClickable = false;
    });

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
      var xfile = await _controller.takePicture();

      print(xfile.path);
      xfile.saveTo(path);

      // If the picture was taken, display it on a new screen.
      Navigator.pop(context, path);
    } catch (e) {
      // If an error occurs, log the error to the console.
      print(e);

      setState(() {
        isClickable = true;
      });
    }
  }

  Widget _focusModeControlRowWidget() {
    final ButtonStyle styleAuto = TextButton.styleFrom(
      primary: _controller?.value?.focusMode == FocusMode.auto
          ? Colors.orange
          : Colors.blue,
    );
    final ButtonStyle styleLocked = TextButton.styleFrom(
      primary: _controller?.value?.focusMode == FocusMode.locked
          ? Colors.orange
          : Colors.blue,
    );

    return Container(
      child: Column(
        children: [
          Center(
            child: Text(
              "Focus Mode",
              style: TextStyle(color: Colors.white),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            children: [
              TextButton(
                child: Text('AUTO'),
                style: styleAuto,
                onPressed: _controller != null
                    ? () => onSetFocusModeButtonPressed(FocusMode.auto)
                    : null,
                onLongPress: () {
                  if (_controller != null) _controller.setFocusPoint(null);
                  showInSnackBar('Resetting focus point');
                },
              ),
              TextButton(
                child: Text('LOCKED'),
                style: styleLocked,
                onPressed: _controller != null
                    ? () => onSetFocusModeButtonPressed(FocusMode.locked)
                    : null,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void onSetFocusModeButtonPressed(FocusMode mode) {
    setFocusMode(mode).then((_) {
      if (mounted) setState(() {});
      showInSnackBar('Focus mode set to ${mode.toString().split('.').last}');
    });
  }

  Future<void> setFocusMode(FocusMode mode) async {
    try {
      await _controller.setFocusMode(mode);
    } on CameraException catch (e) {
      _showCameraException(e);
      rethrow;
    }
  }

  void _showCameraException(CameraException e) {
    print('Error: ${e.code}\nError Message: ${e.description}');
    showInSnackBar('Error: ${e.code}\n${e.description}');
  }

  void showInSnackBar(String message) {
    // ignore: deprecated_member_use
    // _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
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
