# Poppins Font Setup Guide

This guide explains how to properly set up the Poppins font in your Flutter project.

## Steps to Set Up Poppins Font

### 1. Create Directories (if they don't exist)

Make sure the following directory structure exists:
```
assets/fonts/
```

### 2. Copy Font Files

Copy all the Poppins font files from your Poppins folder to the `assets/fonts/` directory:

- Poppins-Thin.ttf
- Poppins-ExtraLight.ttf
- Poppins-Light.ttf
- Poppins-Regular.ttf
- Poppins-Medium.ttf
- Poppins-SemiBold.ttf
- Poppins-Bold.ttf
- Poppins-ExtraBold.ttf
- Poppins-Black.ttf
- Poppins-ThinItalic.ttf
- Poppins-ExtraLightItalic.ttf
- Poppins-LightItalic.ttf
- Poppins-Italic.ttf
- Poppins-MediumItalic.ttf
- Poppins-SemiBoldItalic.ttf
- Poppins-BoldItalic.ttf
- Poppins-ExtraBoldItalic.ttf
- Poppins-BlackItalic.ttf

### 3. Your pubspec.yaml File

The `pubspec.yaml` file has already been updated with the Poppins font configuration:

```yaml
fonts:
  - family: Poppins
    fonts:
      - asset: assets/fonts/Poppins-Thin.ttf
        weight: 100
      - asset: assets/fonts/Poppins-ExtraLight.ttf
        weight: 200
      - asset: assets/fonts/Poppins-Light.ttf
        weight: 300
      - asset: assets/fonts/Poppins-Regular.ttf
        weight: 400
      - asset: assets/fonts/Poppins-Medium.ttf
        weight: 500
      - asset: assets/fonts/Poppins-SemiBold.ttf
        weight: 600
      - asset: assets/fonts/Poppins-Bold.ttf
        weight: 700
      - asset: assets/fonts/Poppins-ExtraBold.ttf
        weight: 800
      - asset: assets/fonts/Poppins-Black.ttf
        weight: 900
      - asset: assets/fonts/Poppins-ThinItalic.ttf
        weight: 100
        style: italic
      - asset: assets/fonts/Poppins-ExtraLightItalic.ttf
        weight: 200
        style: italic
      - asset: assets/fonts/Poppins-LightItalic.ttf
        weight: 300
        style: italic
      - asset: assets/fonts/Poppins-Italic.ttf
        weight: 400
        style: italic
      - asset: assets/fonts/Poppins-MediumItalic.ttf
        weight: 500
        style: italic
      - asset: assets/fonts/Poppins-SemiBoldItalic.ttf
        weight: 600
        style: italic
      - asset: assets/fonts/Poppins-BoldItalic.ttf
        weight: 700
        style: italic
      - asset: assets/fonts/Poppins-ExtraBoldItalic.ttf
        weight: 800
        style: italic
      - asset: assets/fonts/Poppins-BlackItalic.ttf
        weight: 900
        style: italic
```

### 4. Using Poppins in Your Code

After running `flutter pub get`, you can use Poppins in your code:

```dart
// Using Poppins as default font for the entire app
MaterialApp(
  theme: ThemeData(
    fontFamily: 'Poppins',
  ),
  // ... rest of your app
);

// Using Poppins for specific text
Text(
  'Hello World',
  style: TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w500, // Medium
  ),
)
```

### 5. Troubleshooting

If the fonts don't appear correctly:

1. Verify the font files are in the correct directory
2. Make sure there are no typos in the pubspec.yaml file
3. Run `flutter clean` followed by `flutter pub get`
4. Restart your app completely

## Note

You may also add a ThemeData extension for easier access to different weights:

```dart
extension PoppinsText on TextTheme {
  TextStyle get thin => TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w100);
  TextStyle get extraLight => TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w200);
  TextStyle get light => TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w300);
  TextStyle get regular => TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w400);
  TextStyle get medium => TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w500);
  TextStyle get semiBold => TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600);
  TextStyle get bold => TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w700);
  TextStyle get extraBold => TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w800);
  TextStyle get black => TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w900);
}
```