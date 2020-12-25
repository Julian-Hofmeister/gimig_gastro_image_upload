import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:gimig_gastro_image_upload/food_class.dart';

class CloudStorageService {
  final _firestore = FirebaseFirestore.instance;

  String getImageFileName({
    String title,
  }) {
    var imageFileName =
        title + DateTime.now().microsecondsSinceEpoch.toString() + "-compr";
    return imageFileName;
  }

  Future<CloudStorageResult> uploadImage({
    File imageToUpload,
    String imageFileName,
    String title,
    String name,
    String description,
    String price,
  }) async {
    var imageFileName = getImageFileName(title: title);
    await Firebase.initializeApp();

    print(name);
    print(description);
    print(price);
    print(imageFileName);

    Reference ref = FirebaseStorage.instance.ref().child(imageFileName);

    UploadTask uploadTask = ref.putFile(imageToUpload);

    uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
      print('Snapshot state: ${snapshot.state}'); // paused, running, complete
      print('Progress: ${snapshot.totalBytes / snapshot.bytesTransferred}');
    }, onError: (Object e) {
      print(e); // FirebaseException
    });

    _firestore
        .collection("restaurants")
        .doc("julian@web.de")
        .collection("menu")
        .doc("food")
        .collection("daily_menu")
        .add({
      "name": name,
      "description": description,
      "price": price,
      "image": imageFileName,
    });

    _firestore
        .collection("restaurants")
        .doc("julian@web.de")
        .collection("menu")
        .doc("food")
        .set({
      "title": "Speisen",
    });

    uploadTask.then((TaskSnapshot snapshot) {
      print('Upload complete!');
    }).catchError((Object e) {
      print(e); // FirebaseException
    });
    return null;
  }

  deleteFood(Food food) async {
    if (food.image != null) {
      // StorageReference storageReference =
      //     await FirebaseStorage.instance.getReferenceFromUrl(food.image);

      Reference ref = FirebaseStorage.instance.ref().child(food.image);

      print(ref.name);

      await ref.delete();

      print('image deleted');
    }

    print("FoodID: ${food.id}");
    await _firestore
        .collection("restaurants")
        .doc("julian@web.de")
        .collection("menu")
        .doc("food")
        .collection("categories")
        .doc(food.id)
        .delete();
    // foodDeleted(food);
  }

  Future<CloudStorageResult> uploadCategory({
    File imageToUpload,
    String imageFileName,
    String title,
    String name,
    String path,
  }) async {
    var imageFileName = getImageFileName(title: title);
    await Firebase.initializeApp();

    print(name);
    print(imageFileName);

    Reference ref = FirebaseStorage.instance.ref().child(imageFileName);

    UploadTask uploadTask = ref.putFile(imageToUpload);

    uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
      print('Snapshot state: ${snapshot.state}'); // paused, running, complete
      print('Progress: ${snapshot.totalBytes / snapshot.bytesTransferred}');
    }, onError: (Object e) {
      print(e); // FirebaseException
    });

    _firestore
        .collection("restaurants")
        .doc("julian@web.de")
        .collection("menu")
        .doc(path)
        .collection("categories")
        .add({
      "name": name,
      "image": imageFileName,
    });

    uploadTask.then((TaskSnapshot snapshot) {
      print('Upload complete!');
    }).catchError((Object e) {
      print(e); // FirebaseException
    });
    return null;
  }
}

class CloudStorageResult {
  final String imageUrl;
  final String imageFileName;

  CloudStorageResult({this.imageFileName, this.imageUrl});
}
