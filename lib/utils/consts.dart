/* smoke_signal
 * Copyright (c) 2022-2024 Empathetech LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import 'package:empathetech_flutter_ui/empathetech_flutter_ui.dart';

// App config //

/// 'Smoke Signal'
const String appTitle = 'Smoke Signal';

/// Paths to asset files for [EzConfig.assetPaths]
/// [appIconPath], [darkForestPath], [smokeSignalPath]
final Set<String> assets = <String>{
  appIconPath,
  darkForestPath,
  smokeSignalPath,
};

// Custom EzConfig keys

/// 'signalImage'
const String signalImageKey = 'signalImage';

/// 0xFF11131D
const int darkForestBackground = 0xFF11131D;

const Map<String, Object> ssDefaults = <String, Object>{
  ...empathetechConfig,
  darkBackgroundImageKey: darkForestPath,
  lightBackgroundImageKey: darkForestPath,
  signalImageKey: smokeSignalPath,
};

// Images //

/// 'assets/images/app-icon.png'
const String appIconPath = 'assets/images/app-icon.png';

/// 'assets/images/dark-forest.png'
const String darkForestPath = 'assets/images/dark-forest.png';

/// 'assets/images/smoke-signal.gif'
const String smokeSignalPath = 'assets/images/smoke-signal.gif';

/// Image path -> image source
final Map<String, String> credits = <String, String>{
  appIconPath: 'Empathetech LLC: The Founder\n\nUnnamed',
  smokeSignalPath: 'https://pimen.itch.io/\n\n\'Smoke Effect\'',
  darkForestPath: 'https://edermunizz.itch.io/\n\n\'Dark Forest\'',
};
