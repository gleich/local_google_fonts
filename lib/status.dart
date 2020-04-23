// 🎯 Dart imports:
import 'dart:io';

// 📦 Package imports:
import 'package:console/console.dart';

class Status {
  /// Output and formatting for step
  static void step(
    String name, {
    int indentation = 0,
  }) {
    print(
      '${_Util.generateIndentation(
        indentation,
      )}$name',
    );
  }

  /// Output and formatting for error
  static void error(
    String message, {
    int indentation = 1,
  }) {
    var pen = TextPen();
    pen.red();
    pen(
      '${_Util.generateIndentation(indentation)}❌ $message',
    );
    pen();
    exit(1);
  }

  /// Output and formatting for success
  static void success(
    String message, {
    int indentation = 1,
  }) {
    var pen = TextPen();
    pen.green();
    pen(
      '${_Util.generateIndentation(indentation)}✅ $message',
    );
    pen();
  }
}

class _Util {
  static String generateIndentation(int indentation) {
    final tabs = [];
    for (var i = 0; i != indentation + 1; i++) {
      tabs.add(i == indentation ? '┗╼╾' : '   ');
    }
    return tabs.join();
  }
}
