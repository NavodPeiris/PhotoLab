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
                child: Container(
                  width: double.infinity,
                  height: 300,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: themeColor, // Border color
                      width: 2.0, // Border width
                    ),
                    borderRadius: BorderRadius.circular(10),
                    gradient: const LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      colors: [
                        Color.fromARGB(
                            255, 243, 221, 247), // Start with your theme color
                        Colors
                            .white, // Add a transparent color for the "charm" effect
                      ],
                    ),
                  ),
                  child: file != null
                      ? Image.file(
                          File(file!.path),
                          fit: BoxFit.cover,
                        )
                      : const Center(
                          child: Text(
                            'Not Picked',
                            style: TextStyle(
                              fontSize: 20,
                              color: Color.fromARGB(255, 43, 41,
                                  41), // Set the text color to white
                              fontWeight: FontWeight.bold, // Make the text bold
                            ),
                          ),
                        ),
                ),
              ),
              //Single Image
              ElevatedButton(
                // Changed to an ElevatedButton for a more prominent appearance
                onPressed: () async {
                  final XFile? photo =
                      await _picker.pickImage(source: ImageSource.gallery);
                  setState(() {
                    file = photo;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      themeColor, // Use themeColor as the button color
                ),
                child: const Text('Pick Image',
                    style: TextStyle(color: Colors.white)),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: ElevatedButton(
                  onPressed: () async {
                    final XFile? photo = await _picker.pickImage(
                        source: ImageSource.camera); // Use camera source
                    setState(() {
                      file = photo;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeColor, // Use your theme color
                  ),
                  child: const Text('Take a Photo',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ));
  }
}
