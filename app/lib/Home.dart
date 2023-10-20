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

import 'photoUtil.dart';

//import './SuperRes.dart';
//import './Deoldify.dart';
import './StyleTransfer.dart';
import './ImageGen.dart';
import './account.dart';

import 'superResolution.dart';
import 'styleTransmision.dart';
import 'Deoldify copy.dart';
import 'ImageGeneration.dart';

/*
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple[200],
        title: Center(
          child: Text('PhotoLab'),
        ),
        actions: [
          Account(),
        ],
      ),
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView( 
        padding: EdgeInsets.all(16.0), 
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SuperRes(),
            Deoldify(),
            StyleTransfer(),
            ImageGen(),
          ],
        ),
      ),
    );
  }

}*/

//const themeColor = Color.fromARGB(255, 151, 16, 255);
const themeColor = Color.fromARGB(255, 151, 16, 255);

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "PhotoLab",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
            color: Colors.black), // Set the color of the back button
        shadowColor: Colors.purple,
        actions: const [
          Account(),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                image: const DecorationImage(
                  image: AssetImage(
                      'assets/images/bb.jpg'), // Replace with your image path
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: const LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            themeColor,
                            //Color.fromARGB(255, 151, 16, 255),
                            Colors.transparent,
                            //Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Edit image', // Replace with your text
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Colors.white, //    Set the text color
                              fontSize: 20, // Set the font size
                              fontWeight:
                                  FontWeight.bold, // Set the font weight
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                              'Super Resolution \nStyle transmision \nDeoldify \nImage generation', // Replace with your text
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Colors.white, //    Set the text color
                                fontSize: 13, // Set the font size
                                fontWeight: FontWeight.normal,
                                height: 1.5,
                              )),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: GestureDetector(
                  onTap: () {
                    // Add your navigation logic here
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SuperRes()),
                    );
                  },
                  child: Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      color: themeColor,
                      borderRadius: BorderRadius.circular(10),
                      image: const DecorationImage(
                        image: AssetImage(
                            'assets/images/11.png'), // Replace with the path to your image asset
                        fit: BoxFit.fill, // You can adjust the BoxFit as needed
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.only(top: 120.0),
                      child: Text('Super Resolution', // Replace with your text
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white, //    Set the text color
                            fontSize: 13, // Set the font size
                            fontWeight: FontWeight.bold,
                            height: 1.5,
                            shadows: [
                              Shadow(
                                color:
                                    Colors.black, // Black color for the stroke
                                offset: Offset(1, 1), // Offset for the stroke
                                blurRadius: 3, // Blur radius for the stroke
                              ),
                            ],
                          )),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 0,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    // Add your navigation logic here
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const StyleTransmision()),
                    );
                  },
                  child: Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 252, 154, 33),
                      borderRadius: BorderRadius.circular(10),
                      image: const DecorationImage(
                        image: AssetImage(
                            'assets/images/22.jpeg'), // Replace with the path to your image asset
                        fit: BoxFit
                            .fitWidth, // You can adjust the BoxFit as needed
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.only(top: 120.0),
                      child: Text('Style Transmision', // Replace with your text
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white, //    Set the text color
                            fontSize: 13, // Set the font size
                            fontWeight: FontWeight.bold,
                            height: 1.5,
                            shadows: [
                              Shadow(
                                color:
                                    Colors.black, // Black color for the stroke
                                offset: Offset(1, 1), // Offset for the stroke
                                blurRadius: 3, // Blur radius for the stroke
                              ),
                            ],
                          )),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: GestureDetector(
                  onTap: () {
                    // Add your navigation logic here
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Deoldify()),
                    );
                  },
                  child: Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      color: themeColor,
                      borderRadius: BorderRadius.circular(10),
                      image: const DecorationImage(
                        image: AssetImage(
                            'assets/images/33.jpg'), // Replace with the path to your image asset
                        fit: BoxFit
                            .fitWidth, // You can adjust the BoxFit as needed
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.only(top: 120.0),
                      child: Text('Deoldify', // Replace with your text
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white, //    Set the text color
                            fontSize: 13, // Set the font size
                            fontWeight: FontWeight.bold,
                            height: 1.5,
                            shadows: [
                              Shadow(
                                color:
                                    Colors.black, // Black color for the stroke
                                offset: Offset(1, 1), // Offset for the stroke
                                blurRadius: 3, // Blur radius for the stroke
                              ),
                            ],
                          )),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 0,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    // Add your navigation logic here
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ImageGeneration()),
                    );
                  },
                  child: Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 252, 154, 33),
                      borderRadius: BorderRadius.circular(10),
                      image: const DecorationImage(
                        image: AssetImage(
                            'assets/images/44.jpeg'), // Replace with the path to your image asset
                        fit: BoxFit
                            .fitWidth, // You can adjust the BoxFit as needed
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.only(top: 120.0),
                      child: Text('Image Generation', // Replace with your text
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white, //    Set the text color
                            fontSize: 13, // Set the font size
                            fontWeight: FontWeight.bold,
                            height: 1.5,
                            shadows: [
                              Shadow(
                                color:
                                    Colors.black, // Black color for the stroke
                                offset: Offset(1, 1), // Offset for the stroke
                                blurRadius: 3, // Blur radius for the stroke
                              ),
                            ],
                          )),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: Container(
              height: 10,
              width: double.infinity,
              decoration: BoxDecoration(
                color: themeColor,
                borderRadius: BorderRadius.circular(0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
