import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:suvidha/providers/theme_provider.dart';

import '../../widgets/form_bottom_sheet_header.dart';

class ChangeThemeBottomSheet extends StatelessWidget {
  const ChangeThemeBottomSheet({super.key});

  static Future<T?> show<T>(BuildContext context) {
    return showModalBottomSheet<T>(
        context: context,
        builder: (context) => const ChangeThemeBottomSheet(),
        isScrollControlled: true);
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const FormBottomSheetHeader(title: 'Choose theme'),
        ListTile(
          title: const Text('System'),
          leading: const Icon(Icons.brightness_auto),
          trailing: themeProvider.themeMode == ThemeMode.system
              ? const Icon(Icons.check)
              : null,
          onTap: () {
            themeProvider.setThemeMode(ThemeMode.system);
            Navigator.pop(context);
          },
        ),
        ListTile(
          title: const Text('Light'),
          leading: const Icon(Icons.light_mode),
          trailing: themeProvider.themeMode == ThemeMode.light
              ? const Icon(Icons.check)
              : null,
          onTap: () {
            themeProvider.setThemeMode(ThemeMode.light);
            Navigator.pop(context);
          },
        ),
        ListTile(
          title: const Text('Dark'),
          leading: const Icon(Icons.dark_mode),
          trailing: themeProvider.themeMode == ThemeMode.dark
              ? const Icon(Icons.check)
              : null,
          onTap: () {
            themeProvider.setThemeMode(ThemeMode.dark);
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
