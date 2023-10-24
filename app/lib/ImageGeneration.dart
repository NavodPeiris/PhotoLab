import 'dart:io';

import 'package:app/account.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

const themeColor = Color.fromARGB(255, 151, 16, 255);

class ImageGeneration extends StatefulWidget {
  const ImageGeneration({Key? key}) : super(key: key);

  @override
  _SuperResState createState() => _SuperResState();
}

class _SuperResState extends State<ImageGeneration> {
  final ImagePicker _picker = ImagePicker();
  XFile? file;
  List<XFile>? _files;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Image Generation",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 20,
              color: Colors.black,
            ),
          ),
          backgroundColor: Colors.white,
          shadowColor: Colors.purple,
          iconTheme: const IconThemeData(color: Colors.black),
          actions: const [
            Account(),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Enter Text',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: themeColor, width: 2.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        // Add logic
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: themeColor,
                      ),
                      child: const Text('Submit',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
