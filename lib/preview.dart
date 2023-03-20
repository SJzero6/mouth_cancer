import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:image_picker/image_picker.dart';

class PreviewPage extends StatefulWidget {
  PreviewPage({required this.file, super.key});
  XFile file;

  @override
  State<PreviewPage> createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> {
  @override
  Widget build(BuildContext context) {
    File picture = File(widget.file.path);

    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Container(child: Image.file(picture)),
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Icon(Icons.camera_alt))
          ],
        ),
      ),
    );
  }
}
