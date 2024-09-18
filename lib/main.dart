/* smoke_signal
 * Copyright (c) 2022-2024 Empathetech LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import './screens/export.dart';
import './utils/export.dart';
import './widgets/export.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:feedback/feedback.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:empathetech_ss_api/empathetech_ss_api.dart';
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
    assetPaths: assets,
    defaults: ssDefaults,
  );

  // Initialize firebase //

  await Firebase.initializeApp();

  AppUser.messager = FirebaseMessaging.instance;
  AppUser.auth = FirebaseAuth.instance;

  // Run the app //
  // With a feedback wrapper

  late final TextStyle lightFeedbackText = buildBody(Colors.black);
  late final TextStyle darkFeedbackText = buildBody(Colors.white);

  runApp(BetterFeedback(
    theme: FeedbackThemeData(
      background: Colors.grey,
      feedbackSheetColor: Colors.white,
      activeFeedbackModeColor: empathPurple,
      bottomSheetDescriptionStyle: lightFeedbackText,
      bottomSheetTextInputStyle: lightFeedbackText,
      sheetIsDraggable: true,
      dragHandleColor: Colors.grey,
      colorScheme: const ColorScheme.light(primary: empathGoldenrod),
    ),
    darkTheme: FeedbackThemeData(
      background: Colors.grey,
      feedbackSheetColor: Colors.black,
      activeFeedbackModeColor: empathEucalyptus,
      bottomSheetDescriptionStyle: darkFeedbackText,
      bottomSheetTextInputStyle: darkFeedbackText,
      sheetIsDraggable: true,
      dragHandleColor: Colors.grey,
      colorScheme: const ColorScheme.dark(primary: empathGoldenrod),
    ),
    themeMode: EzConfig.getThemeMode(),
    localizationsDelegates: <LocalizationsDelegate<dynamic>>[
      const LocaleNamesLocalizationsDelegate(),
      ...EFUILang.localizationsDelegates,
      EmpathetechFeedbackLocalizationsDelegate(),
    ],
    localeOverride: EzConfig.getLocale(),
    child: const SmokeSignal(),
  ));
}

final GoRouter router = GoRouter(
  initialLocation: homePath,
  routes: <RouteBase>[
    GoRoute(
      path: homePath,
      name: homePath,
      builder: (BuildContext context, GoRouterState state) {
        return const HomeScreen();
      },
      routes: <RouteBase>[
        GoRoute(
          path: settingsPath,
          name: settingsPath,
          builder: (BuildContext context, GoRouterState state) {
            return const SettingsHomeScreen();
          },
          routes: <RouteBase>[
            GoRoute(
              path: textSettingsPath,
              name: textSettingsPath,
              builder: (BuildContext context, GoRouterState state) {
                return const TextSettingsScreen();
              },
            ),
            GoRoute(
              path: colorSettingsPath,
              name: colorSettingsPath,
              builder: (BuildContext context, GoRouterState state) {
                return const ColorSettingsScreen();
              },
            ),
            GoRoute(
              path: layoutSettingsPath,
              name: layoutSettingsPath,
              builder: (BuildContext context, GoRouterState state) {
                return const LayoutSettingsScreen();
              },
            ),
            GoRoute(
              path: imageSettingsPath,
              name: imageSettingsPath,
              builder: (BuildContext context, GoRouterState state) {
                return const ImageSettingsScreen();
              },
            ),
          ],
        ),
      ],
    ),
  ],
);

class SmokeSignal extends StatelessWidget {
  const SmokeSignal({super.key});

  Future<void> precacheImages(BuildContext context) async {
    precacheImage(signalGif, context);
  }

  @override
  Widget build(BuildContext context) {
    precacheImages(context);

    return EzAppProvider(
      scaffoldMessengerKey: scaffoldMessengerKey,
      app: PlatformApp.router(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: <LocalizationsDelegate<dynamic>>{
          const LocaleNamesLocalizationsDelegate(),
          ...EFUILang.localizationsDelegates,
          ...Lang.localizationsDelegates,
          EmpathetechFeedbackLocalizationsDelegate(),
        },
        supportedLocales: const <Locale>[
          ...EFUILang.supportedLocales,
          ...Lang.supportedLocales,
        ],
        locale: EzConfig.getLocale(),
        title: appTitle,
        routerConfig: router,
      ),
    );
  }
}
