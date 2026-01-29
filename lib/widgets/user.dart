/* smoke_signal
 * Copyright (c) 2026 Empathetech LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import '../../api/export.dart';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:empathetech_flutter_ui/empathetech_flutter_ui.dart';

class NoUserCoin extends StatelessWidget {
  /// [Widget] to display when there are no users found
  const NoUserCoin({super.key});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onLongPress: () => showDialog(
          context: context,
          builder: (_) => const EzAlertDialog(
            title: Text('Nobody!', textAlign: TextAlign.center),
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: EzConfig.colors.primary,
            shape: BoxShape.circle,
          ),
          child: EzIcon(Icons.clear),
        ),
      );
}

class UserCoinScroll extends StatelessWidget {
  final List<User> users;

  /// A horizontal [EzScrollView] of the [users]' profile pictures
  const UserCoinScroll({super.key, required this.users});

  @override
  Widget build(BuildContext context) => (users.isEmpty)
      ? const NoUserCoin()
      : EzScrollView(
          scrollDirection: Axis.horizontal,
          children: users
              .map(
                (User user) => GestureDetector(
                  onLongPress: () => showDialog(
                    context: context,
                    builder: (_) => EzAlertDialog(
                      content: Text(
                        user.displayName,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  child: CircleAvatar(
                    foregroundImage: user.avatarURL != null
                        ? CachedNetworkImageProvider(user.avatarURL!)
                        : null,
                    minRadius: EzConfig.iconSize,
                    maxRadius: EzConfig.iconSize,
                  ),
                ),
              )
              .toList(),
        );
}

class UserProfileScroll extends StatelessWidget {
  final List<User> users;

  /// A vertical [EzScrollView] of the [users]' profile pictures and display names
  const UserProfileScroll({super.key, required this.users});

  @override
  Widget build(BuildContext context) => (users.isEmpty)
      ? const NoUserCoin()
      : EzScrollView(
          children: users
              .map(
                (User user) => Row(
                  children: <Widget>[
                    // Profile image/avatar
                    CircleAvatar(
                      foregroundImage: user.avatarURL != null
                          ? CachedNetworkImageProvider(user.avatarURL!)
                          : null,
                      minRadius: EzConfig.iconSize,
                      maxRadius: EzConfig.iconSize,
                    ),

                    // Display name
                    Text(
                      user.displayName,
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              )
              .toList(),
        );
}

class AddProfilesWindow extends StatelessWidget {
  final String title;
  final List<ListTile> items;
  final double? customHeight;

  /// Wraps [items]s in an [EzScrollView] with a [title]
  /// Optionally provide a height limit
  /// Defaults to [heightOf] / 3.0
  const AddProfilesWindow({
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
          color: EzConfig.colors.primary,
          borderRadius: ezRoundEdge,
        ),
        child: Column(
          children: <Widget>[
            Text(title, style: EzConfig.styles.titleLarge),
            EzScrollView(children: items),
          ],
        ),
      );
}
