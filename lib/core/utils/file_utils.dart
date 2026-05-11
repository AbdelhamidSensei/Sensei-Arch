import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class FileUtils {
  static const _uuid = Uuid();

  static Future<String> imageToBase64(String path) async {
    final bytes = await File(path).readAsBytes();
    return base64Encode(bytes);
  }

  static String toDataUri(String base64, {String mimeType = 'image/jpeg'}) {
    return 'data:$mimeType;base64,$base64';
  }

  static Future<String> saveBytesToCache(List<int> bytes,
      {String extension = 'jpg'}) async {
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/${_uuid.v4()}.$extension');
    await file.writeAsBytes(bytes);
    return file.path;
  }

  static Future<String> copyToAppDir(String sourcePath) async {
    final dir = await getApplicationDocumentsDirectory();
    final fileName = '${_uuid.v4()}.jpg';
    final dest = File('${dir.path}/$fileName');
    await File(sourcePath).copy(dest.path);
    return dest.path;
  }
}
