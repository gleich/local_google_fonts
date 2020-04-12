import 'dart:io';

import 'package:flutter_google_fonts/files.dart';
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

  // Setting defaults
  final pathPrefix =
      config.containsKey('path') ? config['path'] : 'assets/fonts/googleFonts';
  final documentation = config.containsKey('docs') ? config['docs'] : true;

  // Getting ttf files
  final ttfFiles = await GoogleFonts.download(config['fonts']);

  // Writing to actual ttf files
  Files.moveToWriteLocation(pathPrefix);
  Files.writeFiles(ttfFiles, documentation);
}
