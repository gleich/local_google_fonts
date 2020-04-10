import 'dart:io';

import 'package:console/console.dart';

class Status {
  static void step(String name, String emoji) =>
      print('$emoji  $name  $emoji ');

  static void error(
    String message, {
    bool tab = true,
    bool newLine = false,
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
    bool newLine = false,
  }) {
    var pen = TextPen();
    pen.green();
    pen(
      '${newLine ? '\n' : ''}${tab ? '\t' : ''}✅ $message',
    );
    pen();
  }
}
