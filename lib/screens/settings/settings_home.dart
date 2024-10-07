/* smoke_signal
 * Copyright (c) 2022-2024 Empathetech LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import '../export.dart';
import '../../widgets/export.dart';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:empathetech_flutter_ui/empathetech_flutter_ui.dart';

class SettingsHomeScreen extends StatefulWidget {
  const SettingsHomeScreen({super.key});

  @override
  State<SettingsHomeScreen> createState() => _AppSettingsState();
}

class _AppSettingsState extends State<SettingsHomeScreen> {
  // Gather the theme data //

  static const EzSpacer spacer = EzSpacer();
  static const EzSeparator separator = EzSeparator();

  late final EFUILang l10n = EFUILang.of(context)!;

  // Set the page title //

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setPageTitle(l10n.ssPageTitle, Theme.of(context).colorScheme.primary);
  }

  // Return the build //

  @override
  Widget build(BuildContext context) {
    return SmokeSignalScaffold(
      drawerHeader: const LoginHeader(),
      body: EzScreen(
        child: EzScrollView(
          children: <Widget>[
            // Functionality disclaimer
            EzWarning(
              body: kIsWeb ? l10n.ssSettingsGuideWeb : l10n.ssSettingsGuide,
            ),
            separator,

            // Global settings
            const EzDominantHandSwitch(),
            spacer,

            const EzThemeModeSwitch(),
            spacer,

            const EzLocaleSetting(),
            separator,

            // Text settings
            EzElevatedIconButton(
              onPressed: () => context.goNamed(textSettingsPath),
              icon: const Icon(Icons.navigate_next),
              label: l10n.tsPageTitle,
            ),
            spacer,

            // Layout settings
            EzElevatedIconButton(
              onPressed: () => context.goNamed(layoutSettingsPath),
              icon: const Icon(Icons.navigate_next),
              label: l10n.lsPageTitle,
            ),
            spacer,

            // Color settings
            EzElevatedIconButton(
              onPressed: () => context.goNamed(colorSettingsPath),
              icon: const Icon(Icons.navigate_next),
              label: l10n.csPageTitle,
            ),
            spacer,

            // Image settings
            EzElevatedIconButton(
              onPressed: () => context.goNamed(imageSettingsPath),
              icon: const Icon(Icons.navigate_next),
              label: l10n.isPageTitle,
            ),
            separator,

            // Reset button
            const EzResetButton(),
            spacer,
          ],
        ),
      ),
    );
  }
}
