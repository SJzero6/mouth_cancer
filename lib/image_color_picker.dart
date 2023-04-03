import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:image/image.dart' as img;

class ColorPickerWidget extends StatefulWidget {
  @override
  _ColorPickerWidgetState createState() => _ColorPickerWidgetState();
}

class _ColorPickerWidgetState extends State {
  String imagePath = "assets/images/iii.png";
  GlobalKey imageKey = GlobalKey();
  GlobalKey paintKey = GlobalKey();

// CHANGE THIS FLAG TO TEST BASIC IMAGE, AND SNAPSHOT.
  bool useSnapshot = true;

// based on useSnapshot=true ? paintKey : imageKey ;
// this key is used in this example to keep the code shorter.
  late GlobalKey currentKey;

  final StreamController _stateController = StreamController();
  img.Image? photo;

  @override
  void initState() {
    currentKey = useSnapshot ? paintKey : imageKey;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final String title = useSnapshot ? "snapshot" : "basic";
    print(title);
    return Scaffold(
      appBar: AppBar(title: Text("Color picker $title")),
      body: StreamBuilder(
          initialData: Colors.green[500],
          stream: _stateController.stream,
          builder: (buildContext, snapshot) {
            Color selectedColor = (snapshot.data ?? Colors.green) as Color;
            return Stack(
              children: [
                RepaintBoundary(
                  key: paintKey,
                  child: GestureDetector(
                    onPanDown: (details) {
                      searchPixel(details.globalPosition);
                    },
                    onPanUpdate: (details) {
                      searchPixel(details.globalPosition);
                    },
                    child: Image.asset(
                      imagePath,
                      key: imageKey,
                      height: 500,
                      width: 500,
//color: Colors.red,
//colorBlendMode: BlendMode.hue,
//alignment: Alignment.bottomRight,
                      fit: BoxFit.cover,
//scale: .8,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(70),
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: selectedColor,
                      border: Border.all(width: 2.0, color: Colors.white),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2))
                      ]),
                ),
                Positioned(
                  child: Text('${selectedColor}',
                      style: TextStyle(
                          color: Colors.white,
                          backgroundColor: Colors.black54)),
                  left: 114,
                  top: 95,
                ),
              ],
            );
          }),
    );
  }

  void searchPixel(Offset globalPosition) async {
    if (photo == null) {
      await (useSnapshot ? loadSnapshotBytes() : loadImageBundleBytes());
    }
    _calculatePixel(globalPosition);
  }

  void _calculatePixel(Offset globalPosition) {
    RenderBox box = currentKey.currentContext?.findRenderObject() as RenderBox;
    Offset localPosition = box.globalToLocal(globalPosition);

    double px = localPosition.dx;
    double py = localPosition.dy;

    if (!useSnapshot) {
      double widgetScale = box.size.width / photo!.width;
      print(py);
      px = (px / widgetScale);
      py = (py / widgetScale);
    }

    var pixel32 = photo!.getPixelSafe(px.toInt(), py.toInt());
    print("Pixel 32 value");
    print(pixel32.r);
//int hex = abgrToArgb(pixel32);

//_stateController.add(Color(hex));
  }

  Future loadImageBundleBytes() async {
    ByteData imageBytes = await rootBundle.load(imagePath);
    setImageBytes(imageBytes);
  }

  Future loadSnapshotBytes() async {
    RenderRepaintBoundary boxPaint =
        paintKey.currentContext?.findRenderObject() as RenderRepaintBoundary;
    ui.Image capture = await boxPaint.toImage();
    ByteData? imageBytes =
        await capture.toByteData(format: ui.ImageByteFormat.png);
    setImageBytes(imageBytes!);
    capture.dispose();
  }

  void setImageBytes(ByteData imageBytes) {
    Uint8List values = imageBytes.buffer.asUint8List();

    photo = img.decodeImage(values)!;
  }
}

// image lib uses uses KML color format, convert #AABBGGRR to regular #AARRGGBB
int abgrToArgb(int argbColor) {
  int r = (argbColor >> 16) & 0xFF;
  int b = argbColor & 0xFF;
  return (argbColor & 0xFF00FF00) | (b << 16) | r;
}