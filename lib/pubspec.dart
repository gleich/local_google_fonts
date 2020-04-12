import 'dart:io';

import 'package:yaml/yaml.dart';

import 'package:flutter_google_fonts/status.dart';

class Pubspec {
  static Map read({
    String fileName = 'pubspec.yaml',
  }) {
    Status.step(
      '📄 Reading Config in $fileName',
    );

    final file = File(fileName);
    String yamlString;
    try {
      yamlString = file.readAsStringSync();
    } on FileSystemException {
      Status.error('No ./$fileName found');
    }
    final yamlMap = loadYaml(yamlString);

    if (yamlMap == null || !(yamlMap['google_fonts'] is Map)) {
      Status.error('No config found in pubspec');
    }

    Status.success('Successfully read config');
    return yamlMap['google_fonts'] as Map;
  }
}
