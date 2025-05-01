/* smoke_signal
 * Copyright (c) 2025 Empathetech LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import '../../api/export.dart';
import './screens/export.dart';
import './utils/export.dart';
import './widgets/export.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:feedback/feedback.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:empathetech_flutter_ui/empathetech_flutter_ui.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';

void main() async {
  // Setup the app //

  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  // Initialize EzConfig //

  final SharedPreferences prefs = await SharedPreferences.getInstance();

  EzConfig.init(
    preferences: prefs,
    defaults: isMobile()
        ? <String, Object>{...mobileEmpathConfig, ...ssConfigEntries}
        : <String, Object>{...desktopEmpathConfig, ...ssConfigEntries},
    fallbackLang: await EFUILang.delegate.load(english),
    assetPaths: assetPaths,
  );

  // Run the app //
  // With a feedback wrapper

  late final TextStyle lightFeedbackText = ezBodyStyle(Colors.black);
  late final TextStyle darkFeedbackText = ezBodyStyle(Colors.white);

  runApp(BetterFeedback(
    theme: FeedbackThemeData(
      background: Colors.grey,
      feedbackSheetColor: Colors.white,
      activeFeedbackModeColor: empathPurple,
      bottomSheetDescriptionStyle: lightFeedbackText,
      bottomSheetTextInputStyle: lightFeedbackText,
      sheetIsDraggable: true,
      dragHandleColor: Colors.black,
    ),
    darkTheme: FeedbackThemeData(
      background: Colors.grey,
      feedbackSheetColor: Colors.black,
      activeFeedbackModeColor: empathEucalyptus,
      bottomSheetDescriptionStyle: darkFeedbackText,
      bottomSheetTextInputStyle: darkFeedbackText,
      sheetIsDraggable: true,
      dragHandleColor: Colors.white,
    ),
    themeMode: EzConfig.getThemeMode(),
    localizationsDelegates: <LocalizationsDelegate<dynamic>>[
      const LocaleNamesLocalizationsDelegate(),
      ...EFUILang.localizationsDelegates,
      ...Lang.localizationsDelegates,
      EmpathetechFeedbackLocalizationsDelegate(),
    ],
    localeOverride: EzConfig.getLocale(),
    child: const SmokeSignal(),
  ));
}

// Define routes //

final GoRouter router = GoRouter(
  initialLocation: homePath,
  errorBuilder: (_, GoRouterState state) => ErrorScreen(state.error),
  routes: <RouteBase>[
    GoRoute(
      path: homePath,
      name: homePath,
      builder: (_, __) => const HomeScreen(),
      routes: <RouteBase>[
        GoRoute(
          path: resetPasswordPath,
          name: resetPasswordPath,
          builder: (_, __) => const ResetPasswordScreen(),
        ),
        GoRoute(
          path: profileSettingsPath,
          name: profileSettingsPath,
          builder: (_, __) => const ProfileSettingsScreen(),
        ),
        GoRoute(
          path: createSignalPath,
          name: createSignalPath,
          builder: (_, __) => const CreateSignalScreen(),
        ),
        GoRoute(
          path: signalMembersPath,
          name: signalMembersPath,
          builder: (_, GoRouterState state) {
            final Signal signal = state.extra as Signal;
            return SignalMembersScreen(signal: signal);
          },
        ),
        GoRoute(
          path: settingsPath,
          name: settingsPath,
          builder: (_, __) => const SettingsHomeScreen(),
          routes: <RouteBase>[
            GoRoute(
              path: textSettingsPath,
              name: textSettingsPath,
              builder: (_, __) => const TextSettingsScreen(),
              routes: <RouteBase>[
                GoRoute(
                  path: EzTSType.quick.path,
                  name: EzTSType.quick.name,
                  builder: (_, __) =>
                      const TextSettingsScreen(target: EzTSType.quick),
                ),
                GoRoute(
                  path: EzTSType.advanced.path,
                  name: EzTSType.advanced.name,
                  builder: (_, __) =>
                      const TextSettingsScreen(target: EzTSType.advanced),
                ),
              ],
            ),
            GoRoute(
              path: layoutSettingsPath,
              name: layoutSettingsPath,
              builder: (_, __) => const LayoutSettingsScreen(),
            ),
            GoRoute(
              path: colorSettingsPath,
              name: colorSettingsPath,
              builder: (_, __) => const ColorSettingsScreen(),
              routes: <RouteBase>[
                GoRoute(
                  path: EzCSType.quick.path,
                  name: EzCSType.quick.name,
                  builder: (_, __) =>
                      const ColorSettingsScreen(target: EzCSType.quick),
                ),
                GoRoute(
                  path: EzCSType.advanced.path,
                  name: EzCSType.advanced.name,
                  builder: (_, __) =>
                      const ColorSettingsScreen(target: EzCSType.advanced),
                ),
              ],
            ),
            GoRoute(
              path: imageSettingsPath,
              name: imageSettingsPath,
              builder: (_, __) => const ImageSettingsScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);

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

    return EzAppProvider(
      app: ChangeNotifierProvider<AppUserProvider>(
        create: (_) => AppUserProvider(null),
        child: PlatformApp.router(
          debugShowCheckedModeBanner: false,
          localizationsDelegates: <LocalizationsDelegate<dynamic>>{
            const LocaleNamesLocalizationsDelegate(),
            ...EFUILang.localizationsDelegates,
            ...Lang.localizationsDelegates,
            EmpathetechFeedbackLocalizationsDelegate(),
          },
          supportedLocales: Lang.supportedLocales,
          locale: EzConfig.getLocale(),
          title: appTitle,
          routerConfig: router,
        ),
      ),
    );
  }
}
