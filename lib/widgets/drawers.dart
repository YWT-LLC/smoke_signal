/* smoke_signal
 * Copyright (c) 2022-2024 Empathetech LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import './export.dart';
import '../screens/export.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:empathetech_ss_api/empathetech_ss_api.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:empathetech_flutter_ui/empathetech_flutter_ui.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

/// 90.0; Chosen via visual inspection
const double imageSize = 90.0;

class SmokeSignalDrawer extends StatelessWidget {
  final Widget header;

  /// Universal [NavigationDrawer] for Smoke Signal
  const SmokeSignalDrawer({
    super.key,
    required this.header,
  });

  static const EzSpacer _spacer = EzSpacer();

  // Return the build //

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
        _spacer,
      ],
    );
  }
}

/// [appIcon] and welcome [Text] in a horizontal [EzScrollView]
class StandardHeader extends StatelessWidget {
  const StandardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return DrawerHeader(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      child: Center(
        child: EzScrollView(
          scrollDirection: Axis.horizontal,
          mainAxisSize: MainAxisSize.max,
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

/// Custom drawer header for Signal Board
/// Show profile information, GoTo profile settings, and logout
Widget signalDrawerHeader(BuildContext context, void Function() refresh) {
  return Row(
    mainAxisSize: MainAxisSize.max,
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: <Widget>[
      // Profile image and name
      Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          // Profile image
          CircleAvatar(
            foregroundImage: CachedNetworkImageProvider(
              AppUser.account.photoURL ?? defaultAvatarURL,
            ),
            minRadius: 50,
            maxRadius: 50,
          ),

          // Profile name
          Text(
            AppUser.account.displayName ?? defaultDisplayName,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ],
      ),

      // Edit and logout buttons
      Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          // Edit
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.goNamed(profileSettingsPath);
            },
            icon: Icon(PlatformIcons(context).edit),
          ),
          const EzSpacer(),

          // Logout
          IconButton(
            onPressed: () => logout(context),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
    ],
  );
}
