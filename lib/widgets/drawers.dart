/* smoke_signal
 * Copyright (c) 2026 Empathetech LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import './export.dart';
import '../../api/export.dart';
import '../utils/export.dart';
import '../screens/export.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:empathetech_flutter_ui/empathetech_flutter_ui.dart';

class SmokeSignalDrawer extends StatelessWidget {
  /// Recommended to use [DrawerHeader]
  final Widget header;

  /// Optional [extraButtons]
  final List<Widget>? extraButtons;

  /// Universal [NavigationDrawer] for Smoke Signal
  const SmokeSignalDrawer({super.key, required this.header, this.extraButtons});

  // Return the build //

  @override
  Widget build(BuildContext context) => NavigationDrawer(
        tilePadding: EdgeInsets.zero,
        children: <Widget>[
          header,
          EzConfig.spacer,

          // GoTo settings
          EzTextIconButton(
            style: TextButton.styleFrom(
                backgroundColor: EzConfig.colors.surfaceDim),
            onPressed: () {
              Navigator.of(context).pop();
              context.goNamed(settingsHomePath);
            },
            icon: const Icon(Icons.settings),
            label: 'Settings',
          ),
          EzConfig.spacer,

          // Show input rules
          EzTextIconButton(
            style: TextButton.styleFrom(
                backgroundColor: EzConfig.colors.surfaceDim),
            onPressed: () => showDialog(
              context: context,
              builder: (_) => const EzAlertDialog(
                title: Text('Input rules', textAlign: TextAlign.center),
                content: Text(inputRules, textAlign: TextAlign.center),
              ),
            ),
            icon: const Icon(Icons.rule),
            label: 'Input rules',
          ),

          if (extraButtons != null) ...<Widget>[
            EzConfig.spacer,
            ...extraButtons!,
          ],
        ],
      );
}

/// [appIcon] and welcome [Text] in a horizontal [EzScrollView]
class LoginHeader extends StatelessWidget {
  /// [DrawerHeader] for screens where their is no user logged in
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final double iconSize = ezImageSize(context) * 0.667;

    return DrawerHeader(
      margin: EdgeInsets.all(EzConfig.marginVal),
      padding: EdgeInsets.zero,
      child: Center(
        child: EzScrollView(
          scrollDirection: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              constraints: BoxConstraints(maxHeight: iconSize),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(iconSize),
                child: const EzImage(
                  image: appIcon,
                  semanticLabel: 'App icon',
                ),
              ),
            ),
            const EzSpacer(vertical: false),
            Text(
              "Sign in,\nfire's warm",
              textAlign: TextAlign.center,
              style: EzConfig.styles.titleLarge,
            ),
          ],
        ),
      ),
    );
  }
}

class LoggedInHeader extends StatelessWidget {
  /// [DrawerHeader] for screens where the user is logged in
  const LoggedInHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final double iconSize = ezImageSize(context) * 0.667;
    final AppUser? appUser = Provider.of<AppUserProvider>(context).value;

    return DrawerHeader(
      margin: EdgeInsets.all(EzConfig.marginVal),
      padding: EdgeInsets.zero,
      child: Center(
        child: EzScrollView(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // Profile name and picture

            // Name
            Flexible(
              child: Text(
                appUser?.displayName ?? defaultDisplayName,
                style: EzConfig.styles.titleLarge,
              ),
            ),
            EzConfig.margin,

            // Picture
            Container(
              constraints: BoxConstraints(maxHeight: iconSize),
              decoration: BoxDecoration(
                border: Border.all(color: EzConfig.colors.primary),
                borderRadius: BorderRadius.circular(iconSize),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(iconSize),
                child: EzImageLink(
                  onTap: () {
                    Navigator.of(context).pop();
                    context.goNamed(profileSettingsPath);
                  },
                  label: 'Profile image.',
                  hint: 'Activate to edit.',
                  tooltip: 'Edit profile',
                  image: CachedNetworkImageProvider(
                    appUser?.avatarURL ?? defaultAvatarURL,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
