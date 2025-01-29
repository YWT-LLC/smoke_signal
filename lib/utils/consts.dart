/* smoke_signal
 * Copyright (c) 2022-2025 Empathetech LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import 'package:empathetech_flutter_ui/empathetech_flutter_ui.dart';

// App config //

/// 'Smoke Signal'
const String appTitle = 'Smoke Signal';

/// 90.0; Chosen via visual inspection
const double imageSize = 90.0;

/// 'signalImage'
const String signalImageKey = 'signalImage';

/// '200.0'
const double signalHeight = 200.0;

/// '100.0'
const double signalCountHeight = 100.0;

final Map<String, Object> ssDefaults = <String, Object>{
  ...empathetechConfig,
  darkBackgroundImageKey: darkForestPath,
  '$darkBackgroundImageKey$boxFitSuffix': fill,
  lightBackgroundImageKey: lightForestPath,
  '$lightBackgroundImageKey$boxFitSuffix': fill,
  darkTextBackgroundOpacityKey: 0.35,
  lightTextBackgroundOpacityKey: 0.70,
  signalImageKey: smokeSignalPath,
};

// Images //

/// 'assets/images/app-icon.png'
const String appIconPath = 'assets/images/app-icon.png';

/// 'assets/images/dark-forest.png'
const String darkForestPath = 'assets/images/dark-forest.png';

/// 'assets/images/light-forest.png'
const String lightForestPath = 'assets/images/light-forest.png';

/// 'assets/images/smoke-signal.gif'
const String smokeSignalPath = 'assets/images/smoke-signal.gif';

/// Paths to asset files for [EzConfig.assetPaths]
/// [appIconPath], [darkForestPath], [smokeSignalPath]
const Set<String> assetPaths = <String>{
  appIconPath,
  darkForestPath,
  lightForestPath,
  smokeSignalPath,
};

/// Image path -> image creator
const Map<String, String> credits = <String, String>{
  appIconPath: 'The Founder',
  darkForestPath: 'https://edermunizz.itch.io/',
  lightForestPath: 'https://ansimuz.itch.io/',
  smokeSignalPath: 'https://pimen.itch.io/',
};
