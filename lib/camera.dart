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
        backgroundColor: Colors.black,
        body: SafeArea(child: Center(
          child: LayoutBuilder(builder: (context, constraints) {
            double canvasWidth = constraints.maxWidth;
            double canvasHeight = constraints.maxHeight;
            print("constraints" +
                constraints.maxWidth.toString() +
                " " +
                constraints.maxHeight.toString());

            return Container(
              height: ((canvasHeight / 10).floorToDouble()) * 10,
              width: ((canvasWidth / 10).floorToDouble()) * 10,
              child: LayoutBuilder(builder: (context, sss) {
                print(sss);
                return Stack(
                  alignment: Alignment.topLeft,
                  children: [
                    LayoutBuilder(builder: (context, ssss) {
                      print(ssss);
                      return Container(
                        height: double.infinity,
                        child: CameraPreview(_controller),
                      );
                    }),
                    Center(
                      child: CustomPaint(
                        painter: Rectangle(),
                      ),
                    ),
                    Container(
                      // width: 200,
                      // height: 320,
                      //decoration: BoxDecoration(border: Border.all(width: 1)),
                      child: CustomPaint(
                        painter: OpenPainter(canvasWidth, canvasHeight),
                      ),
                    ),
                    Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                            height: MediaQuery.of(context).size.height * 0.20,
                            decoration: const BoxDecoration(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(24)),
                                color: Colors.black),
                            child: Center(
                              child: IconButton(
                                onPressed: () async {
                                  print('work');
                                  if (!_controller.value.isInitialized) {
                                    print('controller not initialized');
                                    return;
                                  }
                                  // if (!_controller.value.isTakingPicture) {
                                  //   print('hii');
                                  //   return;
                                  // }

                                  try {
                                    print("try takepicture");
                                    await _controller
                                        .setFlashMode(FlashMode.off);
                                    XFile file =
                                        await _controller.takePicture();
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PreviewPage(
                                            file: file,
                                            photoCanvasWidth: canvasWidth,
                                            photoCanvasHeight: canvasHeight,
                                          ),
                                        ));
                                  } on CameraException catch (e) {
                                    debugPrint(
                                        'error ocured while taking picture : $e');
                                    return null;
                                  }
                                },
                                iconSize: 80,
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                icon: const Icon(Icons.circle,
                                    color: Colors.white),
                              ),
                            )))
                  ],
                );
              }),
            );
          }),
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

class OpenPainter extends CustomPainter {
  double canvasWidth;
  double canvasHeight;

  OpenPainter(this.canvasWidth, this.canvasHeight);
  @override
  void paint(Canvas canvas, Size size) {
    double xOffset = canvasWidth / 2 - 100;
    double yOffset = canvasHeight / 2 - 160;
    var paint1 = Paint()
      ..color = Color(0xFFF50707)
      ..strokeWidth = 10;

    var pointPaintRed = Paint()
      ..color = Color(0xFFF50707)
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 10;

    var pointPaintGreen = Paint()
      ..color = Color.fromARGB(255, 94, 245, 7)
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 10;

    var pointPaintBlue = Paint()
      ..color = Color.fromARGB(255, 7, 102, 245)
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 10;

    var pointPaintOrange = Paint()
      ..color = Color.fromARGB(255, 245, 142, 7)
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 10;

    var tPathpaint = Paint()
      ..color = Color.fromARGB(255, 9, 86, 230)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    //list of points
    var points = [
      Offset(xOffset + 0, yOffset + 0),
      Offset(xOffset + 200, yOffset + 0),
      Offset(xOffset + 0, yOffset + 220),
      Offset(xOffset + 100, yOffset + 320),
      Offset(xOffset + 200, yOffset + 220),
    ];
    //draw points on canvas
    canvas.drawPoints(ui.PointMode.points, points, paint1);

    var L1RedPoints = [
      Offset(xOffset + 30, yOffset + 190),
      Offset(xOffset + 170, yOffset + 190),
    ];

    canvas.drawPoints(ui.PointMode.points, L1RedPoints, pointPaintRed);

    var L2GreenPoints = [
      Offset(xOffset + 70, yOffset + 30),
      Offset(xOffset + 130, yOffset + 30),
    ];

    canvas.drawPoints(ui.PointMode.points, L2GreenPoints, pointPaintGreen);

    var L3BluePoints = [
      Offset(xOffset + 75, yOffset + 185),
      Offset(xOffset + 125, yOffset + 185),
    ];

    canvas.drawPoints(ui.PointMode.points, L3BluePoints, pointPaintBlue);

    var L4OrangePoints = [
      Offset(xOffset + 90, yOffset + 280),
      Offset(xOffset + 110, yOffset + 280),
    ];

    canvas.drawPoints(ui.PointMode.points, L4OrangePoints, pointPaintOrange);

    var tPath = Path()
      ..moveTo(xOffset + 0, yOffset + 0)
      ..lineTo(xOffset + 0, yOffset + 220)
      ..lineTo(xOffset + 100, yOffset + 320)
      ..lineTo(xOffset + 200, yOffset + 220)
      ..lineTo(xOffset + 200, yOffset + 0)
      ..close();

    canvas.drawPath(tPath, tPathpaint);
    tPath = Path()
      ..moveTo(0, 0)
      ..lineTo(0, 220)
      ..lineTo(100, 320)
      ..lineTo(180, 220)
      ..lineTo(200, 0)
      ..close();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
