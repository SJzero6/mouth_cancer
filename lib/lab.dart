import 'dart:io';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:image/image.dart' as img;

Future<void> main() async {
  // Get a list of available cameras.
  final cameras = await availableCameras();

  // Get the first camera from the list.
  final firstCamera = cameras.first;

  // Create a CameraController instance.
  final controller = CameraController(
    firstCamera,
    ResolutionPreset.high,
  );

  // Initialize the camera.
  await controller.initialize();

  // Take a picture.
  final image = await controller.takePicture();

  // Read the image bytes.
  final bytes = await image.readAsBytes();

  // Decode the image to an Image instance.
  final imgInstance = img.decodeImage(bytes);

  // Convert the image to the LAB color space.
  final imgLab = img.copyRotate(imgInstance!, angle: 0);

  // Retrieve the LAB values of pixels at specified coordinates.
  final points = [
    [100, 100],
    [2000, 4000],
  ];

  for (final point in points) {
    final pixel = imgLab.getPixelSafe(point[0], point[1]);
    final l = pixel[0];
    final a = pixel[1];
    final b = pixel[2];
    print('');
    print('Point (${point[0]}, ${point[1]}):');
    print('L: $l');
    print('A: $a');
    print('B: $b');
  }

  // Dispose the camera controller.
  await controller.dispose();
}

/*
import 'dart:io';
import 'package:image/image.dart' as img;

void main() {
  final file = File('IMG_5873.jpg');
  final bytes = file.readAsBytesSync();
  final img_bgr = img.decodeImage(bytes);
  final img_lab = img.copyRotate(img_bgr, 0);
  final pixel = img_lab.getPixelSafe(100, 100);
  final l = pixel[0];
  final a = pixel[1];
  final b = pixel[2];
  print('');
  print('L: $l');
  print('A: $a');
  print('B: $b');
}
*/
