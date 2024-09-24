/* smoke_signal
 * Copyright (c) 2022-2024 Empathetech LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import './export.dart';
import '../utils/export.dart';
import '../screens/export.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:empathetech_ss_api/empathetech_ss_api.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:empathetech_flutter_ui/empathetech_flutter_ui.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class SmokeSignalDrawer extends StatelessWidget {
  /// Recommended to use [DrawerHeader]
  final Widget header;

  /// Universal [NavigationDrawer] for Smoke Signal
  const SmokeSignalDrawer({super.key, required this.header});

  // Return the build //

  static const EzSpacer _spacer = EzSpacer();

  @override
  Widget build(BuildContext context) {
    final TextStyle style = Theme.of(context)
        .textTheme
        .titleLarge!
        .copyWith(fontWeight: FontWeight.normal);

    return NavigationDrawer(
      tilePadding: EdgeInsets.zero,
      children: <Widget>[
        header,
        _spacer,

        // GoTo settings
        EzLink(
          'Settings',
          style: style,
          icon: Icon(PlatformIcons(context).settings),
          onTap: () {
            Navigator.of(context).pop();
            context.goNamed(settingsPath);
          },
          semanticsLabel: 'Settings',
        ),
        _spacer,

        // Show input rules
        EzLink(
          'Input rules',
          style: style,
          icon: const Icon(Icons.rule),
          onTap: () => showPlatformDialog(
            context: context,
            builder: (_) => EzAlertDialog(
              title: const Text('Input rules', textAlign: TextAlign.center),
              content: const Text(inputRules, textAlign: TextAlign.center),
            ),
          ),
          semanticsLabel: 'Input rules',
        ),
      ],
    );
  }
}

/// [appIcon] and welcome [Text] in a horizontal [EzScrollView]
class LoginHeader extends StatelessWidget {
  /// [DrawerHeader] for screens where their is no user logged in
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      margin: EzMargin(),
      padding: EdgeInsets.zero,
      child: Center(
        child: EzScrollView(
          scrollDirection: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.textScalerOf(context).scale(imageSize),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(imageSize),
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
              style: Theme.of(context).textTheme.titleLarge,
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
    return DrawerHeader(
      margin: EzMargin(),
      padding: EdgeInsets.zero,
      child: Center(
        child: EzScrollView(
          scrollDirection: Axis.horizontal,
          reverseHands: true,
          children: <Widget>[
            // Profile name and logout button
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment
                  .spaceEvenly, // TODO: Are you sure about that?
              children: <Widget>[
                // Name
                Text(
                  AppUser.account.displayName ?? defaultDisplayName,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                EzSpacer(space: EzConfig.get(paddingKey)),

                // Logout
                IconButton(
                  onPressed: () => logout(context),
                  icon: const Icon(Icons.logout),
                ),
              ],
            ),
            const EzSeparator(vertical: false),

            // Profile link image
            Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.textScalerOf(context).scale(imageSize),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(imageSize),
                child: EzLinkImageProvider(
                  onTap: () {
                    Navigator.of(context).pop();
                    context.goNamed(profileSettingsPath);
                  },
                  semanticLabel: 'Profile image: activate to edit',
                  tooltip: 'Edit profile',
                  image: CachedNetworkImageProvider(
                    AppUser.account.photoURL ?? defaultAvatarURL,
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
