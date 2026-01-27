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
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:empathetech_flutter_ui/empathetech_flutter_ui.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';

void main() async {
  // Setup the app //

  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations(DeviceOrientation.values);

  // Initialize EzConfig //

  EzConfig.init(
    assetPaths: assetPaths,
    defaults: isMobile() ? mobileSmokeSignalConfig : desktopSmokeSignalConfig,
    localeFallback: americanEnglish,
    l10nFallback: await EFUILang.delegate.load(americanEnglish),
    preferences: await SharedPreferencesWithCache.create(
      cacheOptions: SharedPreferencesWithCacheOptions(
        allowList: allSmokeSignalKeys.keys.toSet(),
      ),
    ),
  );

  // Run the app //

  runApp(const SmokeSignal());
}

class SmokeSignal extends StatelessWidget {
  const SmokeSignal({super.key});

  // Define setup functions //

  Future<void> precacheImages(BuildContext context) async {
    precacheImage(appIcon, context);
    precacheImage(signalGif, context);
  }

  // Return the build //

  @override
  Widget build(BuildContext context) {
    precacheImages(context);

    return ChangeNotifierProvider<AppUserProvider>(
      create: (_) => AppUserProvider(null),
      child: EzConfigurableApp(
        localizationsDelegates: <LocalizationsDelegate<dynamic>>{
          const LocaleNamesLocalizationsDelegate(),
          ...EFUILang.localizationsDelegates,
          ...Lang.localizationsDelegates,
        },
        supportedLocales: Lang.supportedLocales,
        appName: appName,
        routerConfig: GoRouter(
          initialLocation: homePath,
          errorBuilder: (_, GoRouterState state) => ErrorScreen(state.error),
          routes: <RouteBase>[
            // Home
            GoRoute(
              path: homePath,
              name: homePath,
              pageBuilder: (BuildContext context, GoRouterState state) =>
                  ezPageBuilder(context, state, const HomeScreen()),
              routes: <RouteBase>[
                // Reset password
                GoRoute(
                  path: resetPasswordPath,
                  name: resetPasswordPath,
                  pageBuilder: (BuildContext context, GoRouterState state) =>
                      ezPageBuilder(
                          context, state, const ResetPasswordScreen()),
                ),

                // Profile settings
                GoRoute(
                  path: profileSettingsPath,
                  name: profileSettingsPath,
                  pageBuilder: (BuildContext context, GoRouterState state) =>
                      ezPageBuilder(
                          context, state, const ProfileSettingsScreen()),
                ),

                // Create signal
                GoRoute(
                  path: createSignalPath,
                  name: createSignalPath,
                  pageBuilder: (BuildContext context, GoRouterState state) =>
                      ezPageBuilder(context, state, const CreateSignalScreen()),
                ),

                // Signal members
                GoRoute(
                  path: signalMembersPath,
                  name: signalMembersPath,
                  pageBuilder: (BuildContext context, GoRouterState state) =>
                      ezPageBuilder(context, state,
                          SignalMembersScreen(signal: state.extra as Signal)),
                ),
                // Settings home
                GoRoute(
                  path: settingsHomePath,
                  name: settingsHomePath,
                  pageBuilder: (BuildContext context, GoRouterState state) =>
                      ezPageBuilder(context, state, const SettingsHomeScreen()),
                  routes: <RouteBase>[
                    // Color settings
                    GoRoute(
                      path: colorSettingsPath,
                      name: colorSettingsPath,
                      pageBuilder:
                          (BuildContext context, GoRouterState state) =>
                              ezPageBuilder(
                                  context, state, const ColorSettingsScreen()),
                      routes: <RouteBase>[
                        GoRoute(
                          path: EzCSType.quick.path,
                          name: EzCSType.quick.name,
                          pageBuilder:
                              (BuildContext context, GoRouterState state) =>
                                  ezPageBuilder(
                            context,
                            state,
                            const ColorSettingsScreen(target: EzCSType.quick),
                          ),
                        ),
                        GoRoute(
                          path: EzCSType.advanced.path,
                          name: EzCSType.advanced.name,
                          pageBuilder:
                              (BuildContext context, GoRouterState state) =>
                                  ezPageBuilder(
                            context,
                            state,
                            const ColorSettingsScreen(
                                target: EzCSType.advanced),
                          ),
                        ),
                      ],
                    ),

                    // Design settings
                    GoRoute(
                      path: designSettingsPath,
                      name: designSettingsPath,
                      pageBuilder:
                          (BuildContext context, GoRouterState state) =>
                              ezPageBuilder(
                                  context, state, const DesignSettingsScreen()),
                    ),

                    // Layout settings
                    GoRoute(
                      path: layoutSettingsPath,
                      name: layoutSettingsPath,
                      pageBuilder:
                          (BuildContext context, GoRouterState state) =>
                              ezPageBuilder(
                                  context, state, const LayoutSettingsScreen()),
                    ),

                    // Text settings
                    GoRoute(
                      path: textSettingsPath,
                      name: textSettingsPath,
                      pageBuilder:
                          (BuildContext context, GoRouterState state) =>
                              ezPageBuilder(
                                  context, state, const TextSettingsScreen()),
                      routes: <RouteBase>[
                        GoRoute(
                          path: EzTSType.quick.path,
                          name: EzTSType.quick.name,
                          pageBuilder:
                              (BuildContext context, GoRouterState state) =>
                                  ezPageBuilder(
                            context,
                            state,
                            const TextSettingsScreen(target: EzTSType.quick),
                          ),
                        ),
                        GoRoute(
                          path: EzTSType.advanced.path,
                          name: EzTSType.advanced.name,
                          pageBuilder:
                              (BuildContext context, GoRouterState state) =>
                                  ezPageBuilder(
                            context,
                            state,
                            const TextSettingsScreen(target: EzTSType.advanced),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
