/* smoke_signal
 * Copyright (c) 2026 YWT (Empathetech LLC). All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import '../../api/export.dart';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:open_ui/open_ui.dart';

class NoUserCoin extends StatelessWidget {
  final EzCP config;

  const NoUserCoin(this.config, {super.key});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onLongPress: () => showDialog(
      context: context,
      builder: (_) =>
          EzAlertDialog(config, title: const Text('Nobody!', textAlign: TextAlign.center)),
    ),
    child: Container(
      decoration: BoxDecoration(color: config.colors.primary, shape: BoxShape.circle),
      child: EzIcon(config, Icons.clear),
    ),
  );
}

class UserCoinScroll extends StatelessWidget {
  final EzCP config;
  final List<User> users;

  const UserCoinScroll(this.config, {super.key, required this.users});

  @override
  Widget build(BuildContext context) => (users.isEmpty)
      ? NoUserCoin(config)
      : EzScrollView(
          config,
          scrollDirection: Axis.horizontal,
          children: users
              .map(
                (User user) => GestureDetector(
                  onLongPress: () => showDialog(
                    context: context,
                    builder: (_) => EzAlertDialog(
                      config,
                      content: Text(user.displayName, textAlign: TextAlign.center),
                    ),
                  ),
                  child: CircleAvatar(
                    foregroundImage: user.avatarURL != null
                        ? CachedNetworkImageProvider(user.avatarURL!)
                        : null,
                    minRadius: config.iconSize,
                    maxRadius: config.iconSize,
                  ),
                ),
              )
              .toList(),
        );
}

class UserProfileScroll extends StatelessWidget {
  final EzCP config;
  final List<User> users;

  const UserProfileScroll(this.config, {super.key, required this.users});

  @override
  Widget build(BuildContext context) => (users.isEmpty)
      ? NoUserCoin(config)
      : EzScrollView(
          config,
          children: users
              .map(
                (User user) => Row(
                  children: <Widget>[
                    // Profile image/avatar
                    CircleAvatar(
                      foregroundImage: user.avatarURL != null
                          ? CachedNetworkImageProvider(user.avatarURL!)
                          : null,
                      minRadius: config.iconSize,
                      maxRadius: config.iconSize,
                    ),

                    // Display name
                    Text(user.displayName, textAlign: TextAlign.start),
                  ],
                ),
              )
              .toList(),
        );
}

class AddProfilesWindow extends StatelessWidget {
  final EzCP config;
  final String title;
  final List<ListTile> items;
  final double? customHeight;

  const AddProfilesWindow(
    this.config, {
    super.key,
    required this.title,
    required this.items,
    this.customHeight,
  });

  @override
  Widget build(BuildContext context) => Container(
    width: widthOf(context),
    height: customHeight ?? heightOf(context) / 3.0,
    decoration: BoxDecoration(
      color: config.colors.primary,
      borderRadius: config.textRadius,
    ), // TODO: shape? there's others too
    child: Column(
      children: <Widget>[
        Text(title, style: config.titleStyle),
        EzScrollView(config, children: items),
      ],
    ),
  );
}
