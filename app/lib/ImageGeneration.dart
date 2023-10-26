import 'dart:io';

import 'package:app/account.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wakelock/wakelock.dart';
import 'photoUtil.dart';
import 'dart:convert';

const themeColor = Color.fromARGB(255, 151, 16, 255);

class ImageGeneration extends StatefulWidget {
  const ImageGeneration({Key? key}) : super(key: key);

  @override
  _SuperResState createState() => _SuperResState();
}

class _SuperResState extends State<ImageGeneration> {
  final TextEditingController promptController = TextEditingController();
  String? prompt;
  final uploadUrl = Uri.parse('http://192.168.8.141:8000/diffusion/infer');
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
    prompt = null;
  }

  Future<void> _uploadText(BuildContext context) async {
    if (prompt == null) return;

    try {
      http.Response response = await http.post(
        uploadUrl,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'prompt': prompt!,
        }),
      );

      if (response.statusCode == 200) {
        final Uint8List imageBytes = response.bodyBytes;
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
          title: Text('Generated Image'),
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
                      controller: promptController,
                      decoration: InputDecoration(
                        hintText: 'Enter Prompt',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: themeColor, width: 2.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        if (!_uploading) {

                          prompt = promptController.text;

                          setState(() {
                            _uploading = true;
                          });

                          Wakelock.enable();
                          await _uploadText(context);
                          Wakelock.disable();

                          setState(() {
                            _uploading = false;
                            prompt = null;
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: themeColor,
                      ),
                      child: const Text('Generate',
                          style: TextStyle(color: Colors.white)),
                    ),
                    _uploading
                                ? CircularProgressIndicator()
                                : Container(),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
