Add your font files here to enable the optional Bookerly reading font.

Expected filenames (you can adjust if needed, but keep the pubspec in sync):
- assets/fonts/Bookerly-Regular.ttf
- assets/fonts/Bookerly-Bold.ttf
- assets/fonts/Bookerly-Italic.ttf

How to enable in the app:
1) Copy the .ttf files into this folder.
2) In pubspec.yaml, under `flutter:`, uncomment the `fonts:` block for `Bookerly`.
3) Run `flutter pub get`.
4) In the app, choose the Bookerly font from the Appearance/Settings panel.

Note: If you prefer an open-source alternative, you can replace these with any
OFL-licensed serif fonts and keep the family name as 'Bookerly', or rename the
family in code (SettingsController + main.dart) to match your chosen font.
