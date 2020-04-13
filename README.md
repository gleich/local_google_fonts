# local_google_fonts ![Pub Version](https://img.shields.io/pub/v/local_google_fonts)

Right now, adding google fonts to your flutter project can take a significant amount of time. This package looks to solve that by streamlining the whole process. All you need to do is add your fonts to your `pubspec.yaml` and run this package (more details below) to have them added to your assets folder and font configuration in your `pubspec.yaml`.

## 🚀 Installing

Simply add `local_google_fonts: ^1.0.5` to your `dev-dependencies`

## 🧾 Configuration

Define what fonts you are requesting by adding the following to your `pubspec.yaml`:

```yaml
google_fonts:
  fonts:
    - Roboto
    - Open Sans
```

---

You can also define the weights if you don't want all available versions of a font. For the italicized version of a weight just add `i` to the end of the weight. Make sure that the weight you are requesting exists for that.

```yaml
google_fonts:
  fonts:
    - Roboto:
        - 400
    - Open Sans:
        - "400i"
        - 800
```

### Defaults

| Name          | Default Value              | Description                                                                                                                                                                                                                                                                     | Turn Off                                                               |
| ------------- | -------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------- |
| format        | true                       | Formats the `pubspec.yaml` file after writing to it because the write makes it look kinda weird. This does require the [prettier cli](https://prettier.io/). If its not currently installed and you have either npm or yarn on your machine it will be install it automatically | Add `format: false` under `google_fonts` in your `pubspec.yaml`        |
| path          | "assets/fonts/googleFonts" | Where the fonts should be downloaded too. **Fonts not used by this program should not be in this folder**.                                                                                                                                                                      | Add `path:  ""` under `google_fonts` in your `pubspec.yaml`            |
| flutterPubGet | true                       | If `flutter pub get` should be ran automatically once the fonts have been added                                                                                                                                                                                                 | Add `flutterPubGet: false` under `google_fonts` in your `pubspec.yaml` |
| docs          | true                       | Adds a `README.md` in the folder for each font with some information about the font.                                                                                                                                                                                            | Add `docs: false` under `google_fonts` in your `pubspec.yaml`          |

## 🏃🏼‍♂️ Running

Simply run `flutter pub run local_google_fonts:main`

## 🙋‍♀️🙋‍♂️ Contributing

All contributions are welcome! Just make sure that its not an already existing issue or pull request
