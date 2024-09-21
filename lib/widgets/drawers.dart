/* smoke_signal
 * Copyright (c) 2022-2024 Empathetech LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import '../utils/export.dart';
import '../screens/export.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:empathetech_ss_api/empathetech_ss_api.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:empathetech_flutter_ui/empathetech_flutter_ui.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

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
        .copyWith(decoration: TextDecoration.none);

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
          backgroundColor: Colors.transparent,
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

/// Circle avatar of the app's icon
/// For use on screen in which settings should be available, but no user is logged in
const Widget standardDrawerHeader = DrawerHeader(
  margin: EdgeInsets.zero,
  padding: EdgeInsets.zero,
  child: EzScrollView(
    scrollDirection: Axis.horizontal,
    mainAxisSize: MainAxisSize.min,
    child: CircleAvatar(
      backgroundImage: AssetImage(appIconPath),
      minRadius: 50,
      maxRadius: 50,
    ),
  ),
);

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
