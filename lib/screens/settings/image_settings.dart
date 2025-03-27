/* smoke_signal
 * Copyright (c) 2025 Empathetech LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import '../../utils/consts.dart';
import '../../widgets/export.dart';

import 'package:flutter/material.dart';
import 'package:empathetech_flutter_ui/empathetech_flutter_ui.dart';

class ImageSettingsScreen extends StatelessWidget {
  const ImageSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SmokeSignalScaffold(
      drawerHeader: const LoginHeader(),
      body: EzImageSettings(
        darkBackgroundCredits: credits[darkForestPath],
        lightBackgroundCredits: credits[lightForestPath],
        additionalSettings: <Widget>[
          EzImageSetting(
            configKey: signalImageKey,
            label: 'Signal',
            credits: credits[smokeSignalPath],
            allowClear: false,
            updateThemeOption: false,
            showFitOption: false,
          ),
        ],
      ),
      fab: EzBackFAB(context),
    );
  }
}
