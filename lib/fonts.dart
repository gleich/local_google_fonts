import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:console/console.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_google_fonts/status.dart';

class Fonts {
  static Future<bool> download(List<String> fonts) async {
    final multipleFonts = fonts.length > 1;
    final fontForm = multipleFonts ? 'fonts' : 'font';

    // Cleaning up spaces from fonts
    var cleanedFonts = [];
    for (var font in fonts) {
      cleanedFonts.add(font.replaceAll(' ', '+'));
    }

    final requestURL = Uri.parse(
        'https://fonts.google.com/download?family=${multipleFonts ? cleanedFonts.join('%7C') : cleanedFonts[0]}');

    // Making request for zip
    Console.write('⟱ Downloading $fontForm ⟱ ');
    var timer = TimeDisplay();
    timer.start();
    final response = await http.StreamedRequest('GET', requestURL).send();
    timer.stop();
    print('');
    if (response.statusCode == 200) {
      Status.success('Downloaded fonts');
      final contents = ZipDecoder().decodeBytes(response.stream as List<int>);
      for (final file in contents) {
        final filename = file.name;
        if (file.isFile) {
          final data = file.content as List<int>;
          File('out/ + filename')
            ..createSync(recursive: true)
            ..writeAsBytesSync(data);
        } else {
          Directory('out/' + filename).createSync(recursive: true);
        }
      }
    } else {
      Status.error('Failed to download:\n\t$requestURL');
    }
  }
}
