import 'dart:convert';
import 'dart:io';

import 'package:yaml/yaml.dart';
import 'package:yamlicious/yamlicious.dart';

import 'package:flutter_google_fonts/status.dart';

class Pubspec {
  static Map read() {
    Status.step(
      '📄 Reading Config in pubspec.yaml',
    );

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

    Status.success('Successfully read config');
    return yamlMap['google_fonts'] as Map;
  }

  static void write(
    Map<String, Map<String, String>> ttfFiles,
    String pathPrefix,
  ) {
    Status.step('✍️  Writing to pubspec.yaml');

    final fonts = [];

    // Getting manual fonts
    final originalYamlMap = loadYaml(File('pubspec.yaml').readAsStringSync());
    if (originalYamlMap['flutter'].containsKey('fonts')) {
      for (final font in originalYamlMap['flutter']['fonts']) {
        for (final fontVariation in font['fonts']) {
          if (!fontVariation['asset'].contains(pathPrefix)) {
            fonts.add(font);
          }
        }
      }
    }

    // Writable copy
    final yamlMap = json.decode(json.encode(originalYamlMap));

    for (final font in ttfFiles.keys) {
      final fontYamlBlock = <String, dynamic>{'fonts': []};
      fontYamlBlock['family'] = font.replaceAll('-', ' ');
      for (final weight in ttfFiles[font].keys) {
        final asset = {};
        asset['asset'] = '$pathPrefix/$font/$font-$weight.ttf';
        asset['weight'] = weight.replaceAll('i', '');
        if (weight.contains('i')) {
          asset['style'] = 'italic';
        }
        fontYamlBlock['fonts'].add(asset);
      }
      fonts.add(fontYamlBlock);
    }
    yamlMap['flutter']['fonts'] = fonts;

    File('pubspec.yaml').deleteSync();
    File('pubspec.yaml').createSync();
    File('pubspec.yaml').writeAsStringSync(toYamlString(yamlMap));
    Status.success('Wrote config to pubspec.yaml');
  }
}
