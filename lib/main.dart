import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
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
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
              useMaterial3: true,
            ),
            home: const HomePage(),
          );
        },
      ),
    );
  }
}
