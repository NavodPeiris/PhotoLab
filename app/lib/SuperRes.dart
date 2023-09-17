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
import './MyCard.dart';
import 'photoUtil.dart';
import 'package:wakelock/wakelock.dart';

class SuperRes extends StatefulWidget {
  @override
  _SuperResState createState() => _SuperResState();
}

class _SuperResState extends State<SuperRes> {
  File? _imageFile;
  final uploadUrl = Uri.parse('http://192.168.8.141:8000/superRes/infer');
  String? _imageUrl;
  late bool _uploading;
  late int frameNum;
  PhotoUtil photoUtil = new PhotoUtil();

  MyCard card = new MyCard(
    imagePath: "assets/images/super.jpeg", 
    text: "increase the resolution of image without losing quality"
  );

  late Uint8List _imageBytes;

  @override
  void initState() {
    super.initState();
    
    _uploading = false;
    frameNum = 0;
    photoUtil.workPath = 'images';
    photoUtil.getAppTempDirectory();
    _imageFile = null;
  }

  Future<void> _uploadImage(BuildContext context) async {
    if (_imageFile == null) return;

    try {
      http.MultipartRequest request = http.MultipartRequest('POST', uploadUrl);
      request.files.add(await http.MultipartFile.fromPath('file', _imageFile!.path));

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final Uint8List imageBytes = await response.stream.toBytes();
        setState(() {
          _imageBytes = imageBytes;
          _imageUrl = response.headers['image-url'] ?? '';
        });
        frameNum++;
        photoUtil.saveImageFileToDirectory(_imageBytes, 'image_$frameNum.jpg');
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
          title: Text('High Resolution Image'),
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
        backgroundColor: Color.fromARGB(255, 43, 207, 17),
        textColor: Colors.white,
        fontSize: 16.0);
    }

  }


  @override
  Widget build(BuildContext context) {
    return 
      Center(
        child: GestureDetector(
          child: card,
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return StatefulBuilder(
                  builder: (context, setState) {
                    return AlertDialog(
                      title: Text('Select Image'),
                      content: Container(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            _imageFile != null
                                ? Container(
                                    margin: EdgeInsets.all(10),
                                    child: Image.file(
                                          _imageFile!,
                                          width: 100,
                                          height: 100,
                                        ),
                                  )
                                : Text('No image selected'),
                            ElevatedButton(
                              child: Text('Select Image'),
                              onPressed: ()async{
                                XFile? selectedImage =
                                    await ImagePicker().pickImage(source: ImageSource.gallery);
                                
                                setState(() {
                                  _imageFile = File(selectedImage!.path);
                                });
                              },
                            ),
                            ElevatedButton(
                              child: Text('Upload Image'),
                              onPressed: () async{
                                if(!_uploading){
                                  setState(() {
                                    _uploading = true;
                                  });

                                  Wakelock.enable();
                                  await _uploadImage(context);
                                  Wakelock.disable;

                                  setState(() {
                                    _uploading = false;
                                    _imageFile = null;
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
          }
        ),
      );
  }

}

