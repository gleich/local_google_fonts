import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:console/console.dart';
import 'package:flutter_google_fonts/models/font.dart';
import 'package:http/http.dart';

import 'package:flutter_google_fonts/status.dart';

class Fonts {
  static Future<StreamedResponse> download(List<String> fonts) async {
    final multipleFonts = fonts.length > 1;
    final fontForm = multipleFonts ? 'fonts' : 'font';

    // Cleaning up spaces from fonts
    var cleanedFonts = [];
    for (var font in fonts) {
      cleanedFonts.add(font.replaceAll(' ', '+'));
    }

    final requestURL = Uri.parse(
      'https://fonts.google.com/download?family=${multipleFonts ? cleanedFonts.join('%7C') : cleanedFonts[0]}',
    );

    // Making request for zip
    Console.write('🔽 Downloading zip for $fontForm 🔽 ');
    var downloadTimer = TimeDisplay();
    downloadTimer.start();
    final client = Client();
    final request = Request('GET', requestURL);
    final response = await client.send(request);

    downloadTimer.stop();
    if (response.statusCode == 200) {
      Status.success('All fonts successfully downloaded!');
    } else {
      Status.error('Failed to download:\n\t$requestURL');
    }
    return response;
  }

  static List<GoogleFont> extractDownload(
    StreamedResponse response,
    List<String> fonts,
  ) {
    // Checking execution path in root of flutter project
    final cwd = Directory.current;
  }
}
