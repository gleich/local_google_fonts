import 'dart:io';
import 'dart:typed_data';

import 'package:local_google_fonts/status.dart';

class Files {
  static String moveToWriteLocation(String pathPrefix) {
    final location = '${Directory.current.path}/$pathPrefix';
    if (Directory(location).existsSync()) {
      Directory(location).deleteSync(recursive: true);
    }
    Directory(location).createSync(recursive: true);
    Directory.current = location;
    return Directory.current.path;
  }

  static void writeFiles(
      Map<String, Map<String, Uint8List>> ttfFiles, bool documentation) {
    Status.step('✍️  Writing to files');
    for (final fileFontName in ttfFiles.keys) {
      // Writing ttf files
      for (final fontWeight in ttfFiles[fileFontName].keys) {
        final file = File('$fileFontName/$fileFontName-$fontWeight.ttf');
        file.createSync(recursive: true);
        file.writeAsBytes(ttfFiles[fileFontName][fontWeight]);
      }
      // Writing to README.md
      if (documentation) {
        final normalName = fileFontName.replaceAll('-', '+');
        var contents = <String>[
          '# $fileFontName\n',
          '\nFor more information visit the [Google Fonts page for $normalName](https://fonts.google.com/specimen/$normalName)\n\n',
          '## Weights\n',
        ];
        for (final fontWeight in ttfFiles[fileFontName].keys) {
          contents.add('\n- $fontWeight');
        }
        contents.add('\n');
        final readme = File('$fileFontName/README.md');
        readme.createSync();
        readme.writeAsStringSync(contents.join());
      }
    }
    Status.success('Successfully wrote to files');
  }
}
