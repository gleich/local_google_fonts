import 'dart:io';

import 'package:archive/archive.dart';
import 'package:console/console.dart';
import 'package:file_utils/file_utils.dart';
import 'package:http/http.dart';

import 'package:flutter_google_fonts/status.dart';
import 'package:flutter_google_fonts/models/font.dart';

class Fonts {
  static Future<Archive> download(List<String> fonts) async {
    final multipleFonts = fonts.length > 1;
    final fontForm = multipleFonts ? 'fonts' : 'font';

    Console.write('🔽  Downloading Zip for $fontForm  🔽 ');
    var downloadTimer = TimeDisplay();
    downloadTimer.start();

    // Cleaning up spaces from fonts
    var cleanedFonts = [];
    for (final font in fonts) {
      cleanedFonts.add(font.replaceAll(' ', '+'));
    }

    final requestURL = Uri.parse(
      'https://fonts.google.com/download?family=${multipleFonts ? cleanedFonts.join('%7C') : cleanedFonts[0]}',
    );

    // Making request for zip
    final client = Client();
    final request = Request('GET', requestURL);
    final response = await client.send(request);

    downloadTimer.stop();
    if (response.statusCode == 200) {
      Status.success(
        'Zip successfully downloaded!',
        newLine: true,
      );
    } else {
      Status.error(
        'Failed to download:\n\t$requestURL',
        newLine: true,
      );
    }
    return ZipDecoder().decodeBytes(await response.stream.toBytes());
  }

  static List<GoogleFont> validation(
    Archive zipContent,
    List<String> fontNames,
  ) {
    Status.step('Checking Downloaded Zip', '📦');

    final fileNames = <String>[];
    zipContent.forEach((file) => fileNames.add(file.name));

    final googleFonts = <GoogleFont>[];

    // Checking that fonts downloaded correctly
    for (final fontName in fontNames) {
      var found = false;
      final files = [];
      for (final fileName in fileNames) {
        final lowerCaseFileName = fileName.toLowerCase();
        if (lowerCaseFileName.contains(
          '${fontName.toLowerCase()}${(fontNames.length > 1) ? '/' : ''}',
        )) {
          found = true;
          files.add(fileName);
        }
      }
      if (found) {
        Status.success('$fontName successfully downloaded!');
        googleFonts.add(
          GoogleFont(
            fontName,
            'https://fonts.google.com/specimen/$fontName?selection.family=$fontName',
            files,
          ),
        );
      } else {
        Status.error('$fontName didn\'t download!');
      }
    }
    return googleFonts;
  }
}
