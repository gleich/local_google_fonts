import 'dart:io';

import 'package:console/console.dart';
import 'package:flutter_google_fonts/status.dart';
import 'package:yaml/yaml.dart';

class Config {
  static Map read() {
    Console.write('📄 Reading Config ');
    var readTimer = TimeDisplay();
    readTimer.start();

    final file = File('pubspec.yaml');
    String yamlString;
    try {
      yamlString = file.readAsStringSync();
    } on FileSystemException {
      Status.error('No ./pubspec.yaml found');
    }
    final yamlMap = loadYaml(yamlString);

    if (yamlMap == null || !(yamlMap['google_fonts'] is Map)) {
      Status.error('No config found in pubspec');
    }

    readTimer.stop();
    Status.success('Successfully read config');
    return yamlMap['google_fonts'] as Map;
  }
}
