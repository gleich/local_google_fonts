// 🎯 Dart imports:
import 'dart:typed_data';

// 📦 Package imports:
import 'package:http/http.dart' as http;

// 🌎 Project imports:
import 'package:local_google_fonts/status.dart';

class GoogleFonts {
  /// Download each ttf file
  static Future<Map<String, Map<String, Uint8List>>> download(
    List fonts,
  ) async {
    Status.step('🔽 Downloading ${fonts.length > 1 ? 'Fonts' : 'Font'}');

    // {fileFontName: {fontWeight: ttfBinary}}
    final ttfFiles = <String, Map<String, Uint8List>>{};

    for (final font in fonts) {
      const baseURL = 'https://fonts.googleapis.com/css?family=';
      String fileFontName;
      String fontName;

      if (font is String) {
        // All weights
        fontName = font;
        Status.step('🔽 Downloading font: $fontName', indentation: 1);

        final fixedFontName = font.replaceAll(' ', '+');
        fileFontName = font.replaceAll(' ', '-');
        // Getting css sheet for all available weights
        final cssSheet = await http.get(
          '$baseURL$fixedFontName:100,100i,200,200i,300,300i,400,400i,500,500i,600,600i,700,700i,800,800i,900,900i',
        );
        if (cssSheet.statusCode == 200) {
          ttfFiles[fileFontName] = await _downloadFromCSS(cssSheet.body, font);
        } else {
          Status.error(
            'Failed to get font: $fontName',
            indentation: 2,
          );
        }
      } else if (font is Map) {
        fontName = font.keys.first;
        Status.step('🔽 Downloading font: $fontName', indentation: 1);

        final fixedFontName = fontName.replaceAll(' ', '+');
        fileFontName = fontName.replaceAll(' ', '-');
        /*
        Getting css sheet for each weight individually
        This is done so the user knows if the font failed to download and doesn't exist.
        */
        for (final fontWeight in font.values.first) {
          final cssSheet = await http.get(
            '$baseURL$fixedFontName:$fontWeight',
          );
          if (cssSheet.statusCode == 200) {
            final ttfFile = await _downloadFromCSS(cssSheet.body, fontName);
            if (!ttfFiles.containsKey(fileFontName)) {
              ttfFiles[fileFontName] = {};
            }
            ttfFiles[fileFontName][ttfFile.keys.first] = ttfFile.values.first;
          } else {
            Status.error(
              'Failed to get weight $fontWeight for $fontName',
              indentation: 2,
            );
          }
        }
      } else {
        Status.error('$font in unknown format');
      }
      Status.success(
        'Downloaded ${ttfFiles[fileFontName].keys.length} variations of $fontName',
        indentation: 3,
      );
    }
    return ttfFiles;
  }

  /// Actual download of ttf file from given css sheet for font
  static Future<Map<String, Uint8List>> _downloadFromCSS(
    String cssBody,
    String fontName,
  ) async {
    // Parsing css for weight and ttf url

    final ttfFilesVariations = <String, Uint8List>{};
    final lines = cssBody.split('\n');
    final fileFontName = fontName.replaceAll(' ', '-');

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
        final ttfURL = lines[i + 1]
            .split(' ')
            .firstWhere(
              (section) => section.contains('url(https://fonts.gstatic.com'),
            )
            .replaceAll('url(', '')
            .replaceAll(')', '');
        final fontType = ttfURL.split('.').last;
        if (fontType == 'ttf') {
          final ttfFile = await http.get(ttfURL);
          if (ttfFile.statusCode == 200) {
            ttfFilesVariations[weight] = ttfFile.bodyBytes;
          }
          Status.success(
            'Downloaded $fileFontName-$weight.ttf',
            indentation: 2,
          );
        } else {
          Status.error(
            'Font $fontName is of type: $fontType. Flutter only works with ttf fonts',
            indentation: 2,
          );
        }
      }
    }
    return ttfFilesVariations;
  }
}
