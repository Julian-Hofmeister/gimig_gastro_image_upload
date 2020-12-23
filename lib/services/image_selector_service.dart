import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';

class ImageSelectorService {
  final picker = ImagePicker();

  Future<File> selectImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      return compressAndGetFile(File(pickedFile.path), pickedFile.path);

      // return File(pickedFile.path);
    } else {
      print('No image selected.');
      return null;
    }
  }

  Future<File> compressAndGetFile(File file, String targetPath) async {
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 88,
    );

    print("FILE SIZE: BEFORE${file.lengthSync()}");
    print(result.lengthSync());

    return result;
  }
}
