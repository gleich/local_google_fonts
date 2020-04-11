import 'dart:io';
import 'dart:convert';

import 'package:archive/archive.dart';
import 'package:console/console.dart';
import 'package:file_utils/file_utils.dart';
import 'package:http/http.dart' as http;

import 'package:flutter_google_fonts/status.dart';
import 'package:flutter_google_fonts/models/font.dart';

class Fonts {
  static Future<Map<String, Map<String, String>>> download(
    List fonts,
    bool verbose,
  ) async {
    Status.step('Downloading ${fonts.length > 1 ? 'Fonts' : 'Font'}', '🔽');

    final ttfFiles = <String, Map<String, String>>{};

    for (final font in fonts) {
      const baseURL = 'https://fonts.googleapis.com/css?family=';

      if (font is String) {
        // All weights
        Status.step('Downloading font: $font', '🔽', indentation: 1);
        final fixedFontName = font.replaceAll(' ', '+');
        final fileFontName = font.replaceAll(' ', '-');
        final cssSheet = await http.get(
          '$baseURL$fixedFontName:100,100i,200,200i,300,300i,400,400i,500,500i,600,600i,700,700i,800,800i,900,900i',
        );
        if (cssSheet.statusCode == 200) {
          // Parsing css for weight and ttf url
          final lines = cssSheet.body.split('\n');
          for (var i = 0; i != lines.length; i++) {
            if (lines[i].toLowerCase().contains('font-weight')) {
              final italicized = lines[i - 1].contains('italic') &&
                  lines[i - 1].contains('font-style');
              var weight = lines[i]
                  .split('font-weight')
                  .last
                  .replaceAll(':', '')
                  .replaceAll(';', '')
                  .trim();
              italicized ? weight = '${weight}i' : weight = weight;
              final ttfURL = (lines[i + 1]
                  .split(' ')
                  .firstWhere(
                    (section) =>
                        section.contains('url(https://fonts.gstatic.com'),
                  )
                  .replaceAll('url(', '')
                  .replaceAll(')', ''));
              final fontType = ttfURL.split('.').last;
              if (fontType == 'ttf') {
                final ttfFile = await http.get(ttfURL);
                if (ttfFile.statusCode == 200) {
                  if (!ttfFiles.containsKey(font)) {
                    ttfFiles[fileFontName] = {};
                  }
                  ttfFiles[fileFontName][weight] = ttfFile.body;
                }
                if (verbose) {
                  Status.success('Downloaded $fileFontName-$weight.ttf',
                      indentation: 2);
                }
              } else {
                Status.error(
                  'Font $font is of type: $fontType. Flutter only works with ttf fonts',
                );
              }
            }
          }
        } else {
          Status.error('Failed to get font: $font');
        }
        Status.success('Downloaded font: $font');
      } else if (font is Map) {
        // Defined weights
      } else {
        Status.error('$font in unknown format');
      }
    }
    return ttfFiles;
  }
}

class _Util {
  static parseCSSLines(List<String> selectLines) {}
}
