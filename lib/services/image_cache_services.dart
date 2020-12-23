import 'dart:io';
import 'package:path/path.dart' as p;

class ImageCacheService {
  File fileFromDocsDir(String filename, Directory appDocsDir) {
    String pathName = p.join(appDocsDir.path, filename);
    print(pathName);
    return File(pathName);
  }
}
