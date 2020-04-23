// 🎯 Dart imports:
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

// 📦 Package imports:
import 'package:process_run/process_run.dart';
import 'package:process_run/which.dart';
import 'package:yaml/yaml.dart';
import 'package:yamlicious/yamlicious.dart';
import 'package:yamlicious/yamlicious.dart';

// 🌎 Project imports:
import 'package:local_google_fonts/status.dart';

class Pubspec {
  /// Read from pubspec.yaml
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

  /// Write fonts to pubspec.yaml
  static void write(
    Map<String, Map<String, Uint8List>> ttfFiles,
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
        asset['weight'] = int.parse(weight.replaceAll('i', ''));
        if (weight.contains('i')) {
          asset['style'] = 'italic';
        }
        fontYamlBlock['fonts'].add(asset);
      }
      fonts.add(fontYamlBlock);
    }
    yamlMap['flutter']['fonts'] = fonts;

    final pubspec = File('pubspec.yaml');
    pubspec.writeAsStringSync(toYamlString(yamlMap));
    final lines = pubspec.readAsStringSync().split('\n');
    final fixedLines = <String>[];
    for (var i = 0; i < lines.length; i++) {
      if (i != 0 &&
          lines[i].contains('sdk:') &&
          lines[i].contains('"flutter"') &&
          (lines[i - 1].contains('flutter:') ||
              lines[i - 1].contains('flutter_test:'))) {
        fixedLines.add(lines[i].replaceAll('"flutter"', 'flutter'));
      } else {
        fixedLines.add(lines[i]);
      }
    }
    pubspec.writeAsStringSync(fixedLines.join('\n'));
    Status.success('Wrote config to pubspec.yaml');
  }

  /// Format the pubspec.yaml file with prettier
  static void format() async {
    while (true) {
      if (whichSync('prettier') is String) {
        Status.step('🛠️  Format pubspec.yaml with prettier');
        await run('prettier', ['--write', 'pubspec.yaml']);
        Status.success('Formatted pubspec.yaml');
        break;
      } else if (whichSync('npm') is String) {
        Status.step('🚀  Downloading prettier formatter');
        await run('npm', ['install', '--global', 'prettier']);
        Status.success('Install prettier formatter');
        continue;
      } else if (whichSync('yarn') is String) {
        Status.step('🚀  Downloading prettier formatter');
        await run('yarn', ['global', 'add', 'prettier']);
        Status.success('Install prettier formatter');
        continue;
      }
      break;
    }
  }

  /// Run flutter pub get
  static void flutterPubGet() async {
    Status.step('🏃🏼‍♂️ Running: flutter pub get');
    await run('flutter', ['pub', 'get']);
    Status.success('Ran flutter pub get');
  }
}
