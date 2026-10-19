/* smoke_signal
 * Copyright (c) 2026 YWT (Empathetech LLC). All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import './screens/export.dart';
import './utils/export.dart';
import './widgets/export.dart';

import 'package:open_ui/open_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Define the router //

final List<RouteBase> routes = <RouteBase>[
  // Home
  GoRoute(
    path: homePath,
    name: homeName,
    pageBuilder: (BuildContext pbc, GoRouterState pbs) =>
        ezPageBuilder(configWatcher(pbc), pbc, pbs, const HomeScreen()),
    routes: <RouteBase>[
      // Settings
      GoRoute(
        path: settingsScreenPath,
        name: settingsScreenName,
        pageBuilder: (BuildContext pbc, GoRouterState pbs) =>
            ezPageBuilder(configWatcher(pbc), pbc, pbs, const SettingsHubScreen()),
      ),
    ],
  ),
];

// Define the app //

class SmokeSignal extends StatelessWidget {
  final Locale storedLocale;
  final OUILang storedOUILang;
  final Lang storedLang;

  const SmokeSignal(
    this.storedLocale,
    this.storedOUILang,
    this.storedLang, {
    super.key,
  });

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider<UserProvider>(
        create: (_) => UserProvider(null),
        child: _TheMagic(storedLocale, storedOUILang, storedLang),
      );
}

class _TheMagic extends StatelessWidget {
  final Locale storedLocale;
  final OUILang storedOUILang;
  final Lang storedLang;

  const _TheMagic(this.storedLocale, this.storedOUILang, this.storedLang);

  void precacheImages(BuildContext context) {
    precacheImage(appIcon, context);
    precacheImage(signalGif, context);
  }

  @override
  Widget build(BuildContext context) {
    precacheImages(context);

    return EzConfigurableApp(
      localizationsDelegates: ezLocalizationsDelegates(Lang.localizationsDelegates),
      supportedLocales: Lang.supportedLocales,
      locale: storedLocale,
      el10n: storedOUILang,
      appCache: SmokeSignalCache(storedLocale, storedLang),
      routerConfig: GoRouter(
        initialLocation: homePath,
        errorBuilder: (_, __) => const ErrorScreen(),
        routes: routes,
      ),
    );
  }
}

void main() async {
  // Configure the environment //

  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(DeviceOrientation.values);

  EzCM.init(
    appName: appName,
    androidPackage: androidPackage,
    assetPaths: assetPaths,
    orientations: DeviceOrientation.values,
    localeFallback: americanEnglish,
    l10nFallback: await OUILang.delegate.load(americanEnglish),
    preferences: await SharedPreferencesWithCache.create(
      cacheOptions: SharedPreferencesWithCacheOptions(
        allowList: allSmokeSignalKeys.keys.toSet(),
      ),
    ),
    securePreferences: const FlutterSecureStorage(),
    defaults: isMobile() ? mobileSmokeSignalConfig : desktopSmokeSignalConfig,
  );

  await setMinWindow();

  // Run the app //

  final (Locale storedLocale, OUILang storedOUILang) = await ezStoredL10n();

  runApp(SmokeSignal(
    storedLocale,
    storedOUILang,
    await Lang.delegate.load(storedLocale),
  ));
}
