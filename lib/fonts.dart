import 'dart:io';
import 'dart:convert';

import 'package:archive/archive.dart';
import 'package:console/console.dart';
import 'package:file_utils/file_utils.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_google_fonts/status.dart';
import 'package:flutter_google_fonts/models/font.dart';

class Fonts {
  static Future<Archive> download(List<String> fonts) async {
    final multipleFonts = fonts.length > 1;
    final fontForm = multipleFonts ? 'Fonts' : 'Font';

    Status.step('Downloading Zip for $fontForm', '🔽');

    // Cleaning up spaces from fonts
    var cleanedFonts = [];
    for (final font in fonts) {
      cleanedFonts.add(font.replaceAll(' ', '+'));
    }

    final requestURL = Uri.parse(
      'https://fonts.google.com/download?family=${multipleFonts ? cleanedFonts.join('%7C') : cleanedFonts[0]}',
    );

    // Making request for zip
    final client = http.Client();
    final request = http.Request('GET', requestURL);
    final response = await client.send(request);

    if (response.statusCode == 200) {
      Status.success(
        'Zip successfully downloaded',
      );
    } else {
      Status.error(
        'Failed to download:\n\t$requestURL',
      );
    }
    return ZipDecoder().decodeBytes(await response.stream.toBytes());
  }

  static Future<List<GoogleFont>> validation(
    Archive zipContent,
    List<String> fontNames,
  ) async {
    Status.step('Checking Downloaded Zip', '📦');

    final fileNames = <String>[];
    zipContent.forEach((file) {
      if (file.name.endsWith('.ttf')) {
        fileNames.add(file.name);
      }
    });

    final googleFonts = <GoogleFont>[];

    // Checking that fonts downloaded correctly
    for (final fontName in fontNames) {
      var found = false;
      final files = <String>[];
      final weights = await Fonts.fontWeights(fontName);
      for (final fileName in fileNames) {
        final validFile = weights.containsKey(
          fontNames.length > 1 ? fileName.split('/')[1] : fileName,
        );
        if (validFile) {
          found = true;
          files.add(fileName);
        }
      }
      if (found) {
        Status.success('$fontName successfully downloaded');
        googleFonts.add(
          GoogleFont(
            fontName,
            'https://fonts.google.com/specimen/$fontName?selection.family=$fontName',
            files,
            weights,
          ),
        );
      } else {
        Status.error('$fontName didn\'t download');
      }
    }
    return googleFonts;
  }

  static Future<Map<String, String>> fontWeights(String fontName) async {
    final weights = <String, String>{};

    // Making request for css
    final requestUrl =
        'https://fonts.googleapis.com/css?family=$fontName:100,100i,200,200i,300,300i,400,400i,500,500i,600,600i,700,700i,800,800i,900,900i';
    final response = await http.get(requestUrl);
    if (response.statusCode == 200) {
      final lines = response.body.split('\n');
      for (var i = 0; i < lines.length; i++) {
        if (lines[i].contains('font-weight:')) {
          var weight = lines[i]
              .trim()
              .replaceAll('font-weight:', '')
              .trim()
              .replaceAll(';', '')
              .toString();
          if (lines[i - 1].contains('italic')) {
            weight = '${weight}i';
          }
          final file = lines[i + 1]
                  .split(',')[1]
                  .trim()
                  .replaceAll('local(\'', '')
                  .replaceAll('\')', '') +
              '.ttf';
          weights[file] = weight;
        }
      }
    } else {
      Status.error('Failed to get css for $fontName');
    }
    return weights;
  }
}
