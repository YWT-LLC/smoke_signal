/* smoke_signal
 * Copyright (c) 2022-2024 Empathetech LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import '../export.dart';

import 'package:empathetech_flutter_ui/empathetech_flutter_ui.dart';

import 'package:flutter/material.dart';

class AppSettingsScreen extends StatefulWidget {
  const AppSettingsScreen({Key? key}) : super(key: key);

  @override
  _AppSettingsState createState() => _AppSettingsState();
}

class _AppSettingsState extends State<AppSettingsScreen> {
  Color themeColor = Color(EzConfig.prefs[themeColorKey]);
  Color themeTextColor = Color(EzConfig.prefs[themeTextColorKey]);
  Color buttonColor = Color(EzConfig.prefs[buttonColorKey]);

  @override
  Widget build(BuildContext context) {
    double buttonSpacer = EzConfig.prefs[buttonSpacingKey];
    double dialogSpacer = EzConfig.prefs[dialogSpacingKey];

    return EzScaffold(
      background: BoxDecoration(color: Color(EzConfig.prefs[backColorKey])),
      appBar: EzAppBar(
          title:
              Text('Settings', style: buildTextStyle(styleKey: titleStyleKey))),

      // Body
      body: ezView(
        context: context,
        background: BoxDecoration(
          image: DecorationImage(image: EzImage.getProvider(backImageKey)),
        ),
        body: EzScrollView(
          children: [
            warningCard(
              context: context,
              warning: 'Changes won\'t take effect until restart',
            ),
            Container(height: 2 * buttonSpacer),

            // Colors
            EzButton(
              action: () =>
                  pushScreen(context: context, screen: ColorSettingsScreen()),
              body: Text('Colors'),
            ),
            Container(height: buttonSpacer),

            // Images
            EzButton(
              action: () =>
                  pushScreen(context: context, screen: ImageSettingsScreen()),
              body: Text('Images'),
            ),
            Container(height: buttonSpacer),

            // Styling
            EzButton(
              action: () =>
                  pushScreen(context: context, screen: StyleSettingsScreen()),
              body: Text('Styling'),
            ),
            Container(height: 2 * buttonSpacer),

            // Reset all signal settings
            GestureDetector(
              onTap: () => showPlatformDialog(
                context: context,
                dialog: EzAlertDialog(
                  title: Text(
                    'Reset all settings?',
                    style: buildTextStyle(styleKey: dialogTitleStyleKey),
                  ),
                  contents: [
                    ezYesNo(
                      context: context,
                      onConfirm: () {
                        EzConfig.prefs.forEach((key, value) {
                          // Note we iterate rather than .clear()
                          // As [EzConfig.preferences] might contain custom [File] paths
                          EzConfig.preferences.remove(key);
                        });

                        Navigator.of(context).pop(true);
                        Navigator.of(context).pop(true);
                      },
                      onDeny: () => Navigator.of(context).pop(),
                      axis: Axis.vertical,
                      spacer: dialogSpacer,
                    ),
                  ],
                  needsClose: false,
                ),
              ),
              child: Text(
                'Reset all',
                style: buildTextStyle(styleKey: subTitleStyleKey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
