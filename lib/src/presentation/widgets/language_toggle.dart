import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../l10n/app_localizations.dart';
import '../../data/locale_controller.dart';
import '../../data/news_controller.dart';

class LanguageToggle extends StatelessWidget {
  const LanguageToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final localeController = context.watch<LocaleController>();
    final l10n = AppLocalizations.of(context);

    return PopupMenuButton<Locale>(
      tooltip: l10n.changeLanguage,
      icon: const Icon(Icons.language),
      onSelected: (selectedLocale) {
        localeController.switchLocale(selectedLocale);
        context.read<NewsController>().updateLocale(selectedLocale);
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: const Locale('en'),
          child: Row(
            children: [
              if (!localeController.isVietnamese)
                const Icon(Icons.check, size: 16),
              if (!localeController.isVietnamese) const SizedBox(width: 8),
              Text(l10n.languageEnglish),
            ],
          ),
        ),
        PopupMenuItem(
          value: const Locale('vi'),
          child: Row(
            children: [
              if (localeController.isVietnamese)
                const Icon(Icons.check, size: 16),
              if (localeController.isVietnamese) const SizedBox(width: 8),
              Text(l10n.languageVietnamese),
            ],
          ),
        ),
      ],
    );
  }
}
