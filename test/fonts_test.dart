import 'package:flutter_google_fonts/fonts.dart';
import 'package:http/http.dart';
import 'package:test/test.dart';

void main() {
  group('Download Zip', () {
    test(
      'Single Font',
      () async {
        final download = await Fonts.download(['Abel']);
        expect(download.runtimeType, StreamedResponse);
      },
    );
    test(
      'Multiple Fonts',
      () async {
        final download = await Fonts.download(
          ['Abel', 'Roboto'],
        );
        expect(download.runtimeType, StreamedResponse);
      },
    );
  });
}
