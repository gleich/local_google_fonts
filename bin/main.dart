import 'dart:io';

import 'package:flutter_google_fonts/pubspec.dart';
import 'package:flutter_google_fonts/fonts.dart';
import 'package:flutter_google_fonts/status.dart';

void main() async {
  // Reading config and setting vars for rest of program
  final config = Pubspec.read();

  // Validating Config
  if (config['fonts'].isEmpty) {
    Status.error('No fonts listed in config');
  }

  // Getting name of all fonts
  final fontNames = <String>[];
  for (final font in config['fonts']) {
    if (font is String) {
      fontNames.add(font);
    } else {
      fontNames.add(font.keys.first);
    }
  }

  // Setting defaults
  final path = config.containsKey('pathPrefix')
      ? config['path']
      : 'assets/fonts/googleFonts';
  final documentation = config.containsKey('docs') ? config['docs'] : true;

  // Getting ttf files
  await Fonts.download(fontNames, true);
}
