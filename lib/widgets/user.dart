/* smoke_signal
 * Copyright (c) 2025 Empathetech LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */

import '../../api/export.dart';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:empathetech_flutter_ui/empathetech_flutter_ui.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class NoUserCoin extends StatelessWidget {
  /// [Widget] to display when there are no users found
  const NoUserCoin({super.key});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onLongPress: () => showPlatformDialog(
          context: context,
          builder: (_) => EzAlertDialog(
            title: const Text('Nobody!', textAlign: TextAlign.center),
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            shape: BoxShape.circle,
          ),
          child: EzIcon(PlatformIcons(context).clear),
        ),
      );
}

class UserCoinScroll extends StatelessWidget {
  final List<User> users;

  /// A horizontal [EzScrollView] of the [users]' profile pictures
  const UserCoinScroll({super.key, required this.users});

  @override
  Widget build(BuildContext context) {
    final double iconSize = EzConfig.get(iconSizeKey);

    return (users.isEmpty)
        ? const NoUserCoin()
        : EzScrollView(
            scrollDirection: Axis.horizontal,
            children: users
                .map(
                  (User user) => GestureDetector(
                    onLongPress: () => showPlatformDialog(
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
                      minRadius: iconSize,
                      maxRadius: iconSize,
                    ),
                  ),
                )
                .toList(),
          );
  }
}

class UserProfileScroll extends StatelessWidget {
  final List<User> users;

  /// A vertical [EzScrollView] of the [users]' profile pictures and display names
  const UserProfileScroll({super.key, required this.users});

  @override
  Widget build(BuildContext context) {
    final double iconSize = EzConfig.get(iconSizeKey);

    return (users.isEmpty)
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
                        minRadius: iconSize,
                        maxRadius: iconSize,
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
}

class AddProfilesWindow extends StatelessWidget {
  final String title;
  final List<PlatformListTile> items;
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
          color: Theme.of(context).colorScheme.primary,
          borderRadius: ezRoundEdge,
        ),
        child: Column(
          children: <Widget>[
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            EzScrollView(children: items),
          ],
        ),
      );
}
