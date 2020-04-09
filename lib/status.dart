import 'dart:io';

import 'package:console/console.dart';

class Status {
  static void error(
    String message, {
    bool tab = true,
    bool newLine = true,
  }) {
    var pen = TextPen();
    pen.red();
    pen(
      '${newLine ? '\n' : ''}${tab ? '\t' : ''}🚩 $message',
    );
    pen();
    exit(1);
  }

  static void success(
    String message, {
    bool tab = true,
    bool newLine = true,
  }) {
    var pen = TextPen();
    pen.green();
    pen(
      '${newLine ? '\n' : ''}${tab ? '\t' : ''}✅ $message',
    );
    pen();
  }
}
