/* smoke_signal
 * Copyright (c) 2026 YWT (Empathetech LLC). All rights reserved.
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
import 'package:open_ui/open_ui.dart';

class SmokeSignalDrawer extends StatelessWidget {
  final EzCP config;
  final Widget header;
  final List<Widget>? extraButtons;

  const SmokeSignalDrawer(this.config, {super.key, required this.header, this.extraButtons});

  // Return the build //

  @override
  Widget build(BuildContext context) => NavigationDrawer(
        tilePadding: EdgeInsets.zero,
        children: <Widget>[
          header,
          config.spacer,

          // GoTo settings
          EzTextIconButton(
            config,
            style: TextButton.styleFrom(backgroundColor: config.colors.surfaceDim),
            onPressed: () {
              Navigator.of(context).pop();
              context.goNamed(settingsHubPath);
            },
            icon: const Icon(Icons.settings),
            label: 'Settings',
          ),
          config.spacer,

          // Show input rules
          EzTextIconButton(
            config,
            style: TextButton.styleFrom(backgroundColor: config.colors.surfaceDim),
            onPressed: () => showDialog(
              context: context,
              builder: (_) => EzAlertDialog(
                config,
                title: const Text('Input rules', textAlign: TextAlign.center),
                content: const Text(inputRules, textAlign: TextAlign.center),
              ),
            ),
            icon: const Icon(Icons.rule),
            label: 'Input rules',
          ),

          if (extraButtons != null) ...<Widget>[config.spacer, ...extraButtons!],
        ],
      );
}

class LoginHeader extends StatelessWidget {
  final EzCP config;

  const LoginHeader(this.config, {super.key});

  @override
  Widget build(BuildContext context) {
    final double iconSize = ezImageSize(config, context: context) * 0.667;

    return DrawerHeader(
      margin: EdgeInsets.all(config.marginVal),
      padding: EdgeInsets.zero,
      child: Center(
        child: EzScrollView(
          config,
          scrollDirection: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              constraints: BoxConstraints(maxHeight: iconSize),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(iconSize),
                child: const EzImage(image: appIcon, semanticLabel: 'App icon'),
              ),
            ),
            config.rowSpacer,
            Text("Sign in,\nfire's warm", textAlign: TextAlign.center, style: config.titleStyle),
          ],
        ),
      ),
    );
  }
}

class LoggedInHeader extends StatelessWidget {
  final EzCP config;

  const LoggedInHeader(this.config, {super.key});

  @override
  Widget build(BuildContext context) {
    final double iconSize = ezImageSize(config, context: context) * 0.667;
    final AppUser? appUser = Provider.of<AppUserProvider>(context).value;

    return DrawerHeader(
      margin: EdgeInsets.all(config.marginVal),
      padding: EdgeInsets.zero,
      child: Center(
        child: EzScrollView(
          config,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // Profile name and picture

            // Name
            Flexible(
              child: Text(appUser?.displayName ?? defaultDisplayName, style: config.titleStyle),
            ),
            config.margin,

            // Picture
            Container(
              constraints: BoxConstraints(maxHeight: iconSize),
              decoration: BoxDecoration(
                border: Border.all(color: config.colors.primary),
                borderRadius: BorderRadius.circular(iconSize),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(iconSize),
                child: EzImageLink(
                  config,
                  onTap: () {
                    Navigator.of(context).pop();
                    context.goNamed(profileSettingsPath);
                  },
                  label: 'Profile image.',
                  hint: 'Activate to edit.',
                  tooltip: 'Edit profile',
                  image: CachedNetworkImageProvider(appUser?.avatarURL ?? defaultAvatarURL),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
