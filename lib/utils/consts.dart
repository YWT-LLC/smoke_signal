/* smoke_signal
 * Copyright (c) 2026 Empathetech LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import 'package:flutter/material.dart';
import 'package:empathetech_flutter_ui/empathetech_flutter_ui.dart';

// App config //

/// Smoke Signal
const String appName = 'Smoke Signal';

/// net.empathetech.smoke_signal
const String androidPackage = 'net.empathetech.smoke_signal';

// Local assets //

/// assets/images/app-icon.png
const String appIconPath = 'assets/images/app-icon.png';

/// assets/images/dark-forest.png
const String darkForestPath = 'assets/images/dark-forest.png';

/// assets/images/light-forest.png
const String lightForestPath = 'assets/images/light-forest.png';

/// assets/images/smoke-signal.gif
const String smokeSignalPath = 'assets/images/smoke-signal.gif';

/// Entries for [EzCM.init]
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

//* EzConfig *//

// Signal settings //

const String darkSignalImageKey = 'darkSignalImage';
const String darkSignalImageFitKey = 'darkSignalImageFit';
const String darkSignalHeightKey = 'darkSignalHeight';
const String darkSignalCountHeightKey = 'darkSignalCountHeight';

const String lightSignalImageKey = 'lightSignalImage';
const String lightSignalImageFitKey = 'lightSignalImageFit';
const String lightSignalHeightKey = 'lightSignalHeight';
const String lightSignalCountHeightKey = 'lightSignalCountHeight';

/// dark/light x [signal image, height, count height]
const Map<String, Type> signalConfigKeys = <String, Type>{
  // Dark
  darkSignalImageKey: String,
  darkSignalImageFitKey: String,
  darkSignalHeightKey: double,
  darkSignalCountHeightKey: double,

  // Light
  lightSignalImageKey: String,
  lightSignalImageFitKey: String,
  lightSignalHeightKey: double,
  lightSignalCountHeightKey: double,
};

// EzConfig default //

final Map<String, Object> mobileSmokeSignalConfig = <String, Object>{
  ...empathMobileConfig,

  // Design settings
  darkSignalHeightKey: 200.0,
  darkSignalCountHeightKey: 100.0,
  darkBackgroundImageKey: darkForestPath,
  darkBackgroundFitKey: BoxFit.fill.name,
  darkSignalImageKey: smokeSignalPath,
  darkSignalImageFitKey: BoxFit.fill.name,

  lightSignalHeightKey: 200.0,
  lightSignalCountHeightKey: 100.0,
  lightBackgroundImageKey: lightForestPath,
  lightBackgroundFitKey: BoxFit.fill.name,
  lightSignalImageKey: smokeSignalPath,
  lightSignalImageFitKey: BoxFit.fill.name,

  // Text settings
  darkTextBackgroundOpacityKey: 0.35,
  lightTextBackgroundOpacityKey: 0.70,
};

final Map<String, Object> desktopSmokeSignalConfig = <String, Object>{
  ...empathDesktopConfig,

  // Design settings
  darkSignalHeightKey: 250.0,
  darkSignalCountHeightKey: 125.0,
  darkBackgroundImageKey: darkForestPath,
  darkBackgroundFitKey: BoxFit.fill.name,
  darkSignalImageKey: smokeSignalPath,
  darkSignalImageFitKey: BoxFit.fill.name,

  lightSignalHeightKey: 250.0,
  lightSignalCountHeightKey: 125.0,
  lightBackgroundImageKey: lightForestPath,
  lightBackgroundFitKey: BoxFit.fill.name,
  lightSignalImageKey: smokeSignalPath,
  lightSignalImageFitKey: BoxFit.fill.name,

  // Text settings
  darkTextBackgroundOpacityKey: 0.35,
  lightTextBackgroundOpacityKey: 0.70,
};

const Map<String, Type> allSmokeSignalKeys = <String, Type>{
  ...allEZConfigKeys,
  ...signalConfigKeys,
};
