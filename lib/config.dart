import 'dart:io';

import 'package:yaml/yaml.dart';

class Config {
  static YamlMap read(String filePath) {
    final file = File(filePath);
    final yamlString = file.readAsStringSync();
    final yamlMap = loadYaml(yamlString);

    if (yamlMap == null || !(yamlMap['google_fonts'] is Map)) {
      print('NO CONFIG FOUND');
      exit(1);
    }
    return yamlMap['google_fonts'];
  }
}
