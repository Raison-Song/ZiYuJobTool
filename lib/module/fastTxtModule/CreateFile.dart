import 'dart:io';

import 'package:path_provider/path_provider.dart';

class FileUtils {
  static Future<void> writeToFile(String fileName, String content) async {
    final file = await _localFile(fileName);

    // Write the file.
    await file.writeAsString(content);
  }

  static Future<File> _localFile(String fileName) async {
    // Get the directory for the app documents.
    final directory = await getApplicationDocumentsDirectory();

    // Create the file path.
    final path = '${directory.path}/$fileName.txt';

    // Return a reference to the file.
    return File(path);
  }
}
