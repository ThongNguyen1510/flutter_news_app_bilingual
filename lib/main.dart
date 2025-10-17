import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'l10n/app_localizations.dart';
import 'src/data/locale_controller.dart';
import 'src/data/news_controller.dart';
import 'src/data/news_repository.dart';
import 'src/presentation/pages/home_page.dart';

void main() {
  runApp(NewsApp());
}

class NewsApp extends StatelessWidget {
  NewsApp({super.key, NewsRepository? repository})
    : _repository = repository ?? NewsRepository();

  final NewsRepository _repository;

  ThemeData _buildLightTheme() {
    final base = FlexThemeData.light(
      scheme: FlexScheme.espresso,
      useMaterial3: true,
      surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
      blendLevel: 10,
      subThemesData: const FlexSubThemesData(
        blendOnLevel: 20,
        blendOnColors: false,
        elevatedButtonSchemeColor: SchemeColor.primary,
        filledButtonSchemeColor: SchemeColor.secondary,
        bottomSheetRadius: 24,
        bottomSheetElevation: 2,
      ),
    );
    final textTheme = GoogleFonts.openSansTextTheme(base.textTheme);
    final displayTheme = GoogleFonts.playfairDisplayTextTheme(base.textTheme);
    return base.copyWith(
      textTheme: textTheme,
      primaryTextTheme: textTheme,
      appBarTheme: base.appBarTheme.copyWith(
        titleTextStyle: displayTheme.headlineSmall?.copyWith(
          color: base.colorScheme.onSurface,
          fontWeight: FontWeight.bold,
        ),
        centerTitle: false,
        elevation: 0,
      ),
      cardTheme: base.cardTheme.copyWith(
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  ThemeData _buildDarkTheme() {
    final base = FlexThemeData.dark(
      scheme: FlexScheme.espresso,
      useMaterial3: true,
      surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
      blendLevel: 15,
      subThemesData: const FlexSubThemesData(
        blendOnLevel: 20,
        blendOnColors: true,
        bottomSheetRadius: 24,
      ),
    );
    final textTheme = GoogleFonts.openSansTextTheme(base.textTheme).apply(
      bodyColor: base.colorScheme.onSurface,
      displayColor: base.colorScheme.onSurface,
    );
    return base.copyWith(
      textTheme: textTheme,
      primaryTextTheme: textTheme,
      appBarTheme: base.appBarTheme.copyWith(centerTitle: false),
      cardTheme: base.cardTheme.copyWith(
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<NewsRepository>.value(value: _repository),
        ChangeNotifierProvider(create: (_) => LocaleController()),
        ChangeNotifierProvider(
          create: (context) {
            final repo = context.read<NewsRepository>();
            final controller = NewsController(repo);
            controller.loadArticles();
            return controller;
          },
        ),
      ],
      child: Consumer<LocaleController>(
        builder: (context, localeController, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Viet News',
            locale: localeController.locale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            theme: _buildLightTheme(),
            darkTheme: _buildDarkTheme(),
            themeMode: ThemeMode.system,
            home: const HomePage(),
          );
        },
      ),
    );
  }
}
