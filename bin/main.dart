// 🎯 Dart imports:
import 'dart:io';

// 🌎 Project imports:
import 'package:local_google_fonts/files.dart';
import 'package:local_google_fonts/pubspec.dart';
import 'package:local_google_fonts/fonts.dart';
import 'package:local_google_fonts/status.dart';

void main() async {
  // Reading config and setting vars for rest of program
  final config = Pubspec.read();
  final cwd = Directory.current.path;

  // Validating Config
  if (config['fonts'].isEmpty) {
    Status.error('No fonts listed in config');
  }

  // Setting defaults
  final pathPrefix =
      config.containsKey('path') ? config['path'] : 'assets/fonts/googleFonts';
  final documentation = config.containsKey('docs') ? config['docs'] : true;
  final format = config.containsKey('format') ? config['format'] : true;
  final flutterPubGet =
      config.containsKey('flutterPubGet') ? config['flutterPubGet'] : true;

  // Getting ttf files
  final ttfFiles = await GoogleFonts.download(config['fonts']);

  // Writing to actual ttf files
  Files.moveToWriteLocation(pathPrefix);
  Files.writeFiles(ttfFiles, documentation);

  // Writing to pubspec.yaml
  Directory.current = cwd;
  Pubspec.write(ttfFiles, pathPrefix);
  if (format) {
    await Pubspec.format();
  }
  if (flutterPubGet) {
    await Pubspec.flutterPubGet();
  }

  print('\n😄 All operations were successful!');
}
