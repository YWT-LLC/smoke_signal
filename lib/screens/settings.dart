/* open_ui
 * Copyright (c) 2026 Empathetech LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import '../../utils/export.dart';
import '../../widgets/export.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:empathetech_flutter_ui/empathetech_flutter_ui.dart';

class SettingsHubScreen extends StatelessWidget {
  final int? target;

  const SettingsHubScreen({this.target, super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<EzCP>(
      builder: (_, EzCP config, __) => SmokeSignalScaffold(
        config,
        drawerHeader: LoginHeader(config),
        body: EzScreen(
          config,
          child: EzSettingsHub(
            config,
            pages: <EzSettingsSection>[
              // Global //

              EzSettingsSection(
                position: 0,
                title: config.ezL10n.gGlobal,
                icon: EzIcon(
                  config,
                  EzCM.onMobile
                      ? EzCM.platform == TargetPlatform.iOS
                          ? Icons.phone_iphone
                          : Icons.phone_android
                      : Icons.computer,
                  semanticLabel: config.ezL10n.gGlobal,
                ),
                subSettings: <EzSubSetting>[],
                fromStorage: () => EzSubSetting.blank,
                build: (_) => EzGlobalSettings(config),
              ),

              // Color //

              EzSettingsSection(
                position: 1,
                title: config.ezL10n.gColor,
                icon: EzIcon(
                  config,
                  Icons.palette,
                  semanticLabel: config.ezL10n.gColor,
                ),
                subSettings: <EzSubSetting>[
                  EzSubSetting.qckColor,
                  EzSubSetting.advColor,
                ],
                fromStorage: () => EzCM.get(advancedColorsKey) == true
                    ? EzSubSetting.advColor
                    : EzSubSetting.qckColor,
                build: (EzSubSetting subSec) => EzColorSettings(config, target: subSec),
              ),

              // Design //

              EzSettingsSection(
                position: 2,
                title: config.ezL10n.gDesign,
                icon: EzIcon(
                  config,
                  Icons.design_services,
                  semanticLabel: config.ezL10n.gDesign,
                ),
                subSettings: <EzSubSetting>[
                  EzSubSetting.butDesign,
                  EzSubSetting.pagDesign,
                ],
                fromStorage: () =>
                    EzCM.get(pageTabKey) == true ? EzSubSetting.pagDesign : EzSubSetting.butDesign,
                build: (EzSubSetting subSec) => EzDesignSettings(
                  config,
                  target: subSec,
                  appendButton: <Widget>[
                    EzImageSetting(
                      config,
                      pathKey: config.isDark ? darkSignalImageKey : lightSignalImageKey,
                      fitKey: config.isDark ? darkSignalImageFitKey : lightSignalImageFitKey,
                      label: 'Signal',
                      allowClear: false,
                      showFitOption: false,
                    ), // TODO: is update the theme always there? remove plz
                  ],
                ),
              ),

              // Text //

              EzSettingsSection(
                position: 3,
                title: config.ezL10n.gText,
                icon: EzIcon(
                  config,
                  Icons.text_format,
                  semanticLabel: config.ezL10n.gText,
                ),
                subSettings: <EzSubSetting>[
                  EzSubSetting.qckText,
                  EzSubSetting.advText,
                ],
                fromStorage: () =>
                    EzCM.get(advancedTextKey) == true ? EzSubSetting.advText : EzSubSetting.qckText,
                build: (EzSubSetting subSec) => EzTextSettings(config, target: subSec),
              ),
            ],
            target: target,
          ),
        ),
        fabs: <Widget>[
          // Rebuild (conditional)
          if (config.needsRebuild) ...<Widget>[
            config.spacer,
            EzRebuildFAB(config),
          ],

          // Save/upload config
          config.spacer,
          EzConfigFAB(config),
        ],
      ),
    );
  }
}
