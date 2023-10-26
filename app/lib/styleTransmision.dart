import 'dart:io';

import 'package:app/account.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'photoUtil.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wakelock/wakelock.dart';

const themeColor = Color.fromARGB(255, 151, 16, 255);

class StyleTransmision extends StatefulWidget {
  const StyleTransmision({Key? key}) : super(key: key);

  @override
  _SuperResState createState() => _SuperResState();
}

class _SuperResState extends State<StyleTransmision> {
  XFile? _contentImage;
  XFile? _styleImage;
  final uploadUrl = Uri.parse('http://192.168.8.141:8000/styleTransfer/infer');
  String? _imageUrl;
  late bool _uploading;
  late int frameNum;
  PhotoUtil photoUtil = new PhotoUtil();

  late Uint8List _imageBytes;

  @override
  void initState() {
    super.initState();

    _uploading = false;
    frameNum = 0;
    photoUtil.workPath = 'images';
    photoUtil.getAppTempDirectory();
    _contentImage = null;
    _styleImage = null;
  }

  Future<void> _uploadImage(BuildContext context) async {
    if (_contentImage == null || _styleImage == null) {
      print('Please select both content and style images');
      return;
    }

    try {
      http.MultipartRequest request = http.MultipartRequest('POST', uploadUrl);
      request.files
          .add(await http.MultipartFile.fromPath('file1', _contentImage!.path));
      request.files
          .add(await http.MultipartFile.fromPath('file2', _styleImage!.path));

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final Uint8List imageBytes = await response.stream.toBytes();
        setState(() {
          _imageBytes = imageBytes;
          _imageUrl = response.headers['image-url'] ?? '';
        });
        frameNum++;
        photoUtil.saveImageFileToDirectory(_imageBytes, 'image_$frameNum.jpg');
        print('Image uploaded successfully');
        _showImagePopup(context);
      } else {
        print('Image upload failed');
        Fluttertoast.showToast(
            msg: "error",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } catch (e) {
      print('Error uploading image: $e');
      Fluttertoast.showToast(
          msg: "error",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  Future<void> _showImagePopup(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Style Transfered Image'),
          content: Container(
            child: _imageBytes != null
                ? Image.memory(
                    _imageBytes,
                    width: 200,
                    height: 200,
                  )
                : Container(),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: Text('Save to Gallery', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                themeColor, // Use themeColor as the button color
              ),
              onPressed: () {
                _saveImageToGallery();
                Navigator.of(context).pop();
              },
              
            ),
            ElevatedButton(
              child: Text('Close', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor:
                themeColor, // Use themeColor as the button color
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<String> _getApplicationDocumentsDirectory() async {
    final directory = await getExternalStorageDirectory();
    return directory!.path;
  }

  void _saveImageToGallery() async {
    final Uint8List? pngBytes = _imageBytes?.buffer.asUint8List();
    //create file
    final String dir = (await getApplicationDocumentsDirectory()).path;
    final String fullPath = '$dir/${DateTime.now().millisecond}.png';
    File capturedFile = File(fullPath);
    await capturedFile.writeAsBytes(pngBytes as List<int>);
    print(capturedFile.path);

    bool? res = await GallerySaver.saveImage(capturedFile.path);

    if (res != null) {
      Fluttertoast.showToast(
          msg: res ? "Photo Saved" : "Failure!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Color.fromARGB(255, 43, 207, 17),
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Style Transfer",
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
                  height: 200,
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
                  child: _contentImage != null
                      ? Image.file(
                          File(_contentImage!.path),
                          fit: BoxFit.cover,
                        )
                      : const Center(
                          child: Text(
                            'Select Content Image',
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
                      await ImagePicker().pickImage(source: ImageSource.gallery);

                  setState(() {
                    _contentImage = photo;
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
                padding: const EdgeInsets.all(30.0),
                child: Container(
                  width: double.infinity,
                  height: 200,
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
                  child: _styleImage != null
                      ? Image.file(
                          File(_styleImage!.path),
                          fit: BoxFit.cover,
                        )
                      : const Center(
                          child: Text(
                            'Select Style Image',
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
                      await ImagePicker().pickImage(source: ImageSource.gallery);

                  setState(() {
                    _styleImage = photo;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      themeColor, // Use themeColor as the button color
                ),
                child: const Text('Pick Image',
                    style: TextStyle(color: Colors.white)),
              ),
              ElevatedButton(
                  // Changed to an ElevatedButton for a more prominent appearance
                  onPressed: () async {
                    if (!_uploading) {
                      setState(() {
                        _uploading = true;
                      });

                      Wakelock.enable();
                      await _uploadImage(context);
                      Wakelock.disable;

                      setState(() {
                        _uploading = false;
                        _contentImage = null;
                        _styleImage = null;
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        themeColor, // Use themeColor as the button color
                  ),
                  child: const Text('Upload Image',
                      style: TextStyle(color: Colors.white)),
                ),
                _uploading
                        ? CircularProgressIndicator()
                        : Container(),
            ],
          ),
        ));
  }
}
