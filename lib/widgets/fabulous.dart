/* smoke_signal
 * Copyright (c) 2026 YWT (Empathetech LLC). All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import 'package:open_ui/open_ui.dart';
import 'package:ywt_private/ywt_private.dart' as ywt;

EzUpdaterFAB updater(EzCP config) => EzUpdaterFAB(
      config,
      appVersion: '2.0.0',
      versionSource:
          'https://raw.githubusercontent.com/YWT-LLC/smoke_signal/refs/heads/main/APP_VERSION',
      gPlay: ywt.smokeSignalGPlay,
      appStore: ywt.smokeSignalAppStore,
      github: ywt.smokeSignalReleases,
    );
