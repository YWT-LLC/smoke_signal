/* smoke_signal
 * Copyright (c) 2026 YWT (Empathetech LLC). All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import 'package:flutter/material.dart';
import 'package:open_ui/open_ui.dart';

//* App config *//

/// Smoke Signal
const String appName = 'Smoke Signal';

/// llc.ywt.smoke_signal
const String androidPackage = 'llc.ywt.smoke_signal';

// Local assets //

const String appIconPath = 'assets/images/app-icon.png';
const String darkForestPath = 'assets/images/dark-forest.png';
const String lightForestPath = 'assets/images/light-forest.png';
const String smokeSignalPath = 'assets/images/smoke-signal.gif';

/// Entries for [EzCM.init]
const Set<String> assetPaths = <String>{
  appIconPath,
  darkForestPath,
  lightForestPath,
  smokeSignalPath,
};

/// Image path -> image creator
const Map<String, dynamic> credits = <String, dynamic>{
  appIconPath: 'The Founder',
  darkForestPath: 'https://edermunizz.itch.io/',
  lightForestPath: 'https://ansimuz.itch.io/',
  smokeSignalPath: 'https://pimen.itch.io/',
};

//* EzConfig *//

final Map<String, Object> mobileSmokeSignalConfig = <String, Object>{
  ...ywtMobileConfig,

  // Design
  darkBackgroundImageKey: darkForestPath,
  darkBackgroundFitKey: BoxFit.fill.name,

  lightBackgroundImageKey: lightForestPath,
  lightBackgroundFitKey: BoxFit.fill.name,

  // Text
  darkTextBackgroundOpacityKey: 0.35,
  lightTextBackgroundOpacityKey: 0.70,
};

final Map<String, Object> desktopSmokeSignalConfig = <String, Object>{
  ...ywtDesktopConfig,

  // Design
  darkBackgroundImageKey: darkForestPath,
  darkBackgroundFitKey: BoxFit.fill.name,

  lightBackgroundImageKey: lightForestPath,
  lightBackgroundFitKey: BoxFit.fill.name,

  // Text
  darkTextBackgroundOpacityKey: 0.35,
  lightTextBackgroundOpacityKey: 0.70,
};

const Map<String, Type> allSmokeSignalKeys = <String, Type>{
  ...allEZConfigKeys,
};

//* API *//

/// defDN -> default display name -> Anon
const String defDN = 'Anon';

/// 'https://raw.githubusercontent.com/YWT-LLC/smoke_signal/main/assets/app-icon.png'
const String defThumbUrl =
    'https://raw.githubusercontent.com/YWT-LLC/smoke_signal/main/assets/app-icon.png';

// Paths //

/// users
const String usersPath = 'users';

/// displayName
const String displayNamePath = 'displayName';

/// avatarURL
const String avatarURLPath = 'avatarURL';

/// signals
const String signalsPath = 'signals';

/// owner
const String ownerPath = 'owner';

/// message
const String messagePath = 'message';

/// members
const String membersPath = 'members';

/// activeMembers
const String activeMembersPath = 'activeMembers';

/// memberRequests
const String memberRequestsPath = 'memberRequests';
