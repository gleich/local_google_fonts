# Example

Below is an example of a `pubspec.yaml` setup with local_google_fonts:

```yaml
description: "A new Flutter project."
name: "example_app"
publish_to: "none"
version: "1.0.0+1"
dependencies:
  cupertino_icons: "^0.1.3"
  flutter:
    sdk: "flutter"
dev_dependencies:
  local_google_fonts: "^1.0.4"
  flutter_test:
    sdk: "flutter"
environment:
  sdk: ">=2.7.0 <3.0.0"
flutter:
  fonts:
    - family: "Roboto"
      fonts:
        - asset: "assets/fonts/googleFonts/Roboto/Roboto-400.ttf"
          weight: 400
    - family: "Open Sans"
      fonts:
        - asset: "assets/fonts/googleFonts/Open-Sans/Open-Sans-400i.ttf"
          style: "italic"
          weight: 400
        - asset: "assets/fonts/googleFonts/Open-Sans/Open-Sans-800.ttf"
          weight: 800
  uses-material-design: true
google_fonts:
  fonts:
    - Roboto:
        - 400
    - Open Sans:
        - "400i"
        - 800
```

There is also an [example application](https://github.com/Matt-Gleich/local_google_fonts/tree/master/example/example_app)
