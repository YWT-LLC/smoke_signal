/* smoke_signal
 * Copyright (c) 2026 YWT (Empathetech LLC). All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import 'package:open_ui/open_ui.dart';

EzUpdaterFAB updater(EzCP config) => EzUpdaterFAB(
      config,
      appVersion: '2.0.0',
      versionSource:
          'https://raw.githubusercontent.com/YWT-LLC/smoke_signal/refs/heads/main/APP_VERSION',
      gPlay: 'https://play.google.com/store/apps/details?id=llc.ywt.BLARG',
      appStore: 'https://apps.apple.com/us/app/BLARG/BLARG',
      github: 'https://github.com/YWT-LLC/smoke_signal/releases',
    );
