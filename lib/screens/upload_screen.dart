import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:gimig_gastro_image_upload/components/custom_app_bar.dart';
import 'package:gimig_gastro_image_upload/main.dart';
import 'package:gimig_gastro_image_upload/services/cloud_storage_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:flutter_focus_watcher/flutter_focus_watcher.dart';
import '../constants.dart';
import 'display_screen.dart';

class UploadScreen extends StatefulWidget {
  static const String id = 'upload_screen';
  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  String name;
  String description;
  String price;
  File _image;
  File _comprImage;
  final picker = ImagePicker();
  final CloudStorageService _cloudStorageService = CloudStorageService();

  Future getImage({source}) async {
    final pickedFile = await picker.getImage(source: source);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        print(pickedFile.path);
        print(
            "${p.withoutExtension(_image.path)}-compr${p.extension(_image.path)}");
        print(_image);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<File> compressAndGetFile(File file, String targetPath) async {
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 94,
      minWidth: 300,
      minHeight: 360,
    );

    print("FILE SIZE / BEFORE: ${file.lengthSync()}");
    print("FILE SIZE / AFTER: ${result.lengthSync()}");

    _comprImage = result;
    print(_comprImage);
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return FocusWatcher(
      child: Scaffold(
        backgroundColor: Color(0xFF363636),
        appBar: headerNav(title: "Neues Gericht", context: context),
        body: Container(
          height: MediaQuery.of(context).size.height - 70,
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: 50,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Name:",
                        style: kDetailTextStyle,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width * 0.01,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: MediaQuery.of(context).size.width * 0.1,
                        child: IgnoreFocusWatcher(
                          child: TextField(
                            keyboardType: TextInputType.name,
                            onChanged: (value) {
                              name = value;
                            },
                            onTap: () {
                              FocusScopeNode currentFocus =
                                  FocusScope.of(context);

                              if (!currentFocus.hasPrimaryFocus) {
                                currentFocus.unfocus();
                              }
                            },
                            style: TextStyle(color: Colors.white),
                            cursorHeight:
                                MediaQuery.of(context).size.width * 0.045,
                            cursorWidth: 1.2,
                            decoration: kDarkTextFieldDecoration,
                            cursorColor: Color(0xFF74FFD0),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.width * 0.05,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Beschreibung:",
                        style: kDetailTextStyle,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width * 0.01,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.9,
                        // height: MediaQuery.of(context).size.width * 0.2,
                        child: IgnoreFocusWatcher(
                          child: TextField(
                            keyboardType: TextInputType.multiline,
                            onChanged: (value) {
                              description = value;
                            },
                            onTap: () {
                              FocusScopeNode currentFocus =
                                  FocusScope.of(context);

                              if (!currentFocus.hasPrimaryFocus) {
                                currentFocus.unfocus();
                              }
                            },
                            style: TextStyle(color: Colors.white),
                            cursorHeight:
                                MediaQuery.of(context).size.width * 0.045,
                            cursorWidth: 1.2,
                            maxLines: 3,
                            decoration: kDarkTextFieldDecoration,
                            cursorColor: Color(0xFF74FFD0),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.width * 0.05,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Preis:",
                        style: kDetailTextStyle,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width * 0.01,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: MediaQuery.of(context).size.width * 0.1,
                        child: IgnoreFocusWatcher(
                          child: TextField(
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              price = value;
                            },
                            onTap: () {
                              FocusScopeNode currentFocus =
                                  FocusScope.of(context);

                              if (!currentFocus.hasPrimaryFocus) {
                                currentFocus.unfocus();
                              }
                            },
                            style: TextStyle(color: Colors.white),
                            cursorHeight:
                                MediaQuery.of(context).size.width * 0.045,
                            cursorWidth: 1.2,
                            decoration: kDarkTextFieldDecoration.copyWith(
                              suffixIcon: Icon(
                                Icons.euro_symbol,
                                color: Colors.tealAccent,
                                size: 20,
                              ),
                            ),
                            cursorColor: Color(0xFF74FFD0),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.width * 0.1,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Color(0xFF4B4B4B),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: MediaQuery.of(context).size.width * 0.6,
                    child: _image != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            child: Image.file(
                              _image,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Container(
                            child: Center(
                              child: Text(
                                "kein Bild ausgewählt",
                                style: TextStyle(color: Colors.white54),
                              ),
                            ),
                          ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.width * 0.1,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircleAvatar(
                          backgroundColor: Color(0xFFFFA374),
                          child: IconButton(
                            onPressed: () {
                              getImage(source: ImageSource.camera);
                            },
                            icon: Icon(
                              Icons.camera,
                            ),
                            color: Colors.white,
                          ),
                        ),
                        FlatButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40),
                          ),
                          minWidth: 300,
                          height: 40,
                          color: Colors.tealAccent,
                          onPressed: () {
                            getImage(source: ImageSource.gallery);
                          },
                          child: Text(
                            "Bild auswählen",
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: GestureDetector(
          child: Container(
            color: Color(0xFFFFA374),
            height: 70,
            child: Center(
              child: Text(
                "Gericht veröffentlichen",
                style: TextStyle(
                  letterSpacing: 1,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          onTap: () async {
            if (name != null &&
                _image != null &&
                description != null &&
                price != null) {
              await compressAndGetFile(_image,
                  "${p.withoutExtension(_image.path)}-compr${p.extension(_image.path)}");
              print(
                  "${p.withoutExtension(_image.path)}-compr${p.extension(_image.path)}");

              _cloudStorageService.uploadImage(
                imageToUpload: _comprImage,
                title: "item",
                name: name,
                description: description,
                price: price,
              );
            } else {
              print("fuck off or input shit man!!!");
            }
          },
        ),
      ),
    );
  }
}
