import 'package:test/test.dart';

import 'package:flutter_google_fonts/config.dart';
import 'package:yaml/yaml.dart';

void main() {
  test('Read from config', () {
    YamlMap read = Config.read('test/sample_config.yml');
    expect(read.runtimeType, YamlMap);
    expect(read["fonts"],
        ["https://fonts.google.com/specimen/Roboto?selection.family=Roboto"]);
  });
}