// ignore_for_file: avoid_unnecessary_containers

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:mouth_cancer/main.dart';
import 'dart:ui' as ui;

import 'package:mouth_cancer/preview.dart';
// import 'package:flutter_camera_practice/preview_page.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController _controller;
  @override
  void initState() {
    super.initState();
    _controller = CameraController(cameras[0], ResolutionPreset.max);
    _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'camera accesss denied':
            print('acess denied');
            break;
          default:
            print(e.description);
            break;
        }
      }
    });
  }

  final _isRearCameraSelected = true;

  Widget build(BuildContext context) {
    // Size size = Size.fromWidth(MediaQuery.of(context).size.width);
    return Scaffold(
        body: SafeArea(
            child: Stack(
      children: [
        Container(
          height: double.infinity,
          child: CameraPreview(_controller),
        ),
        Center(
          child: CustomPaint(
            painter: Rectangle(),
          ),
        ),
        Align(
            alignment: Alignment.bottomCenter,
            child: Container(
                height: MediaQuery.of(context).size.height * 0.20,
                decoration: const BoxDecoration(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(24)),
                    color: Colors.black),
                child: Center(
                  child: IconButton(
                    onPressed: () async {
                      print('work');
                      if (!_controller.value.isInitialized) {
                        print('hello');
                        return;
                      }
                      // if (!_controller.value.isTakingPicture) {
                      //   print('hii');
                      //   return;
                      // }

                      try {
                        print("kope");
                        await _controller.setFlashMode(FlashMode.auto);
                        XFile file = await _controller.takePicture();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PreviewPage(file: file),
                            ));
                      } on CameraException catch (e) {
                        debugPrint('error ocured while taking picture : $e');
                        return null;
                      }
                    },
                    iconSize: 80,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: const Icon(Icons.circle, color: Colors.white),
                  ),
                )))
      ],
    )));
  }
}

class Rectangle extends CustomPainter {
  bool? isFilled;
  Rectangle({this.isFilled});
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    paint.color = Colors.amber;
    if (isFilled != null) {
      paint.style = PaintingStyle.fill;
    } else {
      paint.style = PaintingStyle.stroke;
    }
    paint.strokeCap = StrokeCap.round;
    paint.strokeJoin = StrokeJoin.round;
    paint.strokeWidth = 2;
    Offset a = Offset(size.width * 1 / 6, size.height);

    Rect rect = Rect.fromCenter(center: a, width: 200, height: 320);
    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(covariant Rectangle oldDelegate) {
    return false;
  }
}
