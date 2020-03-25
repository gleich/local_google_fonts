import 'dart:io';

import 'package:console/console.dart';

class Status {
  static void error(String message) {
    var pen = TextPen();
    pen.red();
    pen('🚩 $message');
    pen();
    exit(1);
  }

  static void success(String message) {
    var pen = TextPen();
    pen.green();
    pen('✅ $message');
    pen();
  }
}
