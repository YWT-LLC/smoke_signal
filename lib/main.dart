/* smoke_signal
 * Copyright (c) 2026 Empathetech LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import '../../api/export.dart';
import './screens/export.dart';
import './utils/export.dart';
import './widgets/export.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:empathetech_flutter_ui/empathetech_flutter_ui.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';

void main() async {
  // Configure the app //

  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(DeviceOrientation.values);

  EzCM.init(
    appName: appName,
    androidPackage: androidPackage,
    assetPaths: assetPaths,
    orientations: DeviceOrientation.values,
    localeFallback: americanEnglish,
    l10nFallback: await EFUILang.delegate.load(americanEnglish),
    preferences: await SharedPreferencesWithCache.create(
      cacheOptions: SharedPreferencesWithCacheOptions(
        allowList: allSmokeSignalKeys.keys.toSet(),
      ),
    ),
    defaults: isMobile() ? mobileSmokeSignalConfig : desktopSmokeSignalConfig,
  );

  // Run the app //

  final (Locale storedLocale, EFUILang storedEFUILang) = await ezStoredL10n();

  runApp(SmokeSignal(
    storedLocale,
    storedEFUILang,
    await Lang.delegate.load(storedLocale),
  ));
}

class SmokeSignal extends StatelessWidget {
  final Locale storedLocale;
  final EFUILang storedEFUILang;
  final Lang storedLang;

  const SmokeSignal(
    this.storedLocale,
    this.storedEFUILang,
    this.storedLang, {
    super.key,
  });

  // Cache images //

  void precacheImages(BuildContext context) {
    precacheImage(appIcon, context);
    precacheImage(signalGif, context);
  }

  // Return the app //

  @override
  Widget build(BuildContext context) {
    precacheImages(context);

    return EzConfigurableApp(
      localizationsDelegates: <LocalizationsDelegate<dynamic>>{
        const LocaleNamesLocalizationsDelegate(),
        ...EFUILang.localizationsDelegates,
        ...Lang.localizationsDelegates,
      },
      supportedLocales: Lang.supportedLocales,
      locale: storedLocale,
      el10n: storedEFUILang,
      appCache: SmokeSignalCache(storedLocale, storedLang),
      routerConfig: GoRouter(
        initialLocation: homePath,
        errorBuilder: (_, GoRouterState state) => const ErrorScreen(),
        routes: <RouteBase>[
          // Home
          GoRoute(
            path: homePath,
            name: homePath,
            pageBuilder: (BuildContext pbc, GoRouterState pbs) =>
                ezPageBuilder(configWatcher(pbc), pbc, pbs, const HomeScreen()),
            routes: <RouteBase>[
              // Reset password
              GoRoute(
                path: resetPasswordPath,
                name: resetPasswordPath,
                pageBuilder: (BuildContext pbc, GoRouterState pbs) =>
                    ezPageBuilder(configWatcher(pbc), pbc, pbs, const ResetPasswordScreen()),
              ),

              // Profile settings
              GoRoute(
                path: profileSettingsPath,
                name: profileSettingsPath,
                pageBuilder: (BuildContext pbc, GoRouterState pbs) =>
                    ezPageBuilder(configWatcher(pbc), pbc, pbs, const ProfileSettingsScreen()),
              ),

              // Create signal
              GoRoute(
                path: createSignalPath,
                name: createSignalPath,
                pageBuilder: (BuildContext pbc, GoRouterState pbs) =>
                    ezPageBuilder(configWatcher(pbc), pbc, pbs, const CreateSignalScreen()),
              ),

              // Signal members
              GoRoute(
                path: signalMembersPath,
                name: signalMembersPath,
                pageBuilder: (BuildContext pbc, GoRouterState pbs) => ezPageBuilder(
                    configWatcher(pbc), pbc, pbs, SignalMembersScreen(pbs.extra as Signal)),
              ),

              // Settings
              GoRoute(
                path: settingsHubPath,
                name: settingsHubPath,
                pageBuilder: (BuildContext pbc, GoRouterState pbs) =>
                    ezPageBuilder(configWatcher(pbc), pbc, pbs, const SettingsHubScreen()),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
