import 'package:camera/camera.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mouth_cancer/camera.dart';
import 'package:flutter/material.dart';
import 'package:mouth_cancer/camera.dart';

class HomePage extends StatefulWidget {
  HomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text(
          "ORALA",
        ),
      ),
      body: SafeArea(
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              iconSize: 50,
              onPressed: () async {
                await availableCameras().then((value) => Navigator.push(
                    context, MaterialPageRoute(builder: (_) => CameraPage())));
              },
              icon: Icon(
                Icons.camera,
              ),
            ),
            Text(
              "Take Image",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
          ],
        )),
      ),
    );
  }
}
