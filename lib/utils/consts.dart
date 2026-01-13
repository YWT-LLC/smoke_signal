/* smoke_signal
 * Copyright (c) 2025 Empathetech LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import 'package:empathetech_flutter_ui/empathetech_flutter_ui.dart';

// Images //

/// 'assets/images/app-icon.png'
const String appIconPath = 'assets/images/app-icon.png';

/// 'assets/images/dark-forest.png'
const String darkForestPath = 'assets/images/dark-forest.png';

/// 'assets/images/light-forest.png'
const String lightForestPath = 'assets/images/light-forest.png';

/// 'assets/images/smoke-signal.gif'
const String smokeSignalPath = 'assets/images/smoke-signal.gif';

/// Entries for [EzConfig.assetPaths]
const Set<String> assetPaths = <String>{
  appIconPath,
  darkForestPath,
  lightForestPath,
  smokeSignalPath,
};

/// Image path -> image creator
const Map<String, String> credits = <String, String>{
  appIconPath: 'Michael Waldron',
  darkForestPath: 'https://edermunizz.itch.io/',
  lightForestPath: 'https://ansimuz.itch.io/',
  smokeSignalPath: 'https://pimen.itch.io/',
};

// EzConfig //

/// 'Smoke Signal'
const String appTitle = 'Smoke Signal';

/// 'signal_image'
const String signalImageKey = 'signal_image';

/// 'signal_height'
const String signalHeightKey = 'signal_height';

/// 'signal_count_height'
const String signalCountHeightKey = 'signal_count_height';

final Map<String, Object> mobileSmokeSignalConfig = <String, Object>{
  ...empathMobileConfig,

  // Text settings
  darkTextBackgroundOpacityKey: 0.35,
  lightTextBackgroundOpacityKey: 0.70,

  // Layout? Design?
  signalHeightKey: 200.0,
  signalCountHeightKey: 100.0,

  // Image settings
  darkBackgroundImageKey: darkForestPath,
  '$darkBackgroundImageKey$boxFitSuffix': fill,
  lightBackgroundImageKey: lightForestPath,
  '$lightBackgroundImageKey$boxFitSuffix': fill,
  signalImageKey: smokeSignalPath,
  '$signalImageKey$boxFitSuffix': fill,
};

final Map<String, Object> desktopSmokeSignalConfig = <String, Object>{
  ...empathDesktopConfig,

  // Text settings
  darkTextBackgroundOpacityKey: 0.35,
  lightTextBackgroundOpacityKey: 0.70,

  // Layout? Design?
  signalHeightKey: 250.0,
  signalCountHeightKey: 125.0,

  // Image settings
  darkBackgroundImageKey: darkForestPath,
  '$darkBackgroundImageKey$boxFitSuffix': fill,
  lightBackgroundImageKey: lightForestPath,
  '$lightBackgroundImageKey$boxFitSuffix': fill,
  signalImageKey: smokeSignalPath,
  '$signalImageKey$boxFitSuffix': fill,
};
