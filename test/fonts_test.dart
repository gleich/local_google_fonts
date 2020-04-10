import 'package:archive/archive_io.dart';
import 'package:test/test.dart';

import 'package:flutter_google_fonts/fonts.dart';

void main() {
  group(
    'Download Zip',
    () {
      test(
        'Single Font',
        () async {
          final download = await Fonts.download(
            ['Abel'],
          );
          expect(download.runtimeType, Archive);
        },
      );
      test(
        'Multiple Fonts',
        () async {
          final download = await Fonts.download(
            ['Abel', 'Roboto'],
          );
          expect(download.runtimeType, Archive);
        },
      );
    },
  );

  group(
    'Validation',
    () {
      test(
        'Single Font',
        () async {
          final download = await Fonts.download(
            ['Abel'],
          );
          final fonts = await Fonts.validation(
            download,
            ['Abel'],
          );
          expect(
            fonts[0].name,
            'Abel',
          );
          expect(
            fonts[0].url,
            'https://fonts.google.com/specimen/Abel?selection.family=Abel',
          );
          expect(
            fonts[0].files,
            ['Abel-Regular.ttf'],
          );
          expect(
            fonts[0].weights,
            {'Abel-Regular.ttf': '400'},
          );
        },
      );
      test(
        'Multiple Fonts',
        () async {
          final download = await Fonts.download(
            ['Abel', 'Tomorrow'],
          );
          final fonts = await Fonts.validation(
            download,
            ['Abel', 'Tomorrow'],
          );
          // Abel
          expect(
            fonts[0].name,
            'Abel',
          );
          expect(
            fonts[0].url,
            'https://fonts.google.com/specimen/Abel?selection.family=Abel',
          );
          expect(
            fonts[0].files,
            ['Abel/Abel-Regular.ttf'],
          );
          expect(
            fonts[0].weights,
            {'Abel-Regular.ttf': '400'},
          );
          // Tomorrow
          expect(
            fonts[1].name,
            'Tomorrow',
          );
          expect(
            fonts[1].url,
            'https://fonts.google.com/specimen/Tomorrow?selection.family=Tomorrow',
          );
          expect(
            fonts[1].files,
            [
              'Tomorrow/Tomorrow-Thin.ttf',
              'Tomorrow/Tomorrow-ThinItalic.ttf',
              'Tomorrow/Tomorrow-ExtraLight.ttf',
              'Tomorrow/Tomorrow-ExtraLightItalic.ttf',
              'Tomorrow/Tomorrow-Light.ttf',
              'Tomorrow/Tomorrow-LightItalic.ttf',
              'Tomorrow/Tomorrow-Regular.ttf',
              'Tomorrow/Tomorrow-Italic.ttf',
              'Tomorrow/Tomorrow-Medium.ttf',
              'Tomorrow/Tomorrow-MediumItalic.ttf',
              'Tomorrow/Tomorrow-SemiBold.ttf',
              'Tomorrow/Tomorrow-SemiBoldItalic.ttf',
              'Tomorrow/Tomorrow-Bold.ttf',
              'Tomorrow/Tomorrow-BoldItalic.ttf',
              'Tomorrow/Tomorrow-ExtraBold.ttf',
              'Tomorrow/Tomorrow-ExtraBoldItalic.ttf',
              'Tomorrow/Tomorrow-Black.ttf',
              'Tomorrow/Tomorrow-BlackItalic.ttf',
            ],
          );
          expect(
            fonts[1].weights,
            {
              'Tomorrow-ThinItalic.ttf': '100i',
              'Tomorrow-ExtraLightItalic.ttf': '200i',
              'Tomorrow-LightItalic.ttf': '300i',
              'Tomorrow-Italic.ttf': '400i',
              'Tomorrow-MediumItalic.ttf': '500i',
              'Tomorrow-SemiBoldItalic.ttf': '600i',
              'Tomorrow-BoldItalic.ttf': '700i',
              'Tomorrow-ExtraBoldItalic.ttf': '800i',
              'Tomorrow-BlackItalic.ttf': '900i',
              'Tomorrow-Thin.ttf': '100',
              'Tomorrow-ExtraLight.ttf': '200',
              'Tomorrow-Light.ttf': '300',
              'Tomorrow-Regular.ttf': '400',
              'Tomorrow-Medium.ttf': '500',
              'Tomorrow-SemiBold.ttf': '600',
              'Tomorrow-Bold.ttf': '700',
              'Tomorrow-ExtraBold.ttf': '800',
              'Tomorrow-Black.ttf': '900',
            },
          );
        },
      );
    },
  );
}
