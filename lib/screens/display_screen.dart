import 'package:gimig_gastro_image_upload/components/custom_app_bar.dart';
import 'package:gimig_gastro_image_upload/constants.dart';
import 'package:gimig_gastro_image_upload/screens/upload_screen.dart';
import 'package:gimig_gastro_image_upload/services/firebase_storage_service.dart';
import 'package:gimig_gastro_image_upload/services/cloud_storage_service.dart';
import 'file:///home/ju/AndroidStudioProjects/gimig_gastro_application/lib/classes/food_class.dart';
import 'package:gimig_gastro_image_upload/services/image_cache_services.dart';
import 'package:network_to_file_image/network_to_file_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'dart:io';

Directory _appDocsDir;

class DisplayScreen extends StatefulWidget {
  static const String id = 'display_screen';
  @override
  _DisplayScreenState createState() => _DisplayScreenState();
}

class _DisplayScreenState extends State<DisplayScreen> {
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
      appBar: headerNav(title: "Tageskarte", context: context),
      body: StreamBuilder<QuerySnapshot>(
        //STREAM
        stream: _firestore
            .collection("julian@web.de")
            .doc("menu")
            .collection("daily_menu")
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
            final description = document.data()['description'];
            final price = document.data()['price'];

            Food food = Food(
              id: id,
              name: name,
              image: image,
              description: description,
              price: price,
            );

            items.insert(0, food);

            final imageBox = Container(
              margin: EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(0xFF4B4B4B),
              ),
              height: 100,
              width: MediaQuery.of(context).size.width * 0.9,
              child: Row(
                children: [
                  GestureDetector(
                    onLongPress: () {
                      _cloudStorageService.deleteFood(food);
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Container(
                        width: 80,
                        height: 100,
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 100,
                      width: MediaQuery.of(context).size.width * 0.9 - 100,
                      child: Stack(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 250,
                                child: Text(
                                  food.name,
                                  style: kFoodCardTitleTextStyle,
                                ),
                              ),
                              SizedBox(
                                height: 6,
                              ),
                              SizedBox(
                                width: 200,
                                child: Text(
                                  food.description,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 3,
                                  style: kFoodCardDescTextStyle,
                                ),
                              ),
                            ],
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Text(
                              "${food.price}€",
                              style: kFoodCardPriceTextStyle,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
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
                      "öffentliche Tagesgerichte:",
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
          Navigator.pushNamed(context, UploadScreen.id);
        },
        icon: Icon(
          Icons.add,
          color: Color(0xFF363636),
        ),
        label: Text(
          "Neues Gericht hinzufügen",
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
// IconButton(
// icon: Icon(
// Icons.delete,
// color: Colors.black87,
// size: 30,
// ),
// onPressed: () {
// _cloudStorageService.deleteFood(food);
// })
