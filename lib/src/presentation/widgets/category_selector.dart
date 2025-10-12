import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';

class CategorySelector extends StatelessWidget {
  const CategorySelector({
    super.key,
    required this.selectedCategory,
    required this.onSelected,
  });

  final String selectedCategory;
  final ValueChanged<String> onSelected;

  static const _categories = <String>[
    'all',
    'business',
    'technology',
    'science',
    'sports',
    'culture',
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return SizedBox(
      height: 48,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final label = _labelFor(category, l10n);
          final isSelected = category == selectedCategory;
          return ChoiceChip(
            label: Text(label),
            selected: isSelected,
            onSelected: (_) => onSelected(category),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemCount: _categories.length,
      ),
    );
  }

  String _labelFor(String category, AppLocalizations l10n) {
    switch (category) {
      case 'business':
        return l10n.category_business;
      case 'technology':
        return l10n.category_technology;
      case 'science':
        return l10n.category_science;
      case 'sports':
        return l10n.category_sports;
      case 'culture':
        return l10n.category_culture;
      default:
        return l10n.category_all;
    }
  }
}
