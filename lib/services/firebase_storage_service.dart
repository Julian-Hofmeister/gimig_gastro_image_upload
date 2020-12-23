import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

class FireStorageService extends ChangeNotifier {
  FireStorageService();
  static Future<dynamic> loadImage(BuildContext context, String image) async {
    print(FirebaseStorage.instance.ref().child(image).getDownloadURL());
    return await FirebaseStorage.instance.ref().child(image).getDownloadURL();
  }
}
