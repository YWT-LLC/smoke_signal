/* smoke_signal
 * Copyright (c) 2026 Empathetech LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import 'package:flutter/material.dart';
import 'package:empathetech_flutter_ui/empathetech_flutter_ui.dart';

const Widget updater = EzUpdaterFAB(
  appVersion: '2.0.0',
  versionSource:
      'https://raw.githubusercontent.com/Empathetech-LLC/smoke_signal/refs/heads/main/APP_VERSION',
  gPlay: 'https://play.google.com/store/apps/details?id=net.empathetech.BLARG',
  appStore: 'https://apps.apple.com/us/app/BLARG/BLARG',
  github: 'https://github.com/Empathetech-LLC/smoke_signal/releases',
);
