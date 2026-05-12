import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:metrogo/l10n/app_localizations.dart';
import '../providers/settings_provider.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppL10n.of(context);
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(l10n.language),
            subtitle: Text(
              settings.locale == null
                  ? l10n.system
                  : settings.locale!.languageCode == 'ar'
                      ? l10n.arabic
                      : l10n.english,
            ),
            onTap: () => _showLanguageDialog(context, notifier, l10n, settings),
          ),
          ListTile(
            leading: const Icon(Icons.palette),
            title: Text(l10n.theme),
            subtitle: Text(
              settings.themeMode == ThemeMode.system
                  ? l10n.system
                  : settings.themeMode == ThemeMode.light
                      ? l10n.lightTheme
                      : l10n.darkTheme,
            ),
            onTap: () => _showThemeDialog(context, notifier, l10n, settings),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.update),
            title: Text(l10n.checkForUpdates),
            subtitle: Text(l10n.dataUpToDate),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.dataUpToDate)),
              );
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(l10n.about),
            subtitle: const Text('MetroGo Cairo v1.0.0'),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(
    BuildContext context,
    SettingsNotifier notifier,
    AppL10n l10n,
    SettingsState settings,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: Text(l10n.language),
        children: [
          _buildOption(ctx, l10n.system, settings.locale == null, () {
            notifier.setLocale(null);
            Navigator.pop(ctx);
          }),
          _buildOption(ctx, l10n.arabic,
              settings.locale?.languageCode == 'ar', () {
            notifier.setLocale(const Locale('ar'));
            Navigator.pop(ctx);
          }),
          _buildOption(ctx, l10n.english,
              settings.locale?.languageCode == 'en', () {
            notifier.setLocale(const Locale('en'));
            Navigator.pop(ctx);
          }),
        ],
      ),
    );
  }

  void _showThemeDialog(
    BuildContext context,
    SettingsNotifier notifier,
    AppL10n l10n,
    SettingsState settings,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: Text(l10n.theme),
        children: [
          _buildOption(ctx, l10n.system,
              settings.themeMode == ThemeMode.system, () {
            notifier.setThemeMode(ThemeMode.system);
            Navigator.pop(ctx);
          }),
          _buildOption(ctx, l10n.lightTheme,
              settings.themeMode == ThemeMode.light, () {
            notifier.setThemeMode(ThemeMode.light);
            Navigator.pop(ctx);
          }),
          _buildOption(ctx, l10n.darkTheme,
              settings.themeMode == ThemeMode.dark, () {
            notifier.setThemeMode(ThemeMode.dark);
            Navigator.pop(ctx);
          }),
        ],
      ),
    );
  }

  Widget _buildOption(
      BuildContext context, String title, bool selected, VoidCallback onTap) {
    return ListTile(
      title: Text(title),
      leading: Icon(
        selected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
        color: selected ? Theme.of(context).colorScheme.primary : null,
      ),
      onTap: onTap,
    );
  }
}
