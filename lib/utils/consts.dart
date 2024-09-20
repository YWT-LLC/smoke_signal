/* smoke_signal
 * Copyright (c) 2022-2024 Empathetech LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import 'package:empathetech_flutter_ui/empathetech_flutter_ui.dart';

// App config //

/// 'Smoke Signal'
const String appTitle = 'Smoke Signal';

/// 'signalImage'
const String signalImageKey = 'signalImage';

/// '200.0'
const double signalHeight = 200.0;

/// '100.0'
const double signalCountHeight = 100.0;

const Map<String, Object> ssDefaults = <String, Object>{
  ...empathetechConfig,
  darkBackgroundImageKey: darkForestPath,
  lightBackgroundImageKey: lightForestPath,
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
const Set<String> assets = <String>{
  appIconPath,
  darkForestPath,
  lightForestPath,
  smokeSignalPath,
};

/// Image path -> image source
const Map<String, String> credits = <String, String>{
  appIconPath: 'Empathetech LLC: The Founder\n\nUnnamed',
  darkForestPath: 'https://edermunizz.itch.io/\n\n\'Dark Forest\'',
  lightForestPath: 'https://ansimuz.itch.io/\n\n\'Light Forest\'',
  smokeSignalPath: 'https://pimen.itch.io/\n\n\'Smoke Effect\'',
};
