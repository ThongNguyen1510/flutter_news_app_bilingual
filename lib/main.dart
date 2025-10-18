import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'l10n/app_localizations.dart';
import 'firebase_options.dart';
import 'src/data/article_tracker.dart';
import 'src/data/auth_controller.dart';
import 'src/data/locale_controller.dart';
import 'src/data/news_controller.dart';
import 'src/data/news_repository.dart';
import 'src/data/settings_controller.dart';
import 'src/presentation/pages/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
        ChangeNotifierProvider(create: (_) => AuthController()),
        ChangeNotifierProvider(create: (_) => SettingsController()),
        ChangeNotifierProvider(
          create: (context) => ArticleTracker(
            authController: context.read<AuthController>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) {
            final repo = context.read<NewsRepository>();
            final controller = NewsController(repo);
            controller.loadArticles();
            return controller;
          },
        ),
      ],
      child: Consumer2<LocaleController, SettingsController>(
        builder: (context, localeController, settingsController, _) {
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
            themeMode: settingsController.themeMode,
            builder: (context, child) {
              final media = MediaQuery.of(context);
              return MediaQuery(
                data: media.copyWith(
                  textScaler: TextScaler.linear(settingsController.textScale),
                ),
                child: child ?? const SizedBox.shrink(),
              );
            },
            home: const HomePage(),
          );
        },
      ),
    );
  }
}
