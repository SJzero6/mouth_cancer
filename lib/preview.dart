import 'dart:io';
import 'dart:ui' as ui;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_color_models/flutter_color_models.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mouth_cancer/camera.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/services.dart' show rootBundle;

class PreviewPage extends StatefulWidget {
  PreviewPage(
      {required this.file,
      required this.photoCanvasWidth,
      required this.photoCanvasHeight,
      super.key});
  XFile file;

  double photoCanvasWidth;
  double photoCanvasHeight;

  @override
  State<PreviewPage> createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> {
  GlobalKey repaintKey = GlobalKey();
  var val = [0.0, 0.0, 0, 0, 0];

  List relCoordinates = [
    [0, 0],
    [400, 400],
    [1000, 1000]
  ];

  var labValuesList = [
    [0.0, 0.0, 0.0],
    [0.0, 0.0, 0.0],
    [0.0, 0.0, 0.0],
    [0.0, 0.0, 0.0],
  ];

  @override
  Widget build(BuildContext context) {
    File picture = File(widget.file.path);

    getPixelValuesFromImage(
        String capImgPath, double maxWidth, double maxHeight) async {
      double xOffset = widget.photoCanvasWidth / 2 - 100;
      double yOffset = widget.photoCanvasHeight / 2 - 160;
      var refPoints = [
        [xOffset + 30, yOffset + 190],
        [xOffset + 70, yOffset + 30],
        [xOffset + 75, yOffset + 185],
        [xOffset + 90, yOffset + 280]
      ];

      print("max widths $maxWidth , $maxHeight");

      await Future.delayed(Duration.zero);

      // RenderBox box =
      //     repaintKey.currentContext?.findRenderObject() as RenderBox;

      // print("Box sixe ${box.size.width}, ${box.size.height}");
      File capImgFile = File(capImgPath);
      Uint8List values = capImgFile.readAsBytesSync();

      img.Image capImg = img.decodeImage(values)!;

      print("Image width and height ${capImg.width}, ${capImg.height}");

      List<List<double>> labValues = [];

      for (var point in refPoints) {
        img.Pixel pixel32 =
            capImg.getPixelSafe(point[0].toInt(), point[1].toInt());

        print("Pixel 32 value ${pixel32.r},${pixel32.g},${pixel32.b}");
        print("${pixel32.r},${pixel32.g},${pixel32.b}");
        print("pixel[0] ${pixel32[0]}, ${pixel32[1]}, ${pixel32[2]}");

        Color color = Color.fromRGBO(
            pixel32.r.toInt(), pixel32.g.toInt(), pixel32.b.toInt(), 1);

        LabColor labColor = LabColor.from(RgbColor.fromColor(color));
        labValues.add([
          double.parse(labColor.lightness.toStringAsFixed(1)),
          double.parse(labColor.a.toStringAsFixed(1)),
          double.parse(labColor.b.toStringAsFixed(1)),
        ]);

        setState(() {
          labValuesList = labValues;
        });
      }
      return labValues;
    }

    //getPixelValuesFromImage(widget.file.path);

    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  getPixelValuesFromImage(widget.file.path,
                      constraints.maxWidth, constraints.maxHeight);
                  return RepaintBoundary(
                      key: repaintKey, child: Image.file(picture));
                },
              ),
            ),
            Table(
              children: [
                TableRow(children: [
                  TableCell(child: Text("")),
                  TableCell(child: Text("L")),
                  TableCell(child: Text("a")),
                  TableCell(child: Text("b")),
                ]),
                for (int i = 0; i < 4; i++)
                  TableRow(children: [
                    TableCell(child: Text("${i + 1}")),
                    TableCell(child: Text("${labValuesList[i][0]}")),
                    TableCell(child: Text("${labValuesList[i][1]}")),
                    TableCell(child: Text("${labValuesList[i][2]}")),
                  ])
              ],
            ),
            // Text(
            //     "${val[0].toStringAsFixed(2)}x${val[1].toStringAsFixed(2)} (${val[2]}, ${val[3]}, ${val[4]})"),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CameraPage(),
                      ));
                },
                child: Text('back to camera'))
          ],
        ),
      ),
    );
  }
}
