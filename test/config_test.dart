import 'package:test/test.dart';

import 'package:flutter_google_fonts/config.dart';
import 'package:yaml/yaml.dart';

void main() {
  test(
    'Read from config',
    () {
      YamlMap read = Config.read(fileName: 'test/config.yaml');
      expect(read.runtimeType, YamlMap);
      expect(
        read['fonts'],
        [
          'Roboto',
          'Abel',
        ],
      );
    },
  );
}
