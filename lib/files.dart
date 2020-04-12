import 'dart:io';

import 'package:file_utils/file_utils.dart';
import 'package:flutter_google_fonts/status.dart';

class Files {
  static String moveToWriteLocation(String pathPrefix) {
    final location = '${FileUtils.getcwd()}/$pathPrefix';
    Directory(location).deleteSync(recursive: true);
    FileUtils.mkdir(
      [location],
      recursive: true,
    );
    FileUtils.chdir(location);
    return FileUtils.getcwd();
  }

  static void writeTffFiles(Map<String, Map<String, String>> ttfFiles) {
    Status.step('✍️  Writing to files');
    for (final fileFontName in ttfFiles.keys) {
      for (final fontWeight in ttfFiles[fileFontName].keys) {
        final file = File('$fileFontName/$fileFontName-$fontWeight.ttf');
        file.createSync(recursive: true);
        file.writeAsStringSync(ttfFiles[fileFontName][fontWeight]);
      }
    }
    Status.success('Successfully wrote to files');
  }
}
