import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:scannerv3/image_preview.dart';
import 'package:scannerv3/models/exam.dart';
import 'package:scannerv3/overlay.dart';

class CameraScreen extends StatefulWidget {
  final Exam exam;
  const CameraScreen({super.key, required this.exam});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  CameraDescription? _camera;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      // Fetch available cameras
      final cameras = await availableCameras();
      _camera = cameras.first;

      _controller = CameraController(_camera!, ResolutionPreset.medium,
          enableAudio: false);

      // Initialize the controller
      _initializeControllerFuture = _controller.initialize();
      setState(() {}); // Rebuild after the camera is initialized
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> takePicture() async {
    // show loading screen

    try {
      // Ensure the camera is initialized
      await _initializeControllerFuture;

      // Capture the image
      final image = await _controller.takePicture();

      // Show a simple alert dialog when done
      if (mounted) {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                  title: const Text('Image Captured!'),
                  content: const Text('Image saved and processed for OpenCV'),
                  actions: <Widget>[
                    TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ImagePreviewScreen(
                                      imagePath: image.path,
                                      exam: widget.exam)));
                        },
                        child: const Text('OK'))
                  ]);
            });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(41, 46, 50, 1),
      appBar: AppBar(
          title: Text('Capture Bubble Sheet'),
          backgroundColor: const Color.fromRGBO(101, 188, 80, 1)),
      body: _camera == null
          ? const Center(
              child:
                  CircularProgressIndicator()) // Show loading if camera is not ready
          : FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  // Display the camera preview when the camera is ready
                  return Stack(
                    children: [
                      CameraPreview(_controller,
                          child: CustomPaint(
                            size: Size.infinite,
                            painter: OverlayPainter(),
                          )),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: FloatingActionButton(
                                // Capture and process image
                                onPressed: takePicture,
                                child: const Icon(Icons.camera))),
                      ),
                    ],
                  );
                } else {
                  // If the camera is still loading, show a spinner
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
    );
  }
}
