import 'package:console/console.dart';
import 'package:flutter_google_fonts/fonts.dart';
import 'package:flutter_google_fonts/status.dart';
import 'package:yaml/yaml.dart';

import 'package:flutter_google_fonts/config.dart';

void main() {
  // Initializing the console
  Console.init();

  // Reading the config
  final config = Config.read();
  final YamlList fonts = config['fonts'];
  if (fonts.isEmpty) {
    Status.error('No fonts listed in config');
  }

  // Setting defaults

  // Download the zip bytes
  Fonts.download(fonts);
}
