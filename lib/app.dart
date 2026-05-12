import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:metrogo/l10n/app_localizations.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/settings/presentation/providers/settings_provider.dart';

class MetroGoApp extends ConsumerWidget {
  const MetroGoApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final router = ref.watch(routerProvider);
    final effectiveLocale = settings.locale ?? const Locale('ar');

    return MaterialApp.router(
      title: 'MetroGo Cairo',
      debugShowCheckedModeBanner: false,
      locale: settings.locale,
      supportedLocales: AppL10n.supportedLocales,
      localizationsDelegates: const [
        AppL10n.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: AppTheme.light(effectiveLocale),
      darkTheme: AppTheme.dark(effectiveLocale),
      themeMode: settings.themeMode,
      routerConfig: router,
      builder: (context, child) {
        final locale = Localizations.localeOf(context);
        return Directionality(
          textDirection: locale.languageCode == 'ar'
              ? TextDirection.rtl
              : TextDirection.ltr,
          child: child!,
        );
      },
    );
  }
}
