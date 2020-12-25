import 'package:gimig_gastro_image_upload/components/custom_app_bar.dart';
import 'package:gimig_gastro_image_upload/constants.dart';
import 'package:gimig_gastro_image_upload/food_class.dart';
import 'package:gimig_gastro_image_upload/screens/create_category_screen.dart';
import 'package:gimig_gastro_image_upload/screens/upload_screen.dart';
import 'package:gimig_gastro_image_upload/services/firebase_storage_service.dart';
import 'package:gimig_gastro_image_upload/services/cloud_storage_service.dart';
import 'package:gimig_gastro_image_upload/services/image_cache_services.dart';
import 'package:network_to_file_image/network_to_file_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'display_screen.dart';

Directory _appDocsDir;

class CategoryScreen extends StatefulWidget {
  static const String id = 'category_screen';

  CategoryScreen({this.path, this.path2, this.path3});

  final String path;
  final String path2;
  final String path3;
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final CloudStorageService _cloudStorageService = CloudStorageService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ImageCacheService _imageCacheService = ImageCacheService();

  Future _getDir() async {
    _appDocsDir = await getApplicationDocumentsDirectory();
  }

  Future<Widget> _getImage(BuildContext context, String imageName) async {
    Image image;
    await FireStorageService.loadImage(context, imageName).then((value) {
      image = Image(
        image: NetworkToFileImage(
          file: _imageCacheService.fileFromDocsDir(imageName, _appDocsDir),
          url: value.toString(),
          debug: true,
        ),
        fit: BoxFit.cover,
      );
      print(value.toString());
    });
    return image;
  }

  void initState() {
    super.initState();
    _getDir();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2b2b2b),
      appBar: headerNav(title: "Speisekarte", context: context),
      body: StreamBuilder<QuerySnapshot>(
        //STREAM
        stream: _firestore
            .collection("restaurants")
            .doc("julian@web.de")
            .collection("menu")
            .doc("${widget.path}")
            .collection("categories")
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          List<Widget> imageList = [];
          List<Food> items = [];
          final images = snapshot.data.docs;

          for (var document in images) {
            print(document.metadata.isFromCache
                ? "NOT FROM NETWORK"
                : "FROM NETWORK");

            final id = document.id;
            final name = document.data()['name'];
            final image = document.data()['image'];

            Food food = Food(
              id: id,
              name: name,
              image: image,
            );

            items.insert(0, food);

            final imageBox = GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, DisplayScreen.id,
                    arguments: DisplayScreen(
                      path: widget.path,
                      path2: name,
                    ));
              },
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xFF4B4B4B),
                ),
                height: 170,
                width: MediaQuery.of(context).size.width * 0.9,
                child: Stack(
                  children: [
                    GestureDetector(
                      onLongPress: () {
                        _cloudStorageService.deleteFood(food);
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Container(
                          height: 170,
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: FutureBuilder(
                              future: _getImage(context, food.image),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.done) {
                                  return Container(
                                    child: snapshot.data,
                                  );
                                }
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return Container(
                                    child: Center(
                                        child: CircularProgressIndicator(
                                      strokeWidth: 3,
                                    )),
                                  );
                                }

                                return Container(
                                  child: Icon(
                                    Icons.refresh,
                                    color: Color(0xFFFFA374),
                                  ),
                                );
                              }),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      height: 170,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.black.withOpacity(0.4),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        food.name,
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                          letterSpacing: 2.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
            imageList.insert(0, imageBox);
          }

          return Container(
            child: RefreshIndicator(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.05,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    Text(
                      "Kategorien/Gänge:",
                      style: kDetailTextStyle,
                    ),
                    Column(
                      children: imageList,
                    ),
                  ],
                ),
              ),
              onRefresh: () {
                setState(() {});
                return _getDir();
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, CreateCategoryScreen.id,
              arguments: widget.path);
        },
        icon: Icon(
          Icons.add,
          color: Color(0xFF363636),
        ),
        label: Text(
          "Neue Kategorie hinzufügen",
          style: TextStyle(
            color: Color(0xFF363636),
          ),
        ),
        backgroundColor: Color(0xFFFFA374),
        splashColor: Colors.tealAccent,
      ),
    );
  }
}
