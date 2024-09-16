/* smoke_signal
 * Copyright (c) 2022-2024 Empathetech LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import 'package:smoke_signal/utils/constants.dart';

import '../../widgets/export.dart';

import 'package:flutter/material.dart';
import 'package:empathetech_flutter_ui/empathetech_flutter_ui.dart';

class ImageSettingsScreen extends StatefulWidget {
  const ImageSettingsScreen({super.key});

  @override
  State<ImageSettingsScreen> createState() => _ImageSettingsScreenState();
}

class _ImageSettingsScreenState extends State<ImageSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return const SmokeSignalScaffold(
      body: ImageSettings(
        lightBackgroundImageKey: lightBackgroundImageKey,
        darkBackgroundImageKey: darkBackgroundImageKey,
        additionalSettings: <Widget>[
          EzImageSetting(
            configKey: signalImageKey,
            label: 'Signal',
            // dialogTitle: ,
            // credits: ,
            allowClear: false,
            updateThemeOption: false,
          ),
        ],
      ),
    );
  }
}
