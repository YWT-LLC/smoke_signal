/* smoke_signal
 * Copyright (c) 2026 Empathetech LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import 'screens/home.dart' as home;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:empathetech_flutter_ui/empathetech_flutter_ui.dart';

void main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();

  EzConfig.init(
    assetPaths: <String>{},
    defaults: <String, Object>{
      ...empathMobileConfig,
      appLocaleKey: <String>['es'],
    },
    localeFallback: americanEnglish,
    l10nFallback: await EFUILang.delegate.load(americanEnglish),
    preferences: await SharedPreferencesWithCache.create(
      cacheOptions: SharedPreferencesWithCacheOptions(
          allowList: allEZConfigKeys.keys.toSet()),
    ),
  );

  group(
    'es-locale',
    () {
      home.testSuite(locale: spanish);
    },
  );
}
