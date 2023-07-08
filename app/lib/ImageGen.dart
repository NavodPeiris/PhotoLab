import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';


import 'photoUtil.dart';

class ImageGen extends StatefulWidget {
  @override
  _ImageGenState createState() => _ImageGenState();
}

class _ImageGenState extends State<ImageGen> {

  final TextEditingController promptController = TextEditingController();
  String? prompt;
  final uploadUrl = Uri.parse('http://192.168.8.141:8000/imageGen');
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
    }
  } catch (e) {
    print('Error uploading image: $e');
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
            TextButton(
              child: Text('Save to Gallery'),
              onPressed: () {
                _saveImageToGallery();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Close'),
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

    if(res != null){
      Fluttertoast.showToast(
        msg: res ? "Photo Saved" : "Failure!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
    }

  }


  @override
  Widget build(BuildContext context) {
    return Card(
        child: ListTile(
          title: Text('Image Generation'),
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return StatefulBuilder(
                  builder: (context, setState) {
                    return AlertDialog(
                      title: Text('Enter prompt for image generation'),
                      content: Container(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                border: Border(bottom: BorderSide(color: Colors.deepPurple))
                              ),
                              child: TextField(
                                controller: promptController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "prompt",
                                  hintStyle: TextStyle(color: Colors.grey[400])
                                ),
                              ),
                            ),
                            ElevatedButton(
                              child: Text('Generate'),
                              onPressed: () async {

                                prompt = promptController.text;

                                if(!_uploading){
                                  setState(() {
                                    _uploading = true;
                                  });

                                  await _uploadText(context);

                                  setState(() {
                                    _uploading = false;
                                    prompt = null;
                                  });
                                } 
                              }   
                            ),
                            _uploading
                                ? CircularProgressIndicator()
                                : Container(),
                            TextButton(
                              child: Text(
                                'Close',
                                style: TextStyle(color: Colors.red),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),

                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      );
  }

}

